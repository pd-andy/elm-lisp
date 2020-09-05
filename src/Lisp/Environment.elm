module Lisp.Environment exposing
    ( Environment
    , default
    , empty
    , lookup
    )

import Dict exposing (Dict)
import Lisp.Expr as Expr exposing (Expr)


type Environment
    = Environment (Dict String Expr)


empty : Environment
empty =
    Environment Dict.empty


default : Environment
default =
    Environment <|
        Dict.fromList
            [ ( "+", Expr.Function (List.foldl ((+) << Expr.coerceToNumber) 0 >> Expr.NumberLiteral) )
            ]


lookup : String -> Environment -> Expr
lookup id (Environment env) =
    Dict.get id env
        |> Maybe.withDefault Expr.Undefined
