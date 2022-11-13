defmodule FlWeb.LiveAuth do
  import Phoenix.Component, only: [assign_new: 3]
  import Phoenix.LiveView, only: [redirect: 2, put_flash: 3]

  alias Fl.Accounts
  alias FlWeb.Router.Helpers, as: Routes

  @doc """
  Authenticates the user by looking into the session of LiveView.
  """
  def on_mount(:default, _params, %{"user_token" => user_token}, socket)
      when is_binary(user_token) do
    socket
    |> assign_new(:current_user, fn -> Accounts.get_user_by_session_token(user_token) end)
    |> allow()
  end

  def on_mount(:default, _params, _, socket),
    do:
      {:halt,
       redirect(put_flash(socket, :info, "Logged out successfully."),
         to: Routes.user_session_path(socket, :delete)
       )}

  defp allow(%{assigns: %{current_user: %{confirmed_at: confirmed_at}}} = socket)
       when is_struct(confirmed_at),
       do: {:cont, socket}

  # TODO to redirect to page where to show that he should confirm account
  defp allow(%{assigns: %{current_user: user}} = socket) when is_struct(user),
    do: {:halt, redirect(socket, to: Routes.user_session_path(socket, :new))}

  defp allow(socket),
    do:
      {:halt,
       redirect(put_flash(socket, :info, "Logged out successfully."),
         to: Routes.user_session_path(socket, :delete)
       )}
end
