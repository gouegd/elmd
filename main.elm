module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (placeholder, cols, style)
import Html.App as Html
import Markdown exposing (Options, toHtmlWith, defaultOptions)
import Material
import Material.Toggles as Toggles
import Material.Options exposing (css)


main : Program Never
main =
    Html.program
        { init = init, update = update, view = view, subscriptions = \_ -> Sub.none }


type alias Mdl =
    Material.Model


type alias Model =
    { text : String, fullGithubMode : Bool, mdl : Mdl }


type Msg
    = Entry String
    | ToggleGithubMode
    | Mdl (Material.Msg Msg)


startupText : String
startupText =
    """Change the contents of the `textarea` above !

| name | version
|:-----|------:
| elmd | 1.0.0
"""


init : ( Model, Cmd Msg )
init =
    ( { text = startupText, fullGithubMode = True, mdl = Material.model }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Entry text ->
            ( { model | text = text }, Cmd.none )

        ToggleGithubMode ->
            ( { model | fullGithubMode = not model.fullGithubMode }, Cmd.none )

        Mdl msg ->
            Material.update msg model


view : Model -> Html Msg
view model =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "height", "100vh" )
            ]
        ]
        [ Toggles.switch Mdl
            [ 0 ]
            model.mdl
            [ Toggles.onClick ToggleGithubMode
            , Toggles.ripple
            , Toggles.value model.fullGithubMode
            , css "flex" "none"
            , css "vertical" "none"
            , css "color" "#CCCCCC"
            , css "background" "#333333"
            ]
            [ text "Format tables and line breaks as on Github" ]
        , div
            [ style [ ( "display", "flex" ), ( "flex", "auto" ), ( "overflow", "hidden" ) ] ]
            [ textarea
                [ style
                    [ ( "flex", "1" )
                    , ( "font-family", "Monospace" )
                    , ( "background", "#CCCCFF" )
                    , ( "overflow", "scroll" )
                    ]
                , onInput Entry
                , placeholder "Type _some_ **Markdown** here..."
                ]
                [ text model.text ]
            , toHtmlWith
                (whichOptions model.fullGithubMode)
                [ style [ ( "flex", "1" ), ( "overflow", "scroll" ) ] ]
                model.text
            ]
        ]


whichOptions : Bool -> Options
whichOptions fullGithubMode =
    case fullGithubMode of
        True ->
            fullGithub

        False ->
            basicGithub


basicGithub : Options
basicGithub =
    defaultOptions


fullGithub : Options
fullGithub =
    { defaultOptions | githubFlavored = Just { tables = True, breaks = True } }
