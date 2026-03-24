module Main exposing (main)

import Brainfuck.Data.Input as Input
import Brainfuck.Interpreter as I
import Brainfuck.Data.Machine as Machine
import Browser as B
import Html as H
import Html.Attributes as HA
import Html.Events as HE


main : Program () Model Msg
main =
    B.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { source : String
    , input : String
    , output : String
    }


init : Model
init =
    { source = ">>,[>>,]<<[[<<]>>>>[<<[>+<<+>-]>>[>+<<<<[->]>[<]>>-]<<<[[-]>>[>+<-]>>[<<<+>>>-]]>>[[<+>-]>>]<]<<[>>+<<-]<<]>>>>[.>>]"
    , input = "dacbe"
    , output = ""
    }


type Msg
    = EnteredSource String
    | EnteredInput String
    | ClickedRun


update : Msg -> Model -> Model
update msg model =
    case msg of
        EnteredSource s ->
            { model | source = s }

        EnteredInput s ->
            { model | input = s }

        ClickedRun ->
            let
                ( machine, result ) =
                    --
                    -- N.B. The input string is null terminated.
                    --
                    I.run model.source (Input.fromList [ Input.String model.input, Input.Int 0 ])
            in
            case result of
                Ok () ->
                    { model | output = Machine.toString machine }

                Err err ->
                    let
                        output =
                            case err of
                                I.SyntaxError _ ->
                                    "There was a syntax error."

                                I.RuntimeError I.EndOfInput ->
                                    "The end of the input was reached."
                    in
                    { model | output = output }



view : Model -> H.Html Msg
view { source, input, output } =
    H.div []
        [ H.h1 [] [ H.text "Brainfuck" ]
        , H.main_ [ HA.class "main" ]
            [ H.div [ HA.class "input-area" ]
                [ H.label [ HA.for "source" ] [ H.text "Source:" ]
                , H.textarea
                    [ HA.id "source"
                    , HA.class "source"
                    , HA.placeholder "Enter your program here..."
                    , HA.value source
                    , HE.onInput EnteredSource
                    ]
                    []
                , H.input
                    [ HA.id "input"
                    , HA.type_ "text"
                    , HA.placeholder "Enter your input here..."
                    , HA.value input
                    , HE.onInput EnteredInput
                    ]
                    []
                , H.div []
                    [ H.button
                        [ HA.type_ "button"
                        , HE.onClick ClickedRun
                        ]
                        [ H.text "Run" ]
                    ]
                ]
            , H.div [ HA.class "output-area" ]
                [ H.label [ HA.for "output" ] [ H.text "Output:" ]
                , H.output
                    [ HA.id "output"
                    , HA.for "source input"
                    ]
                    [ if String.isEmpty output then
                        H.text "The output will appear here."
                      else
                        H.text output
                    ]
                ]
            ]
        ]
