Heavily inspired by [jxxcarlson/elm-lisp](https://github.com/jxxcarlson/elm-lisp),
although there are quite a few examples of Lisps written in Elm.

## How to run

The repo is currently intended to be run from Elm's REPL and as such doesn't
include a `main` or any way to compile into a full Elm app.

The interpreter can evaluate a single Lisp expression using `Lisp.run`. There is
a single function available in the default environment `+` that you can use.

```lisp
> import Lisp
> Lisp.run "((+ 1 2) 3 'hello')"

"[ 3, 3, 4 ]" : String
```
