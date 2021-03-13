-- elm install elm-explorations/linear-algebra
-- elm install elm-explorations/webgl

module Main exposing(..)
import Browser
import Browser.Events as E
import Html exposing (Html)
import Html.Attributes exposing (width, height, style)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL



-- MAIN


import Browser
import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (onInput)


main : Program () Model Msg
main =
    Browser.sandbox
        { view = view
        , update = update
        , init = 0
        }
type alias Model =
    Int

type alias Modelf = Float

type Msg
    = Update String


update : Msg -> Model -> Model
update (Update v) model =
    String.toInt v |> Maybe.withDefault 0

view : Int -> Html Msg
view model =
    div []
        [ 
            h1 [][
                text "Invert Binary Tree"
            ],
            input
            [ type_ "range"
            , Attrs.min "0  "
            , Attrs.max "2000"
            , value <| String.fromInt model
            , onInput Update
            ]
            [],
            triangleRender (toFloat model)
        ]

triangleRender t = WebGL.toHtml
    [ width 400, height 400, style "display" "block"
    ]
    [ WebGL.entity vertexShader fragmentShader mesh { perspective = perspective ((t-1000) / 1000) }
    ]



perspective : Float -> Mat4
perspective t =
  Mat4.mul
    (Mat4.makePerspective 45 1 0.01 100)
    (Mat4.makeLookAt (vec3 (4 * cos t) 0 (4 * sin t)) (vec3 0 0 0) (vec3 0 1 0))


type alias Vertex =
  { position : Vec3
  , color : Vec3
  }


mesh : WebGL.Mesh Vertex
mesh =
  WebGL.triangles
    [ ( Vertex (vec3 0 0 0) (vec3 1 0 0)
      , Vertex (vec3 1 1 0) (vec3 0 1 0)
      , Vertex (vec3 1 -1 0) (vec3 0 0 1)
      )
    ]


type alias Uniforms =
  { perspective : Mat4
  }

vertexShader : WebGL.Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
    [glsl|
        attribute vec3 position;
        attribute vec3 color;
        uniform mat4 perspective;
        varying vec3 vcolor;

        void main () {
            gl_Position = perspective * vec4(position, 1.0);
            vcolor = color;
        }
    |]


fragmentShader : WebGL.Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
    [glsl|
        precision mediump float;
        varying vec3 vcolor;

        void main () {
            gl_FragColor = vec4(vcolor, 1.0);
        }
    |]