defmodule ProcuraPetWeb.ImageController do
  use ProcuraPetWeb, :controller

  alias ProcuraPetWeb.ImageView

  plug ProcuraPetWeb.Plug.Authentication
  action_fallback ProcuraPetWeb.FallbackController

  @file_extensions ~w[.png .jpg .jpeg]

  def upload_image(conn, %{"image" => image}) do
    with {:ok, filename} <- save_image(image) do
      conn
      |> put_status(:ok)
      |> put_view(ImageView)
      |> render("created-image.json", %{filename: filename})
    end
  end

  def show_image(conn, %{"filename" => filename}) do
    conn
    |> put_status(:ok)
    |> send_download({:file, "./uploads/#{filename}"})
  end

  defp save_image(%{filename: filename, path: path}) do
    with {:ok, extension} <- Path.extname(filename) |> check_extension(),
         renamed_file <- "#{UUID.uuid4()}#{extension}",
         :ok <- File.cp(path, "./uploads/#{renamed_file}") do
      {:ok, renamed_file}
    end
  end

  defp check_extension(extension) do
    if extension in @file_extensions,
      do: {:ok, extension},
      else: {:error, "invalid extension"}
  end
end
