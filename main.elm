module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (placeholder, cols)
import Html.App as Html
import Markdown exposing (Options, toHtmlWith, defaultOptions)
import Material
import Material.Toggles as Toggles


main : Program Never
main =
    Html.program
        { init = init, update = update, view = view, subscriptions = \_ -> Sub.none }


type alias Model =
    { text : String, fullGithubMode : Bool, mdl : Material.Model }


type alias Mdl =
    Material.Model


init : ( Model, Cmd Msg )
init =
    ( { text = "", fullGithubMode = True, mdl = Material.model }, Cmd.none )


type Msg
    = Entry String
    | ToggleGithubMode
    | Mdl (Material.Msg Msg)


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
    div []
        [ Toggles.switch Mdl
            [ 0 ]
            model.mdl
            [ Toggles.onClick ToggleGithubMode
            , Toggles.ripple
            , Toggles.value model.fullGithubMode
            ]
            [ text "Format tables and line breaks as on Github" ]
        , br [] []
        , textarea [ cols 100, onInput Entry, placeholder "Type _some_ **Markdown** here..." ] []
        , toHtmlWith (whichOptions model.fullGithubMode) [] model.text
        ]


whichOptions : Bool -> Options
whichOptions fullGithubMode =
    (if fullGithubMode then
        fullGithub
     else
        basicGithub
    )


basicGithub : Options
basicGithub =
    defaultOptions


fullGithub : Options
fullGithub =
    { defaultOptions | githubFlavored = Just { tables = True, breaks = True } }
