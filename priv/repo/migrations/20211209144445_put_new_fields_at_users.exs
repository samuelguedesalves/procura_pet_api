defmodule ProcuraPet.Repo.Migrations.PutNewFieldsAtUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :state, :string
      add :city, :string
    end
  end

  def down do
    alter table(:users) do
      remove :state
      remove :city
    end
  end
end
