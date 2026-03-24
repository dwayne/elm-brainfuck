module Brainfuck.Data.Machine exposing
    ( Machine
    , decrementByte
    , decrementPtr
    , incrementByte
    , incrementPtr
    , isZero
    , readByte
    , start
    , toString
    , writeByte
    )

import Brainfuck.Data.Byte as Byte exposing (Byte)
import Brainfuck.Data.Input as Input exposing (Input)
import Brainfuck.Data.Memory as Memory exposing (Memory)
import Brainfuck.Data.Output as Output exposing (Output)


type Machine
    = Machine
        { memory : Memory
        , input : Input
        , output : Output
        }


start : Input -> Machine
start input =
    Machine
        { memory = Memory.empty
        , input = input
        , output = Output.empty
        }


isZero : Machine -> Bool
isZero (Machine { memory }) =
    Byte.isZero <| Memory.get memory


incrementPtr : Machine -> Machine
incrementPtr (Machine m) =
    Machine { m | memory = Memory.incrementPtr m.memory }


decrementPtr : Machine -> Machine
decrementPtr (Machine m) =
    Machine { m | memory = Memory.decrementPtr m.memory }


incrementByte : Machine -> Machine
incrementByte (Machine m) =
    Machine { m | memory = Memory.incrementByte m.memory }


decrementByte : Machine -> Machine
decrementByte (Machine m) =
    Machine { m | memory = Memory.decrementByte m.memory }


writeByte : Machine -> Machine
writeByte (Machine m) =
    Machine { m | output = Output.writeByte (Memory.get m.memory) m.output }


readByte : Machine -> Maybe Machine
readByte (Machine m) =
    Input.readByte m.input
        |> Maybe.map
            (\( input, b ) ->
                Machine { m | memory = Memory.set b m.memory, input = input }
            )


toString : Machine -> String
toString (Machine m) =
    Output.toString m.output
