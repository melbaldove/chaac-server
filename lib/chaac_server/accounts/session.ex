defmodule ChaacServer.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChaacServer.Accounts.Session

  schema "sessions" do
    field :expiry, Ecto.DateTime
    field :token, :string
    belongs_to :user, ChaacServer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:token, :expiry, :user_id])
    |> validate_required([:token, :expiry, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
