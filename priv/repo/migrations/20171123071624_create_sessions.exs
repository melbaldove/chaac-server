defmodule ChaacServer.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :token, :string
      add :expiry, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all),
                    null: false
      timestamps()
    end

    create index(:sessions, [:user_id])
  end
end
