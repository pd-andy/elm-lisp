module Lisp.Eval exposing (run)

import Lisp.Environment as Env exposing (Environment)
import Lisp.Expr as Expr exposing (Expr)


run : Expr -> Expr
run expr =
    eval Env.default expr


eval : Environment -> Expr -> Expr
eval env expr =
    case expr of
        Expr.NumberLiteral n ->
            Expr.NumberLiteral n

        Expr.StringLiteral s ->
            Expr.StringLiteral s

        Expr.Identifier id ->
            Env.lookup id env

        Expr.List ((Expr.Identifier id) :: tail) ->
            List.map (eval env) tail
                |> Expr.apply
                |> (|>) (Env.lookup id env)

        Expr.List exprs ->
            List.map (eval env) exprs
                |> Expr.List

        Expr.Function f ->
            Expr.Function f

        Expr.Undefined ->
            Expr.Undefined
