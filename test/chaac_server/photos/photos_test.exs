defmodule ChaacServer.PhotosTest do
  use ChaacServer.DataCase

  alias ChaacServer.Photos

  describe "photos" do
    alias ChaacServer.Photos.Photo

    @valid_attrs %{checksum: "some checksum", created_date: ~D[2010-04-17], path: "some path"}
    @valid_photo "test/chaac_server/photos/TestPhoto.jpg"
    @update_attrs %{caption: "some updated caption", checksum: "some updated checksum", created_date: ~D[2011-05-18], path: "some updated path", remarks: "some updated remarks"}
    @invalid_attrs %{caption: nil, checksum: nil, created_date: nil, path: nil, remarks: nil}

    def photo_fixture(attrs \\ %{}) do
      {:ok, photo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Photos.create_photo()

      photo
    end

    test "list_photos/0 returns all photos" do
      photo = photo_fixture()
      assert Photos.list_photos() == [photo]
    end

    test "get_photo!/1 returns the photo with given id" do
      photo = photo_fixture()
      assert Photos.get_photo!(photo.id) == photo
    end

    test "create_photo/1 with valid photo creates photo resource" do
      valid_photo = Path.expand(@valid_photo)
      assert {:ok, %Photo{} = photo} = Photos.create_photo(valid_photo)
      assert photo.checksum == "fd0718a2854df251cfa264162a04fc31"
      assert photo.path == "some path"
    end

    test "create_photo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Photos.create_photo(@invalid_attrs)
    end

    test "update_photo/2 with valid data updates the photo" do
      photo = photo_fixture()
      assert {:ok, photo} = Photos.update_photo(photo, @update_attrs)
      assert %Photo{} = photo
      assert photo.caption == "some updated caption"
      assert photo.checksum == "some updated checksum"
      assert photo.created_date == ~D[2011-05-18]
      assert photo.path == "some updated path"
      assert photo.remarks == "some updated remarks"
    end

    test "update_photo/2 with invalid data returns error changeset" do
      photo = photo_fixture()
      assert {:error, %Ecto.Changeset{}} = Photos.update_photo(photo, @invalid_attrs)
      assert photo == Photos.get_photo!(photo.id)
    end

    test "delete_photo/1 deletes the photo" do
      photo = photo_fixture()
      assert {:ok, %Photo{}} = Photos.delete_photo(photo)
      assert_raise Ecto.NoResultsError, fn -> Photos.get_photo!(photo.id) end
    end

    test "change_photo/1 returns a photo changeset" do
      photo = photo_fixture()
      assert %Ecto.Changeset{} = Photos.change_photo(photo)
    end
  end
end
