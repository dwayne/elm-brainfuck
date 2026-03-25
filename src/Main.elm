module Main exposing (main)

import Brainfuck.Data.Input as Input
import Brainfuck.Data.Machine as Machine
import Brainfuck.Interpreter as I
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
    { source = """[ This program prints "Hello World!" and a newline to the screen; its
  length is 106 active command characters. [It is not the shortest.]

  This loop is an "initial comment loop", a simple way of adding a comment
  to a BF program such that you don't have to worry about any command
  characters. Any ".", ",", "+", "-", "<" and ">" characters are simply
  ignored, the "[" and "]" characters just have to be balanced. This
  loop and the commands it contains are ignored because the current cell
  defaults to a value of 0; the 0 value causes this loop to be skipped.
]
++++++++                Set Cell #0 to 8
[
    >++++               Add 4 to Cell #1; this will always set Cell #1 to 4
    [                   as the cell will be cleared by the loop
        >++             Add 2 to Cell #2
        >+++            Add 3 to Cell #3
        >+++            Add 3 to Cell #4
        >+              Add 1 to Cell #5
        <<<<-           Decrement the loop counter in Cell #1
    ]                   Loop until Cell #1 is zero; number of iterations is 4
    >+                  Add 1 to Cell #2
    >+                  Add 1 to Cell #3
    >-                  Subtract 1 from Cell #4
    >>+                 Add 1 to Cell #6
    [<]                 Move back to the first zero cell you find; this will
                        be Cell #1 which was cleared by the previous loop
    <-                  Decrement the loop Counter in Cell #0
]                       Loop until Cell #0 is zero; number of iterations is 8

The result of this is:
Cell no :   0   1   2   3   4   5   6
Contents:   0   0  72 104  88  32   8
Pointer :   ^

>>.                     Cell #2 has value 72 which is 'H'
>---.                   Subtract 3 from Cell #3 to get 101 which is 'e'
+++++++..+++.           Likewise for 'llo' from Cell #3
>>.                     Cell #5 is 32 for the space
<-.                     Subtract 1 from Cell #4 for 87 to give a 'W'
<.                      Cell #3 was set to 'o' from the end of 'Hello'
+++.------.--------.    Cell #3 for 'rl' and 'd'
>>+.                    Add 1 to Cell #5 gives us an exclamation point
>++.                    And finally a newline from Cell #6"""
    , input = ""
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
                    , HA.spellcheck False
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
