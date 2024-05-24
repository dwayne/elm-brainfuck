module Test.BF.Interpreter exposing (suite)

import BF.Data.Machine as Machine
import BF.Interpreter as I
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "BF.Interpreter" <|
        List.map testRun
            [ ( "++++-+++-++-++[>++++-+++-++-++<-]>."
              , "@"
              )
            , ( """
                ++++++[>++++++++++++<-]>.
                >++++++++++[>++++++++++<-]>+.
                +++++++..+++.>++++[>+++++++++++<-]>.
                <+++[>----<-]>.<<<<<+++[>+++++<-]>.
                >>.+++.------.--------.>>+.
                """
              , "Hello, World!"
              )
            ]


testRun : ( String, String ) -> Test
testRun ( source, expected ) =
    test source <|
        \_ ->
            let
                ( result, machine ) =
                    I.run source 10 []
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
