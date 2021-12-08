defmodule ProcuraPetWeb.Plug.Authentication do
  import Plug.Conn
  import Phoenix.Controller

  alias ProcuraPet.{Accounts, Guardian, Accounts.User}

  def init(attrs), do: attrs

  def call(conn, _params) do
    with {:ok, token} <- get_token(conn),
         {:ok, %{"sub" => user_id}} <- Guardian.decode_and_verify(token),
         %User{} = user <- Accounts.get_user!(String.to_integer(user_id)) do
      assign(conn, :user, user)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "token are missing or invalid"})
        |> halt()
    end
  end

  defp get_token(conn) do
    [_prefix, token] =
      conn
      |> get_req_header("authorization")
      |> Enum.at(0)
      |> String.split(" ")

    {:ok, token}
  rescue
    _error -> :error
  end
end
