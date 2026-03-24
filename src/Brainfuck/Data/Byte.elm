module Brainfuck.Data.Byte exposing
    ( Byte
    , decrement
    , fromInt
    , increment
    , isZero
    , toChar
    , zero
    )


type Byte
    = Byte Int


zero : Byte
zero =
    Byte 0


fromInt : Int -> Byte
fromInt =
    Byte << modBy 256


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
