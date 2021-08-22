defmodule ProcuraPetWeb.CaseController do
  use ProcuraPetWeb, :controller
  alias ProcuraPet.Cases
  alias ProcuraPet.Accounts

  plug :introspect

  def create(conn, params \\ %{}) do
    with false <- Enum.empty?(params),
         {:ok, case} <- Cases.create_case(params) do
      conn |> put_status(:ok) |> json(case)
    else
      true ->
        conn |> put_status(:bad_request) |> json(%{error: "empty data"})

      {:error, %Ecto.Changeset{}} ->
        conn |> put_status(:bad_request) |> json(%{error: "error at create case"})
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
      _ -> conn |> put_status(:bad_request) |> json(%{error: "token are missing or not is valid"}) |> halt()
    end
  end
end
