module BF.AST exposing (Op(..), Program)


type alias Program =
    List Op


type Op
    = GT
    | LT
    | Plus
    | Minus
    | Period
    | Comma
    | Loop (List Op)
