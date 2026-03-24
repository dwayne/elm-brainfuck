module Test.Brainfuck.Parser exposing (suite)

import Brainfuck.AST as AST
import Brainfuck.Parser as P
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Brainfuck.Parser" <|
        List.map testParse
            [ ( "><+-.,[]"
              , [ AST.Op AST.GT
                , AST.Op AST.LT
                , AST.Op AST.Plus
                , AST.Op AST.Minus
                , AST.Op AST.Period
                , AST.Op AST.Comma
                , AST.Loop []
                ]
              )
            , ( "[[[]]]"
              , [ AST.Loop [ AST.Loop [ AST.Loop [] ] ] ]
              )
            ]


testParse : ( String, AST.Program ) -> Test
testParse ( input, expected ) =
    test input <|
        \_ ->
            case P.parse input of
                Ok actual ->
                    if expected == actual then
                        Expect.pass

                    else
                        Expect.fail <| "expected = " ++ Debug.toString expected ++ ", actual = " ++ Debug.toString actual

                Err e ->
                    Expect.fail <| Debug.toString e
