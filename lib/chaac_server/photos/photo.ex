defmodule ChaacServer.Photos.Photo do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChaacServer.Photos.Photo


  schema "photos" do
    field :caption, :string
    field :checksum, :string
    field :created_date, :date
    field :path, :string
    field :remarks, :string
    belongs_to :user, ChaacServer.Accounts.User

    timestamps()
  end

  @doc false
  def new_photo_changeset(%Photo{} = photo, attrs \\ %{}) do
    # Todo: add foreign key constraint
    photo
    |> cast(attrs, [:checksum, :path, :user_id])
    |> validate_required([:checksum, :path, :user_id])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:checksum)
  end

  @doc false
  def changeset(%Photo{} = photo, attrs) do
    photo
    |> cast(attrs, [:checksum, :path, :caption, :remarks, :created_date])
    |> validate_required([:checksum, :path, :caption, :remarks, :created_date])
    |> unique_constraint(:checksum)
  end
end
