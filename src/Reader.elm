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
    | Modulo
    | QuestionMark
    | Escaped Char
    | Common Char
    | EOF


type alias Reader =
    Bool


new : Reader
new =
    False


parseChar : Char -> Reader -> ( Reader, Maybe InputChar )
parseChar c reader =
    case ( reader, c ) of
        ( False, '\\' ) ->
            ( True, Nothing )

        ( True, _ ) ->
            ( False, Just <| Escaped c )

        ( False, _ ) ->
            ( False, Just <| fromChar c )


toChar : InputChar -> Char
toChar v =
    case v of
        EOF ->
            '\x00'

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

        Modulo ->
            '%'

        QuestionMark ->
            '?'

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

        '%' ->
            Modulo

        '?' ->
            QuestionMark

        c ->
            Common c
