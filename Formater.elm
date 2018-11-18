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
    }


new : FormaterOptions -> Formater
new options =
    { options = options
    , contextStack = []
    , stringState = NoString
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
openContext t c ( formater, writer ) =
    ( formater
        |> pushContext t
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.indent
        >> Writer.appendToBuffer (toChar c)
        >> Writer.appendSingleSpace
    )


closeContext :
    ComplexType
    -> InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
closeContext t c ( formater, writer ) =
    ( formater
        |> popContext
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.writeText (String.fromChar <| toChar c)
        >> Writer.flushCurrentLine
        >> Writer.unindent
    )


parseInputChar : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseInputChar c ( formater, writer ) =
    case ( formater.stringState, c ) of
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
                    Json.parseChar Reader.LBrace
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
                    Json.parseChar Reader.LBracket
                        ( Json.init Json.defaultOptions
                        , writer
                            |> Writer.appendToBuffer '`'
                            >> Writer.flushBufferAsText
                        )
            in
                ( { formater | stringState = JsonString jsonFormater }
                , newWriter
                )

        ( FirstChar, c ) ->
            ( { formater | stringState = InString }
            , writer
                |> Writer.appendToBuffer '"'
                >> Writer.appendToBuffer (toChar c)
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

        ( InString, c ) ->
            {- Enter Url -}
            if
                (not (Buffer.isEmpty writer.buffer)
                    && Buffer.length writer.buffer
                    >= 5
                    && Buffer.take 4 writer.buffer
                    == [ 'p', 't', 't', 'h' ]
                )
            then
                ( { formater
                    | stringState = UrlString Url.init
                  }
                , writer |> Writer.appendToBuffer (toChar c)
                )
            else
                ( formater
                , writer |> Writer.appendToBuffer (toChar c)
                )

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

        ( JsonString jsonFormater, c ) ->
            let
                ( newJsonFormater, newWriter ) =
                    Json.parseChar c ( jsonFormater, writer )
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

        ( UrlString urlFormater, c ) ->
            let
                ( newUrlFormater, newWriter ) =
                    Url.parseChar c ( urlFormater, writer )
            in
                ( { formater
                    | stringState = UrlString newUrlFormater
                  }
                , newWriter
                )

        ( _, c ) ->
            ( formater
            , writer |> Writer.appendToBuffer (toChar c)
            )


parseEOF : ( Reader, ( Formater, Writer msg ) ) -> ( Reader, ( Formater, Writer msg ) )
parseEOF ( reader, ( formater, writer ) ) =
    ( reader
    , ( formater
      , writer
            |> Writer.flushBufferAsText
            >> Writer.flushCurrentLine
      )
    )
