defmodule Fl.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fl.Groups` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        type: "some type"
      })
      |> Fl.Groups.create_group()

    group
  end
end
