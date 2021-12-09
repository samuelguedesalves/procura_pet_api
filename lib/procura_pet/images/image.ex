defmodule ProcuraPet.Images.Image do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :name, :string
    field :user_fk, :id

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:name, :user_fk])
    |> validate_required([:name, :user_fk])
  end
end
