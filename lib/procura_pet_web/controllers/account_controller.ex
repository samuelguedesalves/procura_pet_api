defmodule ProcuraPetWeb.AccountController do
  use ProcuraPetWeb, :controller
  alias ProcuraPet.{Accounts, Authentication}
  alias ProcuraPetWeb.AccountView
  alias ProcuraPetWeb.FallbackController

  action_fallback FallbackController

  def create_account(conn, account) do
    with {:ok, user} <- Accounts.create_user(account) do
      conn
      |> put_status(:ok)
      |> put_view(AccountView)
      |> render("created.json", user: user)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, %{token: token, user: user}} <- Authentication.auth_user(email, password) do
      conn
      |> put_status(:ok)
      |> put_view(AccountView)
      |> render("login.json", {:ok, %{user: user, token: token}})
    end
  end
end
