defmodule ProcuraPetWeb.CaseController do
  use ProcuraPetWeb, :controller
  alias ProcuraPet.{Cases, Cases.Case}

  plug ProcuraPetWeb.Plug.Authentication

  def create(conn, %{"title" => title, "description" => description}) do
    new_case = %{
      "title" => title,
      "description" => description,
      "user_fk" => conn.assigns.user.id
    }

    with {:ok, created_case} <- Cases.create_case(new_case) do
      conn |> put_status(:ok) |> json(created_case)
    else
      _ -> conn |> put_status(:bad_request) |> json(%{error: "error at create case"})
    end
  end

  def get_case(conn, %{"id" => id}) do
    with %Case{} = case_data <- Cases.get_case!(id) do
      conn |> put_status(:ok) |> json(case_data)
    else
      _ -> conn |> put_status(:bad_request) |> json(%{error: "occurred a unespected error"})
    end
  end

  def list_my_cases(conn, _params) do
    with list_of_cases <- Cases.list_cases_by_user(conn.assigns.user.id) do
      conn |> put_status(:ok) |> json(list_of_cases)
    end
  end
end
