module Brainfuck.Data.Memory exposing
    ( Memory
    , decrementByte
    , decrementPtr
    , empty
    , get
    , incrementByte
    , incrementPtr
    , set
    )

import Brainfuck.Data.Byte as Byte exposing (Byte)
import Dict exposing (Dict)


type Memory
    = Memory
        { cells : Dict Int Byte
        , ptr : Int
        }


empty : Memory
empty =
    Memory
        { cells = Dict.empty
        , ptr = 0
        }


incrementPtr : Memory -> Memory
incrementPtr (Memory m) =
    Memory { m | ptr = m.ptr + 1 }


decrementPtr : Memory -> Memory
decrementPtr (Memory m) =
    let
        ptr =
            if m.ptr >= 1 then
                m.ptr - 1

            else
                0
    in
    Memory { m | ptr = ptr }


get : Memory -> Byte
get (Memory m) =
    Dict.get m.ptr m.cells
        |> Maybe.withDefault Byte.zero


set : Byte -> Memory -> Memory
set b (Memory m) =
    Memory { m | cells = Dict.insert m.ptr b m.cells }


incrementByte : Memory -> Memory
incrementByte (Memory m) =
    let
        increment maybeB =
            case maybeB of
                Just b ->
                    Just <| Byte.increment b

                Nothing ->
                    Just Byte.one
    in
    Memory { m | cells = Dict.update m.ptr increment m.cells }


decrementByte : Memory -> Memory
decrementByte (Memory m) =
    let
        decrement maybeB =
            case maybeB of
                Just b ->
                    Just <| Byte.decrement b

                Nothing ->
                    Nothing
    in
    Memory { m | cells = Dict.update m.ptr decrement m.cells }
