module Reader exposing (Reader, InputChar(..), parseChar, toChar, new)

-- Reader


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


type alias Reader =
    { nextIsEscaped : Bool
    , current : Maybe InputChar
    }


new : Reader
new =
    { nextIsEscaped = False
    , current = Nothing
    }


setCurrent : Maybe InputChar -> Reader -> Reader
setCurrent v reader =
    { reader | current = v }


setNextIsEscape : Bool -> Reader -> Reader
setNextIsEscape v reader =
    { reader | nextIsEscaped = v }


parseChar : Char -> Reader -> Reader
parseChar c reader =
    case c of
        '\\' ->
            reader
                |> setNextIsEscape True
                |> setCurrent Nothing

        c ->
            reader
                |> setNextIsEscape False
                |> setCurrent
                    (if reader.nextIsEscaped then
                        Just <| Escaped c
                     else
                        Just <| fromChar c
                    )


toChar : InputChar -> Char
toChar v =
    case v of
        LBrace ->
            '{'

        RBrace ->
            '}'

        LBracket ->
            '['

        RBracket ->
            ']'

        LParenthesis ->
            '('

        RParenthesis ->
            ')'

        DoubleQuote ->
            '"'

        Comma ->
            ','

        Common c ->
            c

        Escaped c ->
            c


fromChar : Char -> InputChar
fromChar v =
    case v of
        '{' ->
            LBrace

        '}' ->
            RBrace

        '[' ->
            LBracket

        ']' ->
            RBracket

        '(' ->
            LParenthesis

        ')' ->
            RParenthesis

        '"' ->
            DoubleQuote

        ',' ->
            Comma

        c ->
            Common c
