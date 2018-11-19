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


type SubFormater
    = StringFmt
    | JsonFmt Json.Formater
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
    formaterRead parseInputChar


eof :
    ( Reader, ( Formater, Writer msg ) )
    -> ( Reader, ( Formater, Writer msg ) )
eof ( reader, ( formater, writer ) ) =
    ( reader, parseInputChar Reader.EOF ( formater, writer ) )



-- generic formater entry points


formaterRead :
    (InputChar -> ( formater, Writer msg ) -> ( formater, Writer msg ))
    -> Char
    -> ( Reader, ( formater, Writer msg ) )
    -> ( Reader, ( formater, Writer msg ) )
formaterRead parseInputChar c ( reader, ( formater, writer ) ) =
    let
        ( newReader, nextChar ) =
            Reader.parseChar c reader

        ( newFormater, newWriter ) =
            case nextChar of
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


parseInputCharNoString :
    InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseInputCharNoString c ( formater, writer ) =
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

        Reader.EOF ->
            ( formater
            , writer
                |> Writer.flushBufferAsText
                >> Writer.flushCurrentLine
            )

        c ->
            ( formater
            , writer |> Writer.appendToBuffer (toChar c)
            )


parseInputCharFirstChar :
    InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseInputCharFirstChar c ( formater, writer ) =
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
                ( jsonFormater, newWriter ) =
                    Json.parseChar Reader.LBrace
                        ( Json.init Json.defaultOptions
                        , writer
                            |> Writer.appendToBuffer '"'
                            >> Writer.flushBufferAsColoredText
                                formater.options.stringColor
                        )
            in
                ( { formater | stringState = InString <| JsonFmt jsonFormater }
                , newWriter
                )

        Reader.LBracket ->
            {- Enter JSON -}
            let
                ( jsonFormater, newWriter ) =
                    Json.parseChar Reader.LBracket
                        ( Json.init Json.defaultOptions
                        , writer
                            |> Writer.appendToBuffer '"'
                            >> Writer.flushBufferAsColoredText
                                formater.options.stringColor
                        )
            in
                ( { formater | stringState = InString <| JsonFmt jsonFormater }
                , newWriter
                )

        Reader.EOF ->
            ( formater
            , writer
                |> Writer.flushBufferAsText
                >> Writer.flushCurrentLine
            )

        c ->
            ( { formater | stringState = InString StringFmt }
            , writer
                |> Writer.appendToBuffer '"'
                >> Writer.appendToBuffer (toChar c)
            )


parseInputCharInString :
    InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseInputCharInString c ( formater, writer ) =
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
                ( jsonFormater, newWriter ) =
                    Json.parseChar Reader.LBrace
                        ( Json.init Json.defaultOptions
                        , writer
                            |> Writer.appendToBuffer '"'
                            >> Writer.flushBufferAsColoredText
                                formater.options.stringColor
                        )
            in
                ( { formater | stringState = InString <| JsonFmt jsonFormater }
                , newWriter
                )

        Reader.EOF ->
            ( formater
            , writer
                |> Writer.flushBufferAsText
                >> Writer.flushCurrentLine
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


parseInputCharJsonString :
    Json.Formater
    -> InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseInputCharJsonString jsonFormater c ( formater, writer ) =
    case c of
        Reader.Escaped '\\' ->
            let
                ( newJsonFormater, newWriter ) =
                    Json.parseChar (Reader.Escaped '\\') ( jsonFormater, writer )
            in
                ( { formater
                    | stringState = InString <| JsonFmt newJsonFormater
                  }
                , newWriter
                )

        Reader.Escaped '"' ->
            let
                ( newJsonFormater, newWriter ) =
                    Json.parseChar
                        (Reader.Escaped '"')
                        ( jsonFormater, writer )
            in
                ( { formater
                    | stringState = InString <| JsonFmt newJsonFormater
                  }
                , newWriter
                )

        Reader.DoubleQuote ->
            let
                endOfJson =
                    List.isEmpty jsonFormater.contextStack

                ( newJsonFormater, newWriter ) =
                    if endOfJson then
                        {- Exit Json -}
                        Json.parseChar Reader.EOF ( jsonFormater, writer )
                    else
                        Json.parseChar c ( jsonFormater, writer )
            in
                if endOfJson then
                    ( { formater | stringState = NoString }
                    , newWriter
                        |> Writer.appendToBuffer '"'
                        >> Writer.flushBufferAsColoredText
                            formater.options.stringColor
                    )
                else
                    ( { formater | stringState = InString <| JsonFmt newJsonFormater }
                    , newWriter
                    )

        Reader.Escaped c ->
            ( formater
            , writer
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer c
            )

        Reader.EOF ->
            ( formater
            , writer
                |> Writer.flushBufferAsText
                >> Writer.flushCurrentLine
            )

        c ->
            let
                endOfJson =
                    List.isEmpty jsonFormater.contextStack

                ( newJsonFormater, newWriter ) =
                    if endOfJson then
                        {- Exit Json -}
                        Json.parseChar Reader.EOF ( jsonFormater, writer )
                    else
                        Json.parseChar c ( jsonFormater, writer )
            in
                if endOfJson then
                    ( { formater | stringState = InString StringFmt }
                    , newWriter
                        |> Writer.appendToBuffer (toChar c)
                    )
                else
                    ( { formater | stringState = InString <| JsonFmt newJsonFormater }
                    , newWriter
                    )


parseInputCharUrlString :
    Url.Formater
    -> InputChar
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
parseInputCharUrlString urlFormater c ( formater, writer ) =
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

        Reader.EOF ->
            ( formater
            , writer
                |> Writer.flushBufferAsText
                >> Writer.flushCurrentLine
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


parseInputChar : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseInputChar c ( formater, writer ) =
    case formater.stringState of
        NoString ->
            parseInputCharNoString c ( formater, writer )

        FirstChar ->
            parseInputCharFirstChar c ( formater, writer )

        InString StringFmt ->
            parseInputCharInString c ( formater, writer )

        InString (JsonFmt jsonFormater) ->
            parseInputCharJsonString jsonFormater c ( formater, writer )

        InString (UrlFmt urlFormater) ->
            parseInputCharUrlString urlFormater c ( formater, writer )
