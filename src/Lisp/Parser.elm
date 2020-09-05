module Lisp.Parser exposing (run)

import Lisp.Expr as Expr exposing (Expr)
import Parser exposing ((|.), (|=), Parser)



-- Running the Parser ----------------------------------------------------------


run : String -> Expr
run input =
    Parser.succeed identity
        |= exprParser
        |. Parser.end
        |> Parser.run
        |> (|>) input
        |> Result.withDefault Expr.Undefined



-- Parser components -----------------------------------------------------------


exprParser : Parser Expr
exprParser =
    Parser.succeed identity
        |= Parser.oneOf
            [ Parser.lazy (\_ -> listParser)
            , stringLiteralParser
            , numberLiteralParser
            , identifierParser
            ]
        |. Parser.spaces


listParser : Parser Expr
listParser =
    let
        manyExprs exprs =
            Parser.oneOf
                [ Parser.succeed (\expr -> Parser.Loop (expr :: exprs))
                    |= exprParser
                    |. Parser.spaces
                , Parser.succeed (Parser.Done (List.reverse exprs))
                    |> Parser.map identity
                ]
    in
    Parser.succeed Expr.List
        |. Parser.symbol "("
        |. Parser.spaces
        |= Parser.loop [] manyExprs
        |. Parser.spaces
        |. Parser.symbol ")"
        |. Parser.spaces


stringLiteralParser : Parser Expr
stringLiteralParser =
    Parser.succeed Expr.StringLiteral
        |. Parser.symbol "'"
        |= (Parser.getChompedString <| Parser.chompUntilEndOr "'")
        |. Parser.symbol "'"


numberLiteralParser : Parser Expr
numberLiteralParser =
    Parser.succeed Expr.NumberLiteral
        |= Parser.float


identifierParser : Parser Expr
identifierParser =
    let
        invalidChars =
            [ ' '
            , '\n'
            , '\t'
            , '('
            , ')'
            , '\''
            ]
    in
    Parser.succeed (\head tail -> Expr.Identifier (head ++ tail))
        |= (Parser.getChompedString <| Parser.chompIf (not << (|>) invalidChars << List.member))
        |= (Parser.getChompedString <| Parser.chompWhile (not << (|>) invalidChars << List.member))
