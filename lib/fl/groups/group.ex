defmodule Fl.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  alias Fl.Accounts.User

  schema "groups" do
    field :type, :string

    has_many(:users, User)
    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end
end
