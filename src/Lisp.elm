module Lisp exposing (run)

import Lisp.Eval as Eval
import Lisp.Expr as Expr
import Lisp.Parser as Parser


run : String -> String
run input =
    Parser.run input
        |> Eval.run
        |> Expr.show
