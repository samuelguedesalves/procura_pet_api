defmodule ProcuraPetWeb.FallbackController do
  use ProcuraPetWeb, :controller

  alias ProcuraPetWeb.ErrorView

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("image-error-upload.json", %{error: reason})
  end

  def call(conn, _error) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "unexpected error"})
  end
end
