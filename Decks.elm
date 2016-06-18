module Decks exposing (Deck, newDeck, Msg, update, view, shuffle)

import Html
import Html.App
import Html.Events
import Random
import Random.Array
import Array
import Cards

type alias Deck = {
    cards : List Cards.Card
}

newDeck : Deck
newDeck = { cards = Cards.allCards }

type Msg
    = BeginShuffle
    | EndShuffle (Array.Array Cards.Card, Int)
    | CardMsg Cards.Msg

update : Msg -> Deck -> (Deck, Cmd Msg)
update msg deck =
    case msg of
        BeginShuffle ->
            (deck, shuffle deck.cards)
        EndShuffle (cards, ind) ->
            ({deck | cards = swapSpadeKingToEndish (Array.toList cards) ind}, Cmd.none)
        CardMsg msg ->
            (deck, Cmd.none)

shuffle : List Cards.Card -> Cmd Msg
shuffle cards =
    Random.generate EndShuffle (Random.pair (Random.Array.shuffle (Array.fromList cards)) (Random.int 0 10))

swapSpadeKingToEndish : List Cards.Card -> Int -> List Cards.Card
swapSpadeKingToEndish cards endpad =
    let
        (a, b) = List.partition (\c -> c.face == Cards.King && c.suite == Cards.Spades) cards
    in
        List.append b a

viewCardListItem : Cards.Card -> Html.Html Msg
viewCardListItem card =
    Html.li [] [Html.App.map CardMsg (Cards.view card)]

view : Deck -> Html.Html Msg
view deck =
    Html.div [] [
        Html.button [ Html.Events.onClick BeginShuffle ] [ Html.text "Shuffle" ],
        Html.ol [] (List.map viewCardListItem deck.cards)
    ]


