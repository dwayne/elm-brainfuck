module Brainfuck.Data.Byte exposing
    ( Byte
    , decrement
    , fromChar
    , fromInt
    , increment
    , isZero
    , one
    , toChar
    , zero
    )


type Byte
    = Byte Int


zero : Byte
zero =
    Byte 0


one : Byte
one =
    Byte 1


fromInt : Int -> Byte
fromInt =
    Byte << modBy 256


fromChar : Char -> Byte
fromChar =
    fromInt << Char.toCode


isZero : Byte -> Bool
isZero (Byte b) =
    b == 0


increment : Byte -> Byte
increment (Byte b) =
    fromInt <| b + 1


decrement : Byte -> Byte
decrement (Byte b) =
    fromInt <| b - 1


toChar : Byte -> Char
toChar (Byte b) =
    Char.fromCode b
