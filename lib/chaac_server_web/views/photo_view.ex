defmodule ChaacServerWeb.PhotoView do
  use ChaacServerWeb, :view
  alias ChaacServerWeb.PhotoView

  def render("index.json", %{photos: photos}) do
    %{data: render_many(photos, PhotoView, "photo.json")}
  end

  def render("show.json", %{photo: photo}) do
    %{data: render_one(photo, PhotoView, "photo.json")}
  end

  def render("photo.json", %{photo: photo}) do
    %{id: photo.id,
      checksum: photo.checksum,
      path: photo.path,
      caption: photo.caption,
      remarks: photo.remarks,
      created_date: photo.created_date}
  end
end
