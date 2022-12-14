module Quiz3 exposing (main)

import Browser
-- Bring everything from Html Like import namespace
import Html exposing (..)
import Html.Attributes exposing (..)
-- Import Events that will be used
import Html.Events exposing (onClick, onInput, onSubmit)

-- Create a Type Todo with id, name(title), and complete_status Single Todo
type alias Todo =
    { id : Int
    , name : String
    , description : String
    , isComplete: Bool
    }

-- Create a Type Model to wrap all the todos (Holds multiple todo)
type alias Model =
    { field : String
    , description : String
    , uid : Int
    , todos : List Todo
    }

-- Create a Type Msg for the displayed todo - Completed, Name, Delete Todo 
type Msg
    = AddTodo
    | SetField String
    | SetDesField String
    | DeleteTodo Int
    | CompleteTodo Int Bool


-- create and Initialize Model to be empty {"", 0, []}
initialModel : Model
initialModel =
    { field = ""
    , description = ""
    , uid = 0
    , todos = []
    }


-- Create model
view : Model -> Html Msg
view model =
    div [ class "text-center" ] 
    [ div [ class "todo-container text-left p-24 bg-white shadow-sm rounded flex flex-col mx-auto my-48" ]
        [ header [ ]
            [ h1 [ class "title" ] [ text "Todo List" ] ]
        , Html.form [ class "form" ,onSubmit AddTodo ] [ 
            input
                [ class "todo-input"
                , placeholder "Title here.."
                , onInput
                    (\string -> SetField string)
                , value model.field
                ]
                []

            ,input
                [ class "todo-description-input"
                , placeholder "Description here.."
                , onInput
                    (\string -> SetDesField string)
                , value model.description
                ]
                []
            
            , button [ class "btn", type_ "submit", disabled (model.field == "") ] [ text "Create" ]
        ]
        , ul [ class "text-left mt-24" ] (List.map viewTodo model.todos)
    ]
    ]

-- model to display all the todo added
viewTodo : Todo -> Html Msg
viewTodo todo =
    li [ class "todostyle", onClick (CompleteTodo todo.id todo.isComplete) ]
        [ button
            [ class "check material-symbols-outlined ", onClick (CompleteTodo todo.id todo.isComplete) ]
            [ text "check" ]
        , div [ 
            classList[("completed", todo.isComplete)]
            ,class "text-todo" 
            ] 
        [ 
        span  [ class "displaytitle" ] [ text todo.name]
        , span [ class "description" ] [ text " : "]
        , span [ class "description" ] [ text todo.description ]
        ]
        , button
            [ class "remove", onClick (DeleteTodo todo.id)]
            [ text "x" ]
        ]


-- Create our updates model
update : Msg -> Model -> Model
update msg model =
    case msg of
        AddTodo ->
            { model | todos = { id = model.uid, name = model.field, description = model.description, isComplete = False } :: model.todos, field = "", description = "", uid = model.uid + 1 }
        SetField str ->
            { model | field = str }
        SetDesField str ->
            { model | description = str }
        DeleteTodo id ->
            { model | todos = List.filter(\todo -> todo.id /= id) model.todos }
        CompleteTodo id complete ->
        -- Find the specific todo and invert the complete status
            let
                updateTodo todo =
                    if todo.id == id then
                        { todo | isComplete = not complete }
                    else
                        todo
            in
            { model | todos = List.map updateTodo model.todos }



-- Create our view model to display on Browser
main : Program () Model Msg
main =
    Browser.sandbox
        { view = view
        , update = update
        , init = initialModel
        }
