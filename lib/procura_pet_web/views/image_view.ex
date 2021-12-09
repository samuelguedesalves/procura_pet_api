defmodule ProcuraPetWeb.ImageView do
  use ProcuraPetWeb, :view

  def render("created-image.json", %{filename: filename}) do
    %{name: filename}
  end
end
