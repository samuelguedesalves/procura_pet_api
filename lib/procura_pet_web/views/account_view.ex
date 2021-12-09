defmodule ProcuraPetWeb.AccountView do
  use ProcuraPetWeb, :view

  def render("created.json", %{user: user}) do
    %{user: user}
  end

  def render("login.json", {:ok, %{user: user, token: token}}) do
    %{user: user, token: token}
  end
end
