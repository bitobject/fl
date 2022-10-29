# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fl.Repo.insert!(%Fl.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Enum.map(
  [
    "taxi",
    "food",
    "beauty",
    "house",
    "clothes",
    "medicine",
    "cafe",
    "gift",
    "connection",
    "appliances"
  ],
  fn i ->
    Fl.Categories.create_category(%{name: i, img: "img"})
  end
)

Enum.map(
  [
    "alfa",
    "bkc",
    "rosbank",
    "raiffeisen",
    "sberbank"
  ],
  fn i ->
    Fl.Cards.create_card(%{name: i, img: "img"})
  end
)
