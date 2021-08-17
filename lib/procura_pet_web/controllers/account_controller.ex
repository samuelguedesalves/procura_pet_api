defmodule ProcuraPetWeb.AccountController do
  use ProcuraPetWeb, :controller
  alias ProcuraPet.{Accounts, Authentication}

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, %{token: token, user: user}} <-
           Authentication.auth_user(%{email: email, password: password}) do
      conn
      |> put_status(:ok)
      |> json(%{user: user, token: token})
    else
      {:error, reason} -> conn |> put_status(:bad_request) |> json(%{error: reason})
    end
  end

  def create_account(conn, account) do
    account
    |> Accounts.create_user()
    |> case do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> json(user)

      {:error, _reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{"error" => "error at create a new user"})
    end
  end
end
