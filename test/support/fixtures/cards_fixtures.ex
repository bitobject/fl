defmodule Fl.CardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fl.Cards` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        img: "some img",
        name: "some name"
      })
      |> Fl.Cards.create_card()

    card
  end
end
