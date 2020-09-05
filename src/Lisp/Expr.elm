module Lisp.Expr exposing
    ( Expr(..)
    , apply
    , coerceToNumber
    , coerceToString
    , show
    )


type Expr
    = NumberLiteral Float
    | StringLiteral String
    | Identifier String
    | List (List Expr)
    | Function (List Expr -> Expr)
    | Undefined


apply : List Expr -> Expr -> Expr
apply args f =
    case f of
        Function fn ->
            fn args

        _ ->
            List (f :: args)


show : Expr -> String
show expr =
    case expr of
        NumberLiteral n ->
            String.fromFloat n

        StringLiteral s ->
            "'" ++ s ++ "'"

        Identifier id ->
            "{id: " ++ id ++ "}"

        List exprs ->
            List.map show exprs
                |> String.join ", "
                |> String.append "[ "
                |> String.append
                |> (|>) " ]"

        Function _ ->
            "{ Function }"

        Undefined ->
            "{ Undefined }"



-- Coercsions ------------------------------------------------------------------


coerceToNumber : Expr -> Float
coerceToNumber expr =
    case expr of
        NumberLiteral n ->
            n

        StringLiteral s ->
            String.toFloat s
                |> Maybe.withDefault 0

        Identifier _ ->
            0

        List exprs ->
            if List.length exprs > 0 then
                1

            else
                0

        Function _ ->
            1

        Undefined ->
            0


coerceToString : Expr -> String
coerceToString expr =
    case expr of
        NumberLiteral n ->
            String.fromFloat n

        StringLiteral s ->
            s

        Identifier id ->
            id

        List exprs ->
            List.map coerceToString exprs
                |> String.join " "
                |> String.append "("
                |> String.append
                |> (|>) ")"

        Function _ ->
            "{fn}"

        Undefined ->
            "{undefined}"
