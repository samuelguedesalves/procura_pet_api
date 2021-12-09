defmodule ProcuraPet.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :__struct__]}
  schema "users" do
    field :age, :integer
    field :email, :string
    field :name, :string
    field :password, :string
    field :state, :string
    field :city, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :age, :password, :state, :city])
    |> validate_required([:name, :email, :age, :password, :state, :city])
    |> validate_format(:email, ~r/@/)
    |> put_pass_hash()
    |> unique_constraint(:email)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.add_hash(password)[:password_hash])
  end

  defp put_pass_hash(changeset), do: changeset
end
