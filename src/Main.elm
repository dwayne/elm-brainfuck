module Main exposing (main)

import Browser as B
import Html as H
import Html.Attributes as HA


main : Program () Model Msg
main =
    B.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    {}


init : Model
init =
    {}


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


view : Model -> H.Html msg
view _ =
    H.div []
        [ H.h1 [] [ H.text "Brainfuck" ]
        , H.main_ [ HA.class "main" ]
            [ H.div [ HA.class "input-area" ]
                [ H.label [ HA.for "source" ] [ H.text "Source:" ]
                , H.textarea
                    [ HA.id "source"
                    , HA.class "source"
                    , HA.placeholder "Enter your program here..."
                    ]
                    []
                , H.input
                    [ HA.id "input"
                    , HA.type_ "text"
                    , HA.placeholder "Enter your input here..."
                    ]
                    []
                , H.div []
                    [ H.button
                        [ HA.type_ "button"
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
                    [ H.text "The output will appear here." ]
                ]
            ]
        ]
