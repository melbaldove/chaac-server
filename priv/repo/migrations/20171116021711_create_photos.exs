defmodule ChaacServer.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :checksum, :string
      add :path, :string
      add :caption, :string
      add :remarks, :string
      add :created_date, :date
      add :user_id, references(:users, on_delete: :delete_all),
                    null: false

      timestamps()
    end

    create unique_index(:photos, [:checksum])
    create index(:photos, [:user_id])
  end
end
