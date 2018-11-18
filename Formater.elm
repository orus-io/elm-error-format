module Formater exposing (..)

import Writer exposing (Writer)
import Buffer
import Json
import Url
import Reader
    exposing
        ( Reader
        , InputChar
        , toChar
        )


-- Types


type ComplexType
    = List
    | Record
    | Tuple


type StringState
    = NoString
    | FirstChar
    | InString
    | JsonString Json.Formater
    | UrlString Url.Formater



-- Main


read :
    Char
    -> ( Reader, ( Formater, Writer msg ) )
    -> ( Reader, ( Formater, Writer msg ) )
read c ( reader, ( formater, writer ) ) =
    let
        newReader =
            Reader.parseChar c reader

        ( newFormater, newWriter ) =
            case newReader.current of
                Just i ->
                    parseInputChar i ( formater, writer )

                Nothing ->
                    ( formater, writer )
    in
        ( newReader, ( newFormater, newWriter ) )



-- Formater


type alias FormaterOptions =
    { stringColor : String }


defaultOptions : FormaterOptions
defaultOptions =
    { stringColor = "teal" }


type alias Formater =
    { options : FormaterOptions
    , contextStack : List ComplexType
    , stringState : StringState
    , escapeNext : Bool
    }


new : FormaterOptions -> Formater
new options =
    { options = options
    , contextStack = []
    , stringState = NoString
    , escapeNext = False
    }


pushContext : ComplexType -> Formater -> Formater
pushContext t f =
    { f
        | contextStack = t :: f.contextStack
    }


popContext : Formater -> Formater
popContext f =
    { f | contextStack = List.drop 1 f.contextStack }


currentContext : Formater -> Maybe ComplexType
currentContext f =
    List.head f.contextStack



-- Parser


openContext :
    ComplexType
    -> InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
openContext t v ( formater, writer ) =
    ( formater
        |> pushContext t
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.indent
        >> Writer.appendToBuffer (toChar v)
        >> Writer.appendSingleSpace
    )


closeContext :
    ComplexType
    -> InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
closeContext t v ( formater, writer ) =
    ( formater
        |> popContext
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.writeText (String.fromChar <| toChar v)
        >> Writer.flushCurrentLine
        >> Writer.unindent
    )


checkUrl : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
checkUrl c ( formater, writer ) =
    case formater.stringState of
        InString ->
            if
                (not (Buffer.isEmpty writer.buffer)
                    && Buffer.length writer.buffer
                    == 5
                    && Buffer.take 4 writer.buffer
                    == [ 'p', 't', 't', 'h' ]
                )
            then
                ( { formater
                    | stringState = UrlString Url.init
                  }
                , writer
                )
            else
                ( formater, writer )

        _ ->
            ( formater, writer )


parseInputChar : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseInputChar c ( formater, writer ) =
    case ( formater.stringState, c ) of
        ( JsonString jsonFormater, Reader.Escaped '\\' ) ->
            let
                ( newJsonFormater, newWriter ) =
                    Json.parseChar (Reader.Escaped '\\') ( jsonFormater, writer )
            in
                ( { formater
                    | stringState = JsonString newJsonFormater
                  }
                , newWriter
                )

        ( NoString, Reader.LBrace ) ->
            ( formater, writer ) |> openContext Record Reader.LBrace

        ( NoString, Reader.RBrace ) ->
            ( formater, writer ) |> closeContext Record Reader.RBrace

        ( NoString, Reader.LBracket ) ->
            ( formater, writer ) |> openContext List Reader.LBracket

        ( NoString, Reader.RBracket ) ->
            ( formater, writer ) |> closeContext List Reader.RBracket

        ( NoString, Reader.LParenthesis ) ->
            ( formater
                |> pushContext Tuple
            , writer
                |> Writer.appendToBuffer '('
                >> Writer.appendSingleSpace
            )

        ( NoString, Reader.RParenthesis ) ->
            ( formater
                |> popContext
            , writer
                |> Writer.appendSingleSpace
                >> Writer.appendToBuffer ')'
            )

        ( NoString, Reader.Comma ) ->
            case currentContext formater of
                Just Tuple ->
                    ( formater
                    , writer
                        |> Writer.appendToBuffer ','
                        >> Writer.appendSingleSpace
                    )

                _ ->
                    ( formater
                    , writer
                        |> Writer.flushBufferAsText
                        >> Writer.flushCurrentLine
                        >> Writer.appendToBuffer ','
                        >> Writer.appendSingleSpace
                    )

        ( NoString, Reader.DoubleQuote ) ->
            ( { formater | stringState = FirstChar }
            , writer
                |> Writer.flushBufferAsText
            )

        ( FirstChar, Reader.Escaped c ) ->
            ( formater
            , writer
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer c
            )

        ( FirstChar, Reader.DoubleQuote ) ->
            ( { formater | stringState = NoString }
            , writer
                |> Writer.appendToBuffer '"'
                >> Writer.appendToBuffer '"'
                >> Writer.flushBufferAsColoredText
                    formater.options.stringColor
            )

        ( FirstChar, Reader.LBrace ) ->
            {- Enter JSON -}
            let
                ( jsonFormater, newWriter ) =
                    Json.parseChar c
                        ( Json.init Json.defaultOptions
                        , writer
                            |> Writer.appendToBuffer '`'
                            >> Writer.flushBufferAsText
                        )
            in
                ( { formater | stringState = JsonString jsonFormater }
                , newWriter
                )

        ( FirstChar, Reader.LBracket ) ->
            {- Enter JSON -}
            let
                ( jsonFormater, newWriter ) =
                    Json.parseChar
                        c
                        ( Json.init Json.defaultOptions
                        , writer
                            |> Writer.appendToBuffer '`'
                            >> Writer.flushBufferAsText
                        )
            in
                ( { formater | stringState = JsonString jsonFormater }
                , newWriter
                )

        ( FirstChar, v ) ->
            ( { formater | stringState = InString }
            , writer
                |> Writer.appendToBuffer '"'
                >> Writer.appendToBuffer (toChar v)
            )

        ( InString, Reader.Escaped '"' ) ->
            ( formater
            , writer
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer '"'
            )

        ( InString, Reader.DoubleQuote ) ->
            ( { formater | stringState = NoString }
            , writer
                |> Writer.appendToBuffer '"'
                >> Writer.flushBufferAsColoredText
                    formater.options.stringColor
            )

        ( JsonString jsonFormater, Reader.Escaped '"' ) ->
            let
                ( newJsonFormater, newWriter ) =
                    Json.parseChar
                        (Reader.Escaped '"')
                        ( jsonFormater, writer )
            in
                ( { formater
                    | stringState = JsonString newJsonFormater
                  }
                , newWriter
                )

        ( JsonString jsonFormater, Reader.DoubleQuote ) ->
            {- Exit Json -}
            let
                ( newJsonFormater, newWriter ) =
                    Json.parseEOF ( jsonFormater, writer )
            in
                ( { formater
                    | stringState = NoString
                  }
                , newWriter
                    |> Writer.appendToBuffer '`'
                    >> Writer.flushBufferAsText
                    >> Writer.flushCurrentLine
                )

        ( JsonString jsonFormater, char ) ->
            let
                ( newJsonFormater, newWriter ) =
                    Json.parseChar char ( jsonFormater, writer )
            in
                ( { formater
                    | stringState = JsonString newJsonFormater
                  }
                , newWriter
                )

        ( _, Reader.Escaped c ) ->
            ( formater
            , writer
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer c
            )

        ( UrlString urlFormater, Reader.DoubleQuote ) ->
            {- Exit Url -}
            ( { formater
                | stringState = NoString
              }
            , writer
                |> Writer.appendToBuffer '"'
                >> Writer.flushBufferAsColoredText
                    formater.options.stringColor
                >> Writer.flushCurrentLine
            )

        ( UrlString urlFormater, char ) ->
            let
                ( newUrlFormater, newWriter ) =
                    Url.parseChar char ( urlFormater, writer )
            in
                ( { formater
                    | stringState = UrlString newUrlFormater
                  }
                , newWriter
                )

        ( _, v ) ->
            ( formater
            , writer |> Writer.appendToBuffer (toChar v)
            )
                {- Enter Url? -} |> checkUrl v


parseEOF : ( Reader, ( Formater, Writer msg ) ) -> ( Reader, ( Formater, Writer msg ) )
parseEOF ( reader, ( formater, writer ) ) =
    ( reader
    , ( formater
      , writer
            |> Writer.flushBufferAsText
            >> Writer.flushCurrentLine
      )
    )
