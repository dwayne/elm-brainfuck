module Main exposing (main)

import Browser as B
import Html as H


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
    H.text "Hello, world!"
