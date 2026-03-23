module Brainfuck.Parser exposing (Error, parse)

import Brainfuck.AST as AST
import Brainfuck.Lexer as L
import Parser as P exposing ((|.), (|=), Parser)


type alias Error =
    List P.DeadEnd


parse : String -> Result Error AST.Program
parse =
    P.run program


program : Parser AST.Program
program =
    P.succeed identity
        |. L.spaces
        |= many stmt
        |. P.end


stmt : Parser AST.Stmt
stmt =
    P.oneOf
        [ P.map AST.Op op
        , loop
        ]


op : Parser AST.Op
op =
    P.oneOf
        [ const AST.GT L.gt
        , const AST.LT L.lt
        , const AST.Plus L.plus
        , const AST.Minus L.minus
        , const AST.Period L.period
        , const AST.Comma L.comma
        ]


loop : Parser AST.Stmt
loop =
    P.succeed AST.Loop
        |. L.leftBracket
        |= many (P.lazy (\_ -> stmt))
        |. L.rightBracket



-- HELPERS


const : a -> Parser b -> Parser a
const a =
    P.map (always a)


many : Parser a -> Parser (List a)
many p =
    P.loop [] <|
        \rev ->
            P.oneOf
                [ P.map (\x -> P.Loop (x :: rev)) p
                , P.succeed (P.Done (List.reverse rev))
                ]
