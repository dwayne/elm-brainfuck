module BF.Data.Machine exposing
    ( Input
    , Machine
    , comma
    , gt
    , init
    , isZero
    , lt
    , minus
    , outputToString
    , period
    , plus
    )

import BF.Data.Byte as Byte exposing (Byte)
import BF.Data.Memory as Memory exposing (Memory)
import BF.Data.Output as Output exposing (Output)


type Machine
    = Machine
        { memory : Memory
        , input : Input
        , output : Output
        }


type alias Input =
    List Byte


init : Int -> Input -> Machine
init rawSize input =
    Machine
        { memory = Memory.init rawSize
        , input = input
        , output = Output.empty
        }


isZero : Machine -> Bool
isZero (Machine { memory }) =
    Byte.isZero <| Memory.get memory


gt : Machine -> Machine
gt (Machine m) =
    Machine { m | memory = Memory.incrementPtr m.memory }


lt : Machine -> Machine
lt (Machine m) =
    Machine { m | memory = Memory.decrementPtr m.memory }


plus : Machine -> Machine
plus (Machine m) =
    Machine { m | memory = Memory.incrementByte m.memory }


minus : Machine -> Machine
minus (Machine m) =
    Machine { m | memory = Memory.decrementByte m.memory }


period : Machine -> Machine
period (Machine m) =
    Machine { m | output = Output.writeByte (Memory.get m.memory) m.output }


comma : Machine -> Maybe Machine
comma (Machine m) =
    case m.input of
        [] ->
            Nothing

        b :: restInput ->
            Just <| Machine { m | memory = Memory.set b m.memory, input = restInput }


outputToString : Machine -> String
outputToString (Machine m) =
    Output.toString m.output
