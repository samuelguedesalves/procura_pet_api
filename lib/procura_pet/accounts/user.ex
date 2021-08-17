defmodule ProcuraPet.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Bcrypt.Base

  @derive {Jason.Encoder, only: [:id, :name, :email, :age, :inserted_at, :updated_at]}
  schema "users" do
    field :age, :integer
    field :email, :string
    field :name, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :age, :password])
    |> validate_required([:name, :email, :age, :password])
    |> validate_format(:email, ~r/@/)
    |> IO.inspect()
    |> put_pass_hash()
    |> unique_constraint(:email)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.add_hash(password)[:password_hash])
  end

  defp put_pass_hash(changeset), do: changeset
end
