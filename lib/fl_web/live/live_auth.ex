defmodule FlWeb.LiveAuth do
  use FlWeb, :live_component

  alias Fl.Accounts

  @doc """
  Authenticates the user by looking into the session of LiveView.
  """
  def on_mount(:default, _params, %{"user_token" => user_token}, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        user = user_token && Accounts.get_user_by_session_token(user_token)
      end)

    if socket.assigns.current_user.confirmed_at do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: Routes.user_session_path(socket, :new))}
    end
  end

  def on_mount(:default, _params, _, socket),
    do: {:halt, redirect(socket, to: Routes.user_session_path(socket, :new))}
end
