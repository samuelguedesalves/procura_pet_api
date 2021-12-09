defmodule ProcuraPetWeb.Plug.Authentication do
  import Plug.Conn
  import Phoenix.Controller

  alias ProcuraPet.{Accounts, Guardian, Accounts.User}
  alias ProcuraPetWeb.ErrorView

  def init(attrs), do: attrs

  def call(conn, _params) do
    with {:ok, token} <- get_token(conn),
         {:ok, %{"sub" => user_id}} <- Guardian.decode_and_verify(token),
         %User{} = user <- Accounts.get_user!(String.to_integer(user_id)) do
      assign(conn, :user, user)
    else
      {:error, %ArgumentError{}} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ErrorView)
        |> render("auth.json", %{error: "invalid token"})
        |> halt()

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ErrorView)
        |> render("auth.json", %{error: reason})
        |> halt()
    end
  end

  defp get_token(conn) do
    ["Bearer", token] =
      conn
      |> get_req_header("authorization")
      |> Enum.at(0)
      |> String.split(" ")

    {:ok, token}
  rescue
    _error -> {:error, "unformated token"}
  end
end
