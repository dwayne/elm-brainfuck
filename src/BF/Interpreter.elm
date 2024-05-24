module BF.Interpreter exposing (Error(..), RuntimeError(..), run)

import BF.AST as AST
import BF.Data.Machine as Machine exposing (Input, Machine)
import BF.Parser as P


type Error
    = SyntaxError P.Error
    | RuntimeError RuntimeError


type RuntimeError
    = EndOfInput


run : String -> Int -> Input -> ( Result Error (), Machine )
run source size input =
    let
        machine =
            Machine.init size input
    in
    case P.parse source of
        Ok program ->
            runProgram program machine

        Err err ->
            ( Err <| SyntaxError err, machine )


runProgram : AST.Program -> Machine -> ( Result Error (), Machine )
runProgram program machine =
    interpretOps program machine
        |> Tuple.mapFirst (Result.mapError RuntimeError)


interpretOps : List AST.Op -> Machine -> ( Result RuntimeError (), Machine )
interpretOps ops machine =
    case ops of
        [] ->
            ( Ok (), machine )

        op :: restOps ->
            case interpretOp op machine of
                ( Ok (), nextMachine ) ->
                    interpretOps restOps nextMachine

                ram ->
                    ram


interpretOp : AST.Op -> Machine -> ( Result RuntimeError (), Machine )
interpretOp op machine =
    case op of
        AST.GT ->
            ( Ok (), Machine.gt machine )

        AST.LT ->
            ( Ok (), Machine.lt machine )

        AST.Plus ->
            ( Ok (), Machine.plus machine )

        AST.Minus ->
            ( Ok (), Machine.minus machine )

        AST.Period ->
            ( Ok (), Machine.period machine )

        AST.Comma ->
            case Machine.comma machine of
                Just nextMachine ->
                    ( Ok (), nextMachine )

                Nothing ->
                    ( Err EndOfInput, machine )

        AST.Loop ops ->
            loop ops machine


loop : List AST.Op -> Machine -> ( Result RuntimeError (), Machine )
loop ops machine =
    if Machine.isZero machine then
        ( Ok (), machine )

    else
        case interpretOps ops machine of
            ( Ok (), nextMachine ) ->
                loop ops nextMachine

            ram ->
                ram
