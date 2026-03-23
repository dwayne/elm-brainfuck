module Brainfuck.AST exposing (Op(..), Program, Stmt(..))


type alias Program =
    List Stmt


type Stmt
    = Op Op
    | Loop (List Stmt)


type Op
    = GT
    | LT
    | Plus
    | Minus
    | Period
    | Comma
