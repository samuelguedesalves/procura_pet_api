defmodule ProcuraPetWeb.AccountController do
  use ProcuraPetWeb, :controller
  alias ProcuraPet.{Accounts, Authentication}

  def login(conn, %{"email" => email, "password" => password}) do
    case Authentication.auth_user(email, password) do
      {:ok, %{token: token, user: user}} ->
        conn
        |> put_status(:ok)
        |> json(%{user: user, token: token})

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def create_account(conn, account) do
    case Accounts.create_user(account) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> json(user)

      {:error, _reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "error at create a new user"})
    end
  end
end
