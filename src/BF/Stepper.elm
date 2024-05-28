module BF.Stepper exposing
    ( Continuation
    , Effect(..)
    , State
    , isDone
    , step
    , stepAgain
    )

import BF.AST as AST
import BF.Data.Byte exposing (Byte)
import BF.Data.Machine as Machine exposing (Machine)
import BF.Parser as P


type alias State =
    { machine : Machine
    , cont : Continuation
    , effect : Effect
    }


type Continuation
    = EndCont
    | ReadCont Continuation
    | SeqCont (List AST.Op) Continuation
    | LoopCont (List AST.Op) Continuation


type Effect
    = None
    | Print Byte
    | Read


type Error
    = SyntaxError P.Error


step : String -> Int -> ( Result Error (), State )
step source size =
    let
        machine =
            Machine.init size []

        cont =
            EndCont
    in
    case P.parse source of
        Ok program ->
            ( Ok (), stepOps program machine cont )

        Err err ->
            ( Err <| SyntaxError err, State machine cont None )


stepOps : List AST.Op -> Machine -> Continuation -> State
stepOps ops machine cont =
    case ops of
        [] ->
            State machine cont None

        op :: restOps ->
            let
                state =
                    stepOp op machine cont
            in
            if List.isEmpty restOps then
                state

            else
                { state | cont = SeqCont restOps state.cont }


stepOp : AST.Op -> Machine -> Continuation -> State
stepOp op machine cont =
    case op of
        AST.GT ->
            State (Machine.gt machine) cont None

        AST.LT ->
            State (Machine.lt machine) cont None

        AST.Plus ->
            State (Machine.plus machine) cont None

        AST.Minus ->
            State (Machine.minus machine) cont None

        AST.Period ->
            State machine cont (Print <| Machine.getByte machine)

        AST.Comma ->
            State machine (ReadCont cont) Read

        AST.Loop ops ->
            loop ops machine cont


loop : List AST.Op -> Machine -> Continuation -> State
loop ops machine cont =
    if Machine.isZero machine then
        State machine cont None

    else
        stepOps ops machine (LoopCont ops cont)


stepAgain : Maybe Byte -> Machine -> Continuation -> State
stepAgain maybeInput machine cont =
    case cont of
        EndCont ->
            State machine cont None

        ReadCont nextCont ->
            case maybeInput of
                Just b ->
                    State (Machine.setByte b machine) nextCont None

                Nothing ->
                    State machine nextCont None

        SeqCont ops nextCont ->
            stepOps ops machine nextCont

        LoopCont ops nextCont ->
            loop ops machine nextCont


isDone : Continuation -> Bool
isDone =
    (==) EndCont
