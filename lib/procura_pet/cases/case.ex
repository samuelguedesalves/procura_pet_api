defmodule ProcuraPet.Cases.Case do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :__struct__]}
  schema "cases" do
    field :description, :string
    field :title, :string
    field :user_fk, :integer

    timestamps()
  end

  @doc false
  def changeset(case, attrs) do
    case
    |> cast(attrs, [:title, :description, :user_fk])
    |> validate_required([:title, :description, :user_fk])
  end
end
