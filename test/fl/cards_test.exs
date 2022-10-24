defmodule Fl.CardsTest do
  use Fl.DataCase

  alias Fl.Cards

  describe "cards" do
    alias Fl.Cards.Card

    import Fl.CardsFixtures

    @invalid_attrs %{img: nil, name: nil}

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Cards.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Cards.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      valid_attrs = %{img: "some img", name: "some name"}

      assert {:ok, %Card{} = card} = Cards.create_card(valid_attrs)
      assert card.img == "some img"
      assert card.name == "some name"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      update_attrs = %{img: "some updated img", name: "some updated name"}

      assert {:ok, %Card{} = card} = Cards.update_card(card, update_attrs)
      assert card.img == "some updated img"
      assert card.name == "some updated name"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Cards.update_card(card, @invalid_attrs)
      assert card == Cards.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Cards.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Cards.change_card(card)
    end
  end
end
