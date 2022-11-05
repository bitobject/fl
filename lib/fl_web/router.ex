defmodule FlWeb.Router do
  use FlWeb, :router

  import FlWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FlWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FlWeb do
    pipe_through :browser

    live "/", PageLive.Index, :index
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FlWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", FlWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", FlWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/expenses", ExpenseLive.Index, :index
    live "/expenses/new", ExpenseLive.New, :new
    live "/expenses/:id/edit", ExpenseLive.Index, :edit

    live "/expenses/:id", ExpenseLive.Show, :show
    live "/expenses/:id/show/edit", ExpenseLive.Show, :edit

    live "/cards", CardLive.Index, :index
    live "/cards/new", CardLive.Index, :new
    live "/cards/:id/edit", CardLive.Index, :edit

    live "/cards/:id", CardLive.Show, :show
    live "/cards/:id/show/edit", CardLive.Show, :edit

    live "/categories", CategoryLive.Index, :index
    live "/categories/new", CategoryLive.Index, :new
    live "/categories/:id/edit", CategoryLive.Index, :edit

    live "/categories/:id", CategoryLive.Show, :show
    live "/categories/:id/show/edit", CategoryLive.Show, :edit

    live "/groups", GroupLive.Index, :index
    live "/groups/new", GroupLive.Index, :new
    live "/groups/:id/edit", GroupLive.Index, :edit

    live "/groups/:id", GroupLive.Show, :show
    live "/groups/:id/show/edit", GroupLive.Show, :edit

    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit

    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit

    live "/total_expenses", TotalExpenseLive.Index, :index
    live "/total_expenses/new", TotalExpenseLive.New, :new
    live "/total_expenses/:id/edit", TotalExpenseLive.Index, :edit

    live "/total_expenses/:id", TotalExpenseLive.Show, :show
    live "/total_expenses/:id/show/edit", TotalExpenseLive.Show, :edit
  end

  scope "/", FlWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
