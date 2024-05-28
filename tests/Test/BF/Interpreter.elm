module Test.BF.Interpreter exposing (suite)

import BF.Data.Byte as Byte exposing (Byte)
import BF.Data.Machine as Machine
import BF.Interpreter as I
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "BF.Interpreter" <|
        List.map testRun
            [ ( "empty"
              , []
              , ""
              )
            , ( String.repeat 48 "+" ++ "."
              , []
              , "0"
              )
            , ( "++++-+++-++-++[>++++-+++-++-++<-]>."
              , []
              , "@"
              )
            , ( """
                ++++++[>++++++++++++<-]>.
                >++++++++++[>++++++++++<-]>+.
                +++++++..+++.>++++[>+++++++++++<-]>.
                <+++[>----<-]>.<<<<<+++[>+++++<-]>.
                >>.+++.------.--------.>>+.
                """
              , []
              , "Hello, World!"
              )
            , ( """
                Echo until byte(0) or cat

                ,[.[-],]
                """
              , stringToInts "Brainfuck" ++ [ 0 ]
              , "Brainfuck"
              )
            , ( """
                Echo until byte(255)

                ",+[-.,+]"
                """
              , stringToInts "Brainfuck" ++ [ 255 ]
              , "Brainfuck"
              )
            , ( """
                Multiply 2 numbers

                ,>,<[>[->+>+<<]>>[-<<+>>]<<<-]>>.
                """
              , [ 7, 8 ]
              , intToString 56
              )
            , ( """
                Bubble sort

                >>,[>>,]<<[[<<]>>>>[<<[>+<<+>-]>>[>+<<<<[->]>[<]>>-]<<<[[-]>>[>+<-]>>[<<<+>>>-]]>>[[<+>-]>>]<]<<[>>+<<-]<<]>>>>[.>>]
                """
              , stringToInts "dacbe" ++ [ 0 ]
              , "abcde"
              )
            ]


stringToInts : String -> List Int
stringToInts =
    String.toList >> List.map Char.toCode


intToString : Int -> String
intToString =
    Char.fromCode >> String.fromChar


testRun : ( String, List Int, String ) -> Test
testRun ( source, ints, expected ) =
    test source <|
        \_ ->
            let
                input =
                    List.map Byte.fromInt ints

                ( result, machine ) =
                    I.run source 15 input
            in
            case result of
                Ok () ->
                    let
                        actual =
                            Machine.outputToString machine
                    in
                    if expected == actual then
                        Expect.pass

                    else
                        Expect.fail <| "expected = " ++ expected ++ ", actual = " ++ actual

                Err err ->
                    Expect.fail <| Debug.toString err
