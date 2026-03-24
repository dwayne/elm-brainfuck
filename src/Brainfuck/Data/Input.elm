module Brainfuck.Data.Input exposing
    ( Input
    , Value(..)
    , empty
    , fromInts
    , fromList
    , fromString
    , readByte
    )

import Brainfuck.Data.Byte as Byte exposing (Byte)


type Input
    = Input (List Byte)


empty : Input
empty =
    Input []


fromInts : List Int -> Input
fromInts =
    Input << List.map Byte.fromInt


fromString : String -> Input
fromString =
    Input << List.map Byte.fromChar << String.toList


type Value
    = String String
    | Char Char
    | Int Int


fromList : List Value -> Input
fromList =
    Input
        << List.concatMap
            (\value ->
                case value of
                    String s ->
                        List.map Byte.fromChar <| String.toList s

                    Char ch ->
                        [ Byte.fromChar ch ]

                    Int n ->
                        [ Byte.fromInt n ]
            )


readByte : Input -> Maybe ( Input, Byte )
readByte (Input bytes) =
    case bytes of
        [] ->
            Nothing

        b :: restBytes ->
            Just ( Input restBytes, b )
