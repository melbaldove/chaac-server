defmodule ChaacServer.Photos do
  @moduledoc """
  The Photos context.
  """

  import Ecto.Query, warn: false
  alias ChaacServer.Repo
  alias ChaacServer.Utils  
  alias ChaacServer.Accounts
  alias ChaacServer.PhotoStore

  alias ChaacServer.Photos.Photo

  @doc """
  Returns the list of photos.

  ## Examples

      iex> list_photos()
      [%Photo{}, ...]

  """
  def list_photos do
    Repo.all(Photo)
  end

  @doc """
  Gets a single photo.

  Raises `Ecto.NoResultsError` if the Photo does not exist.

  ## Examples

      iex> get_photo!(123)
      %Photo{}

      iex> get_photo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_photo!(id), do: Repo.get!(Photo, id)

  @doc """
  Creates a photo.

  ## Examples

      iex> create_photo(%{field: value})
      {:ok, %Photo{}}

      iex> create_photo(%{field: bad_value})
      {:error, :bad_photo}

  """
  def create_photo(%Plug.Upload{} = uploaded_photo, %Accounts.User{} = user) do
    checksum = Utils.checksum(uploaded_photo.path)
    store_photo(uploaded_photo, user, checksum)
  end
  def create_photo(uploaded_photo, %Accounts.User{} = user) when is_binary(uploaded_photo) do
    checksum = Utils.checksum(uploaded_photo)
    store_photo(uploaded_photo, user, checksum)    
  end
  def create_photo(_, _) do
    {:error, :bad_photo}
  end
  defp store_photo(uploaded_photo, user, checksum) do
    with {:ok, photo_file} <- PhotoStore.store({uploaded_photo, %{user: user, checksum: checksum}}),
         url = PhotoStore.url({photo_file, %{user: user, checksum: checksum}})
    do
      Ecto.build_assoc(user, :photos, checksum: checksum, path: url)
      |> Photo.new_photo_changeset
      |> Repo.insert
    end
  end

  @doc """
  Updates a photo.

  ## Examples

      iex> update_photo(photo, %{field: new_value})
      {:ok, %Photo{}}

      iex> update_photo(photo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_photo(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Photo.

  ## Examples

      iex> delete_photo(photo)
      {:ok, %Photo{}}

      iex> delete_photo(photo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_photo(%Photo{} = photo) do
    user = Accounts.get_user!(photo.user_id)
    PhotoStore.delete({photo.path, %{user: user, checksum: photo.checksum}})
    Repo.delete(photo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking photo changes.

  ## Examples

      iex> change_photo(photo)
      %Ecto.Changeset{source: %Photo{}}

  """
  def change_photo(%Photo{} = photo) do
    Photo.changeset(photo, %{})
  end
end
