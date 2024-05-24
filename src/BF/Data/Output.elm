module BF.Data.Output exposing (Output, empty, toString, writeByte)

import BF.Data.Byte as Byte exposing (Byte)


type Output
    = Output (List Char)


empty : Output
empty =
    Output []


writeByte : Byte -> Output -> Output
writeByte b (Output o) =
    Output <| Byte.toChar b :: o


toString : Output -> String
toString (Output o) =
    String.fromList <| List.reverse o
