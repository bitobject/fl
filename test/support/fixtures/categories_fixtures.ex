defmodule Fl.CategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fl.Categories` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        img: "some img",
        name: "some name"
      })
      |> Fl.Categories.create_category()

    category
  end
end
