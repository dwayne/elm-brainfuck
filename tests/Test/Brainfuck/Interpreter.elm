module Test.Brainfuck.Interpreter exposing (suite)

import Brainfuck.Data.Byte as Byte exposing (Byte)
import Brainfuck.Data.Input as Input exposing (Input)
import Brainfuck.Data.Machine as Machine
import Brainfuck.Interpreter as I
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Brainfuck.Interpreter" <|
        List.map testRun
            [ ( "empty"
              , Input.empty
              , ""
              )
            , ( String.repeat 48 "+" ++ "."
              , Input.empty
              , "0"
              )
            , ( "++++-+++-++-++[>++++-+++-++-++<-]>."
              , Input.empty
              , "@"
              )
            , ( """
                ++++++[>++++++++++++<-]>.
                >++++++++++[>++++++++++<-]>+.
                +++++++..+++.>++++[>+++++++++++<-]>.
                <+++[>----<-]>.<<<<<+++[>+++++<-]>.
                >>.+++.------.--------.>>+.
                """
              , Input.empty
              , "Hello, World!"
              )
            , ( """
                Echo until byte(0) or cat

                ,[.[-],]
                """
              , Input.fromList [ Input.String "Brainfuck", Input.Int 0 ]
              , "Brainfuck"
              )
            , ( """
                Echo until byte(255)

                ",+[-.,+]"
                """
              , Input.fromList [ Input.String "Brainfuck", Input.Int 255 ]
              , "Brainfuck"
              )
            , ( """
                Multiply 2 numbers

                ,>,<[>[->+>+<<]>>[-<<+>>]<<<-]>>.
                """
              , Input.fromInts [ 7, 8 ]
              , byteToString 56
              )
            , ( """
                Bubble sort

                >>,[>>,]<<[[<<]>>>>[<<[>+<<+>-]>>[>+<<<<[->]>[<]>>-]<<<[[-]>>[>+<-]>>[<<<+>>>-]]>>[[<+>-]>>]<]<<[>>+<<-]<<]>>>>[.>>]
                """
              , Input.fromList [ Input.String "dacbe", Input.Int 0 ]
              , "abcde"
              )
            ]


byteToString : Int -> String
byteToString =
    Byte.fromInt >> Byte.toChar >> String.fromChar


testRun : ( String, Input, String ) -> Test
testRun ( source, input, expected ) =
    test (Debug.toString { source = source, input = input }) <|
        \_ ->
            let
                ( machine, result ) =
                    I.run source input
            in
            case result of
                Ok () ->
                    let
                        actual =
                            Machine.toString machine
                    in
                    if expected == actual then
                        Expect.pass

                    else
                        Expect.fail <| "expected = " ++ expected ++ ", actual = " ++ actual

                Err err ->
                    Expect.fail <| Debug.toString err
