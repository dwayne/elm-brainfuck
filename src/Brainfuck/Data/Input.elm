module Brainfuck.Data.Input exposing
    ( Input
    , append
    , empty
    , fromBytes
    , fromString
    , readByte
    )

import Brainfuck.Data.Byte as Byte exposing (Byte)


type Input
    = Input (List Byte)


empty : Input
empty =
    Input []


fromBytes : List Byte -> Input
fromBytes =
    Input


fromString : String -> Input
fromString =
    Input << List.map Byte.fromChar << String.toList


append : Input -> Input -> Input
append (Input a) (Input b) =
    Input (a ++ b)


readByte : Input -> Maybe ( Input, Byte )
readByte (Input bytes) =
    case bytes of
        [] ->
            Nothing

        b :: restBytes ->
            Just ( Input restBytes, b )
