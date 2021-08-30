defmodule ProcuraPetWeb.Plug.Authentication do
  import Plug.Conn
  import Phoenix.Controller

  alias ProcuraPet.{Accounts, Guardian}

  def init(_params) do
  end

  def call(conn, _params) do
    with {"authorization", token} <-
           Enum.find(conn.req_headers, fn item -> match?({"authorization", _}, item) end),
         ["bearer", token] <- String.split(token, " "),
         {:ok, %{"sub" => user_id}} <- Guardian.decode_and_verify(token),
         %Accounts.User{} = user <- Accounts.get_user!(String.to_integer(user_id)) do
      assign(conn, :user, user)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "token are missing or invalid"})
        |> halt()
    end
  end
end
