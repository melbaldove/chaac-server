defmodule ChaacServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChaacServer.Accounts.User
  alias ChaacServer.Utils


  schema "users" do
    field :password, :string
    field :username, :string
    has_many :photos, ChaacServer.Photos.Photo
    has_many :sessions, ChaacServer.Accounts.Session 
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end

  def generate_password(%Ecto.Changeset{} = user) do
    user
    |> Ecto.Changeset.change(
        password: Utils.generate_string()
                  |> String.codepoints 
                  |> Enum.take(6)
                  |> Enum.join
    )
  end
end
