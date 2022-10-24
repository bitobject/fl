defmodule FlWeb.PageController do
  use FlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
