defmodule ProcuraPetWeb.ImageController do
  use ProcuraPetWeb, :controller

  plug ProcuraPetWeb.Plug.Authentication

  def upload_image(conn, %{"image" => image}) do
    with {:ok, filename} <- save_image(conn.assigns.user.id, image) do
      conn
      |> put_status(:ok)
      |> send_download({:file, "./uploads/#{filename}"})
    else
      _ -> conn |> put_status(:bad_request) |> json(%{error: "error"})
    end
  end

  def show_image(conn, %{"filename" => filename}) do
    conn
    |> put_status(:ok)
    |> send_download({:file, "./uploads/#{filename}"})
  end

  defp save_image(user_id, %{filename: filename, path: path}) do
    extension = Path.extname(filename)
    renamed_file = "#{user_id}_#{UUID.uuid4()}#{extension}"
    File.cp(path, "./uploads/#{renamed_file}")

    {:ok, renamed_file}
  end
end
