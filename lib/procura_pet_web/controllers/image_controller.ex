defmodule ProcuraPetWeb.ImageController do
  use ProcuraPetWeb, :controller

  plug ProcuraPetWeb.Plug.Authentication

  def upload_image(conn, params) do
    with %{assigns: %{user: %{id: user_id}}} <- conn,
         %{"image" => image} <- params,
         {:ok, filename} <- save_image(user_id, image) do
      conn |> put_status(:ok) |> send_download({:file, "/media/#{filename}"})
    else
      _ -> conn |> put_status(:bad_request) |> json(%{error: "error"})
    end
  end

  def save_image(user_id, %{filename: filename, path: path}) do
    extension = Path.extname(filename)
    renamed_file = "#{user_id}_#{UUID.uuid4()}#{extension}"
    File.cp(path, "/media/#{renamed_file}")

    {:ok, renamed_file}
  end
end
