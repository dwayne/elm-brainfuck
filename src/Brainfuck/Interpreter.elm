module Brainfuck.Interpreter exposing (Error(..), RuntimeError(..), run)

import Brainfuck.AST as AST
import Brainfuck.Data.Input as Input exposing (Input)
import Brainfuck.Data.Machine as Machine exposing (Machine)
import Brainfuck.Parser as P


type Error
    = SyntaxError P.Error
    | RuntimeError RuntimeError


type RuntimeError
    = EndOfInput


run : String -> Input -> ( Machine, Result Error () )
run source input =
    let
        machine =
            Machine.start input
    in
    case P.parse source of
        Ok program ->
            runProgram program machine

        Err err ->
            ( machine, Err <| SyntaxError err )


runProgram : AST.Program -> Machine -> ( Machine, Result Error () )
runProgram program machine =
    interpretStmts program machine
        |> Tuple.mapSecond (Result.mapError RuntimeError)


interpretStmts : List AST.Stmt -> Machine -> ( Machine, Result RuntimeError () )
interpretStmts stmts machine =
    case stmts of
        [] ->
            ( machine, Ok () )

        stmt :: restStmts ->
            case interpretStmt stmt machine of
                ( nextMachine, Ok () ) ->
                    interpretStmts restStmts nextMachine

                err ->
                    err


interpretStmt : AST.Stmt -> Machine -> ( Machine, Result RuntimeError () )
interpretStmt stmt machine =
    case stmt of
        AST.Op op ->
            interpretOp op machine

        AST.Loop stmts ->
            interpretLoop stmts machine


interpretOp : AST.Op -> Machine -> ( Machine, Result RuntimeError () )
interpretOp op machine =
    case op of
        AST.GT ->
            ( Machine.incrementPtr machine, Ok () )

        AST.LT ->
            ( Machine.decrementPtr machine, Ok () )

        AST.Plus ->
            ( Machine.incrementByte machine, Ok () )

        AST.Minus ->
            ( Machine.decrementByte machine, Ok () )

        AST.Period ->
            ( Machine.writeByte machine, Ok () )

        AST.Comma ->
            case Machine.readByte machine of
                Just nextMachine ->
                    ( nextMachine, Ok () )

                Nothing ->
                    ( machine, Err EndOfInput )


interpretLoop : List AST.Stmt -> Machine -> ( Machine, Result RuntimeError () )
interpretLoop stmts machine =
    if Machine.isZero machine then
        ( machine, Ok () )

    else
        case interpretStmts stmts machine of
            ( nextMachine, Ok () ) ->
                interpretLoop stmts nextMachine

            err ->
                err
