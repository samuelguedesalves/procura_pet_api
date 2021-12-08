defmodule ProcuraPet.Images.Image do
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
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
