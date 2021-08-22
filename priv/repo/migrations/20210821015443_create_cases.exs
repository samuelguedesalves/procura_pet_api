defmodule ProcuraPet.Repo.Migrations.CreateCases do
  use Ecto.Migration

  def change do
    create table(:cases) do
      add :title, :string
      add :description, :string
      add :user_fk, :integer

      timestamps()
    end
  end
end
