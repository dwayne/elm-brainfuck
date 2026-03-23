module Brainfuck.Lexer exposing
    ( comma
    , gt
    , leftBracket
    , lt
    , minus
    , period
    , plus
    , rightBracket
    , spaces
    )

import Parser as P exposing ((|.), (|=), Parser)
import Set exposing (Set)


gt : Parser ()
gt =
    symbol ">"


lt : Parser ()
lt =
    symbol "<"


plus : Parser ()
plus =
    symbol "+"


minus : Parser ()
minus =
    symbol "-"


period : Parser ()
period =
    symbol "."


comma : Parser ()
comma =
    symbol ","


leftBracket : Parser ()
leftBracket =
    symbol "["


rightBracket : Parser ()
rightBracket =
    symbol "]"


symbol : String -> Parser ()
symbol =
    lexeme << P.symbol


lexeme : Parser a -> Parser a
lexeme p =
    P.succeed identity
        |= p
        |. spaces


spaces : Parser ()
spaces =
    P.chompWhile isSpace


isSpace : Char -> Bool
isSpace ch =
    not <| Set.member ch nonSpaceChars


nonSpaceChars : Set Char
nonSpaceChars =
    "><+-.,[]"
        |> String.toList
        |> Set.fromList
