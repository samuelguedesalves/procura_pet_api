defmodule ProcuraPet.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :name, :string
      add :user_fk, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:images, [:user_fk])
  end
end
