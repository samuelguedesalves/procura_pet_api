defmodule ProcuraPetWeb.CaseController do
  use ProcuraPetWeb, :controller
  alias ProcuraPet.Cases
  alias ProcuraPet.Accounts

  plug :introspect

  def create(conn, params \\ %{}) do
    with %{assigns: %{user: %{id: user_fk}}} <- conn,
         %{"title" => title, "description" => description} <- params,
         {:ok, case} <-
           Cases.create_case(%{
             "title" => title,
             "description" => description,
             "user_fk" => user_fk
           }) do
      conn |> put_status(:ok) |> json(case)
    else
      _ -> conn |> put_status(:bad_request) |> json(%{error: "error at create case"})
    end
  end

  def introspect(conn, _opts) do
    with {"authorization", token} <-
           Enum.find(conn.req_headers, fn item -> match?({"authorization", _}, item) end),
         ["bearer", token] <- String.split(token, " "),
         {:ok, %{"user_id" => user_id}} <- ProcuraPet.Token.verify_and_validate(token),
         %Accounts.User{} = user <- Accounts.get_user!(user_id) do
      assign(conn, :user, user)
    else
      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "token are missing or not is valid"})
        |> halt()
    end
  end
end
