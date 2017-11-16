defmodule ChaacServerWeb.PhotoController do
  use ChaacServerWeb, :controller

  alias ChaacServer.Photos
  alias ChaacServer.Photos.Photo

  action_fallback ChaacServerWeb.FallbackController

  def index(conn, _params) do
    photos = Photos.list_photos()
    render(conn, "index.json", photos: photos)
  end

  def create(conn, %{"photo" => photo_params}) do
    with {:ok, %Photo{} = photo} <- Photos.create_photo(photo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_photo_path(conn, :show, photo))
      |> render("show.json", photo: photo)
    end
  end

  def show(conn, %{"id" => id}) do
    photo = Photos.get_photo!(id)
    render(conn, "show.json", photo: photo)
  end

  def update(conn, %{"id" => id, "photo" => photo_params}) do
    photo = Photos.get_photo!(id)

    with {:ok, %Photo{} = photo} <- Photos.update_photo(photo, photo_params) do
      render(conn, "show.json", photo: photo)
    end
  end

  def delete(conn, %{"id" => id}) do
    photo = Photos.get_photo!(id)
    with {:ok, %Photo{}} <- Photos.delete_photo(photo) do
      send_resp(conn, :no_content, "")
    end
  end
end
