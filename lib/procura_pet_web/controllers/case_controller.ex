defmodule ProcuraPetWeb.CaseController do
  use ProcuraPetWeb, :controller
  alias ProcuraPet.Cases
  alias ProcuraPet.Accounts

  plug ProcuraPetWeb.Plug.Authentication

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

  def get_case(conn, params) do
    with %{"id" => case_id} <- params,
         %Cases.Case{} = case <- Cases.get_case!(case_id) do
      conn |> put_status(:ok) |> json(case)
    else
      _ -> conn |> put_status(:bad_request) |> json(%{error: "occurred a unespected error"})
    end
  end

  def list_my_cases(conn, _params) do
    with %{assigns: %{user: %{id: user_fk}}} <- conn,
         list_of_cases <- Cases.list_cases_by_user(user_fk) do
      conn |> put_status(:ok) |> json(list_of_cases)
    end
  end
end
