module Test.BF.Parser exposing (suite)

import BF.AST as AST
import BF.Parser as P
import Expect
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "BF.Parser" <|
        List.map testParse
            [ ( "><+-.,[]"
              , [ AST.GT
                , AST.LT
                , AST.Plus
                , AST.Minus
                , AST.Period
                , AST.Comma
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
