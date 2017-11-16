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
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Photo{} = photo, attrs) do
    photo
    |> cast(attrs, [:checksum, :path, :caption, :remarks, :created_date])
    |> validate_required([:checksum, :path, :caption, :remarks, :created_date])
    |> unique_constraint(:checksum)
  end
end
