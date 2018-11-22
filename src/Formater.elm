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
        , formaterRead
        )


-- Types


type ComplexType
    = List
    | Record
    | Tuple


type SubFormater
    = StringFmt
    | JsonFmt Reader Json.Formater
    | UrlFmt Url.Formater


type StringState
    = NoString
    | FirstChar
    | InString SubFormater



-- Main


read :
    Char
    -> ( Reader, ( Formater, Writer msg ) )
    -> ( Reader, ( Formater, Writer msg ) )
read =
    formaterRead parseChar


eof :
    ( Reader, ( Formater, Writer msg ) )
    -> ( Reader, ( Formater, Writer msg ) )
eof ( reader, ( formater, writer ) ) =
    ( reader, parseChar Reader.EOF ( formater, writer ) )



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


closeContext : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
closeContext c ( formater, writer ) =
    ( formater
        |> popContext
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.writeText (String.fromChar <| toChar c)
        >> Writer.flushCurrentLine
        >> Writer.unindent
    )


parseNoString :
    InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseNoString c ( formater, writer ) =
    case c of
        Reader.LBrace ->
            ( formater, writer ) |> openContext Record Reader.LBrace

        Reader.RBrace ->
            ( formater, writer ) |> closeContext Reader.RBrace

        Reader.LBracket ->
            ( formater, writer ) |> openContext List Reader.LBracket

        Reader.RBracket ->
            ( formater, writer ) |> closeContext Reader.RBracket

        Reader.LParenthesis ->
            ( formater
                |> pushContext Tuple
            , writer
                |> Writer.appendToBuffer '('
                >> Writer.appendSingleSpace
            )

        Reader.RParenthesis ->
            ( formater
                |> popContext
            , writer
                |> Writer.appendSingleSpace
                >> Writer.appendToBuffer ')'
            )

        Reader.Comma ->
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

        Reader.DoubleQuote ->
            ( { formater | stringState = FirstChar }
            , writer
                |> Writer.flushBufferAsText
            )

        Reader.Escaped c ->
            ( formater
            , writer
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer c
            )

        c ->
            ( formater
            , writer |> Writer.appendToBuffer (toChar c)
            )


parseFirstChar :
    InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseFirstChar c ( formater, writer ) =
    case c of
        Reader.Escaped c ->
            ( { formater | stringState = InString StringFmt }
            , writer
                |> Writer.appendToBuffer '"'
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer c
            )

        Reader.DoubleQuote ->
            ( { formater | stringState = NoString }
            , writer
                |> Writer.appendToBuffer '"'
                >> Writer.appendToBuffer '"'
                >> Writer.flushBufferAsColoredText
                    formater.options.stringColor
            )

        Reader.LBrace ->
            {- Enter JSON -}
            let
                ( jsonReader, ( jsonFormater, newWriter ) ) =
                    Json.read
                        '{'
                        ( Reader.new
                        , ( Json.init Json.defaultOptions
                          , writer
                                |> Writer.appendToBuffer '"'
                                >> Writer.flushBufferAsColoredText
                                    formater.options.stringColor
                          )
                        )
            in
                ( { formater
                    | stringState = InString <| JsonFmt jsonReader jsonFormater
                  }
                , newWriter
                )

        Reader.LBracket ->
            {- Enter JSON -}
            let
                ( jsonReader, ( jsonFormater, newWriter ) ) =
                    Json.read
                        '['
                        ( Reader.new
                        , ( Json.init Json.defaultOptions
                          , writer
                                |> Writer.appendToBuffer '"'
                                >> Writer.flushBufferAsColoredText
                                    formater.options.stringColor
                          )
                        )
            in
                ( { formater
                    | stringState = InString <| JsonFmt jsonReader jsonFormater
                  }
                , newWriter
                )

        c ->
            ( { formater | stringState = InString StringFmt }
            , writer
                |> Writer.appendToBuffer '"'
                >> Writer.appendToBuffer (toChar c)
            )


parseInString :
    InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseInString c ( formater, writer ) =
    case c of
        Reader.Escaped '"' ->
            ( formater
            , writer
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer '"'
            )

        Reader.Escaped c ->
            ( formater
            , writer
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer c
            )

        Reader.DoubleQuote ->
            ( { formater | stringState = NoString }
            , writer
                |> Writer.appendToBuffer '"'
                >> Writer.flushBufferAsColoredText
                    formater.options.stringColor
            )

        Reader.LBrace ->
            {- Enter JSON -}
            let
                ( jsonReader, ( jsonFormater, newWriter ) ) =
                    Json.read
                        '{'
                        ( Reader.new
                        , ( Json.init Json.defaultOptions
                          , writer
                                |> Writer.appendToBuffer '"'
                                >> Writer.flushBufferAsColoredText
                                    formater.options.stringColor
                          )
                        )
            in
                ( { formater
                    | stringState = InString <| JsonFmt jsonReader jsonFormater
                  }
                , newWriter
                )

        c ->
            if
                not (Buffer.isEmpty writer.buffer)
                    && Buffer.length writer.buffer
                    >= 5
                    && Buffer.take 4 writer.buffer
                    == [ 'h', 't', 't', 'p' ]
            then
                {- Enter Url -}
                ( { formater
                    | stringState = InString <| UrlFmt Url.init
                  }
                , writer |> Writer.appendToBuffer (toChar c)
                )
            else
                ( formater
                , writer |> Writer.appendToBuffer (toChar c)
                )


parseJsonString :
    Reader
    -> Json.Formater
    -> InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseJsonString jsonReader jsonFormater c ( formater, writer ) =
    case c of
        Reader.DoubleQuote ->
            {- Exit Json -}
            let
                ( _, newWriter ) =
                    Json.parseChar Reader.EOF ( jsonFormater, writer )
            in
                ( { formater | stringState = NoString }
                , newWriter
                    |> Writer.appendToBuffer '"'
                    >> Writer.flushBufferAsColoredText
                        formater.options.stringColor
                )

        c ->
            if List.isEmpty jsonFormater.contextStack then
                {- Exit Json -}
                let
                    ( _, newWriter ) =
                        Json.parseChar Reader.EOF ( jsonFormater, writer )
                in
                    ( { formater | stringState = InString StringFmt }
                    , newWriter
                        |> Writer.appendToBuffer (toChar c)
                    )
            else
                let
                    ( newJsonReader, ( newJsonFormater, newWriter ) ) =
                        Json.read
                            (toChar c)
                            ( jsonReader, ( jsonFormater, writer ) )
                in
                    ( { formater
                        | stringState =
                            InString <|
                                JsonFmt newJsonReader newJsonFormater
                      }
                    , newWriter
                    )


parseUrlString :
    Url.Formater
    -> InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseUrlString urlFormater c ( formater, writer ) =
    case c of
        Reader.DoubleQuote ->
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

        Reader.Escaped c ->
            ( formater
            , writer
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer c
            )

        c ->
            let
                ( newUrlFormater, newWriter ) =
                    Url.parseChar c ( urlFormater, writer )
            in
                ( { formater
                    | stringState = InString <| UrlFmt newUrlFormater
                  }
                , newWriter
                )


parseChar : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseChar c ( formater, writer ) =
    case ( formater.stringState, c ) of
        ( _, Reader.EOF ) ->
            ( formater
            , writer
                |> Writer.flushBufferAsText
                >> Writer.flushCurrentLine
            )

        ( NoString, _ ) ->
            parseNoString c ( formater, writer )

        ( FirstChar, _ ) ->
            parseFirstChar c ( formater, writer )

        ( InString StringFmt, _ ) ->
            parseInString c ( formater, writer )

        ( InString (JsonFmt jsonReader jsonFormater), _ ) ->
            parseJsonString jsonReader jsonFormater c ( formater, writer )

        ( InString (UrlFmt urlFormater), _ ) ->
            parseUrlString urlFormater c ( formater, writer )
