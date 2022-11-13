defmodule FlWeb.UserRegistrationController do
  use FlWeb, :controller

  alias Fl.Accounts
  alias Fl.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        user_return_to = get_session(conn, :user_return_to)

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_return_to || signed_in_path(conn))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp signed_in_path(conn), do: Routes.user_session_path(conn, :new)
end
