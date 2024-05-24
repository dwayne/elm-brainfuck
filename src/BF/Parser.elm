module BF.Parser exposing (Error, parse)

import BF.AST as AST
import BF.Lexer as L
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
        |= many op
        |. P.end


op : Parser AST.Op
op =
    P.oneOf
        [ const AST.GT L.gt
        , const AST.LT L.lt
        , const AST.Plus L.plus
        , const AST.Minus L.minus
        , const AST.Period L.period
        , const AST.Comma L.comma
        , loop
        ]


loop : Parser AST.Op
loop =
    P.succeed AST.Loop
        |. L.leftBracket
        |= many (P.lazy (\_ -> op))
        |. L.rightBracket



-- HELPERS


const : a -> Parser () -> Parser a
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
