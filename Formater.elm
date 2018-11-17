module Formater exposing (..)

import Writer exposing (Writer)
import Json


-- Reader


type alias Reader =
    { nextIsEscaped : Bool
    , current : Maybe InputChar
    }


newReader : Reader
newReader =
    { nextIsEscaped = False
    , current = Nothing
    }


setCurrent : Maybe InputChar -> Reader -> Reader
setCurrent v reader =
    { reader | current = v }


setNextIsEscape : Bool -> Reader -> Reader
setNextIsEscape v reader =
    { reader | nextIsEscaped = v }


type InputChar
    = LBrace
    | RBrace
    | LBracket
    | RBracket
    | LParenthesis
    | RParenthesis
    | DoubleQuote
    | Comma
    | Escaped Char
    | Common Char


read : Char -> ( Reader, ( Formater, Writer msg ) ) -> ( Reader, ( Formater, Writer msg ) )
read c ( reader, ( formater, writer ) ) =
    let
        newReader =
            parseChar c reader

        ( newFormater, newWriter ) =
            case newReader.current of
                Just i ->
                    parseInputChar i ( formater, writer )

                Nothing ->
                    ( formater, writer )
    in
        ( newReader, ( newFormater, newWriter ) )


parseChar : Char -> Reader -> Reader
parseChar c reader =
    case c of
        '\\' ->
            newReader

        c ->
            reader
                |> setNextIsEscape False
                |> setCurrent
                    (if reader.nextIsEscaped then
                        Just <| Escaped c
                     else
                        case c of
                            '{' ->
                                Just LBrace

                            '}' ->
                                Just RBrace

                            '[' ->
                                Just LBracket

                            ']' ->
                                Just RBracket

                            '(' ->
                                Just LParenthesis

                            ')' ->
                                Just RParenthesis

                            '"' ->
                                Just DoubleQuote

                            ',' ->
                                Just Comma

                            c ->
                                Just <| Common c
                    )



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



-- Context


type ComplexType
    = List
    | Record
    | Tuple


type StringState
    = NoString
    | FirstChar
    | InString
    | JsonString Json.Formater



-- Parser


openContext :
    ComplexType
    -> Char
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
openContext t c ( formater, writer ) =
    ( formater
        |> pushContext t
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.indent
        >> Writer.appendToBuffer c
        >> Writer.appendSingleSpace
    )


closeContext :
    ComplexType
    -> Char
    -> ( Formater, Writer msg )
    -> ( Formater, Writer msg )
closeContext t c ( formater, writer ) =
    ( formater
        |> popContext
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.writeText (String.fromChar c)
        >> Writer.flushCurrentLine
        >> Writer.unindent
    )


parseInputChar : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseInputChar c ( formater, writer ) =
    ( formater, writer )



-- case ( formater.stringState, c ) of
--     ( JsonString jsonFormater, '\\' ) ->
--         if formater.escapeNext then
--             let
--                 ( newJsonFormater, newWriter ) =
--                     Json.parseChar '\\' ( jsonFormater, writer )
--             in
--                 ( { formater
--                     | escapeNext = not formater.escapeNext
--                     , stringState = JsonString newJsonFormater
--                   }
--                 , newWriter
--                 )
--         else
--             ( { formater
--                 | escapeNext = not formater.escapeNext
--               }
--             , writer
--             )
--     ( _, '\\' ) ->
--         ( { formater
--             | escapeNext = not formater.escapeNext
--           }
--         , writer
--             |> Writer.appendToBuffer '\\'
--         )
--     ( NoString, '{' ) ->
--         ( formater, writer ) |> openContext Record '{'
--     ( NoString, '}' ) ->
--         ( formater, writer ) |> closeContext Record '}'
--     ( NoString, '[' ) ->
--         ( formater, writer ) |> openContext List '['
--     ( NoString, ']' ) ->
--         ( formater, writer ) |> closeContext List ']'
--     ( NoString, '(' ) ->
--         ( formater
--             |> pushContext Tuple
--         , writer
--             |> Writer.appendToBuffer '('
--             >> Writer.appendSingleSpace
--         )
--     ( NoString, ')' ) ->
--         ( formater
--             |> popContext
--         , writer
--             |> Writer.appendSingleSpace
--             >> Writer.appendToBuffer ')'
--         )
--     ( NoString, ',' ) ->
--         case currentContext formater of
--             Just Tuple ->
--                 ( formater
--                 , writer
--                     |> Writer.appendToBuffer ','
--                     >> Writer.appendSingleSpace
--                 )
--             _ ->
--                 ( formater
--                 , writer
--                     |> Writer.flushBufferAsText
--                     >> Writer.flushCurrentLine
--                     >> Writer.appendToBuffer ','
--                     >> Writer.appendSingleSpace
--                 )
--     ( NoString, '"' ) ->
--         ( { formater | stringState = FirstChar }
--         , writer
--             |> Writer.flushBufferAsText
--         )
--     ( FirstChar, '"' ) ->
--         (if formater.escapeNext then
--             ( { formater | escapeNext = False }
--             , writer
--                 |> Writer.appendToBuffer '"'
--             )
--          else
--             ( { formater | stringState = NoString }
--             , writer
--                 |> Writer.appendToBuffer '"'
--                 >> Writer.appendToBuffer '"'
--                 >> Writer.flushBufferAsColoredText
--                     formater.options.stringColor
--             )
--         )
--     ( FirstChar, c ) ->
--         if List.member c [ '{', '[' ] then
--             {- Enter JSON -}
--             let
--                 ( jsonFormater, newWriter ) =
--                     Json.parseChar c
--                         ( Json.init Json.defaultOptions
--                         , writer
--                             |> Writer.appendToBuffer '`'
--                             >> Writer.flushBufferAsText
--                         )
--             in
--                 ( { formater
--                     | stringState = JsonString jsonFormater
--                     , escapeNext = False
--                   }
--                 , newWriter
--                 )
--         else
--             ( { formater
--                 | stringState = InString
--                 , escapeNext = False
--               }
--             , writer
--                 |> Writer.appendToBuffer '"'
--                 >> Writer.appendToBuffer c
--             )
--     ( InString, '"' ) ->
--         if formater.escapeNext then
--             ( { formater | escapeNext = False }
--             , writer
--                 |> Writer.appendToBuffer '"'
--             )
--         else
--             ( { formater | stringState = NoString }
--             , writer
--                 |> Writer.appendToBuffer '"'
--                 >> Writer.flushBufferAsColoredText
--                     formater.options.stringColor
--             )
--     ( JsonString jsonFormater, '"' ) ->
--         if formater.escapeNext then
--             let
--                 ( newJsonFormater, newWriter ) =
--                     Json.parseChar c ( jsonFormater, writer )
--             in
--                 ( { formater
--                     | escapeNext = False
--                     , stringState = JsonString newJsonFormater
--                   }
--                 , newWriter
--                 )
--         else
--             let
--                 ( newJsonFormater, newWriter ) =
--                     Json.parseEOF ( jsonFormater, writer )
--             in
--                 ( { formater
--                     | escapeNext = False
--                     , stringState = NoString
--                   }
--                 , newWriter
--                     |> Writer.appendToBuffer '`'
--                     >> Writer.flushBufferAsText
--                     >> Writer.flushCurrentLine
--                 )
--     ( JsonString jsonFormater, c ) ->
--         let
--             ( newJsonFormater, newWriter ) =
--                 Json.parseChar c ( jsonFormater, writer )
--         in
--             ( { formater
--                 | escapeNext = False
--                 , stringState = JsonString newJsonFormater
--               }
--             , newWriter
--             )
--     ( _, c ) ->
--         ( { formater | escapeNext = False }
--         , writer
--             |> Writer.appendToBuffer c
--         )


parseEOF : ( Reader, ( Formater, Writer msg ) ) -> ( Reader, ( Formater, Writer msg ) )
parseEOF ( reader, ( formater, writer ) ) =
    ( reader
    , ( formater
      , writer
            |> Writer.flushBufferAsText
            >> Writer.flushCurrentLine
      )
    )
