module BF.Data.Memory exposing
    ( Memory
    , decrementByte
    , decrementPtr
    , get
    , incrementByte
    , incrementPtr
    , init
    , set
    )

import Array exposing (Array)
import BF.Data.Byte as Byte exposing (Byte)


type Memory
    = Memory
        { cells : Array Byte
        , size : Int
        , ptr : Int
        }


init : Int -> Memory
init rawSize =
    let
        size =
            clamp 1 100000 rawSize
    in
    Memory
        { cells = Array.repeat size Byte.zero
        , size = size
        , ptr = 0
        }


incrementPtr : Memory -> Memory
incrementPtr (Memory m) =
    Memory { m | ptr = m.ptr + 1 |> modBy m.size }


decrementPtr : Memory -> Memory
decrementPtr (Memory m) =
    Memory { m | ptr = m.ptr - 1 |> modBy m.size }


get : Memory -> Byte
get (Memory { cells, ptr }) =
    Array.get ptr cells
        |> Maybe.withDefault Byte.zero


set : Byte -> Memory -> Memory
set b (Memory m) =
    Memory { m | cells = Array.set m.ptr b m.cells }


incrementByte : Memory -> Memory
incrementByte memory =
    set (Byte.increment <| get memory) memory


decrementByte : Memory -> Memory
decrementByte memory =
    set (Byte.decrement <| get memory) memory
