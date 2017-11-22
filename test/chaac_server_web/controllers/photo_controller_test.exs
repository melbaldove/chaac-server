defmodule ChaacServerWeb.PhotoControllerTest do
  use ChaacServerWeb.ConnCase

  alias ChaacServer.Photos
  alias ChaacServer.Photos.Photo
  alias ChaacServer.Accounts

  @valid_photo "test/chaac_server/photos/TestPhoto.jpg"  
  @checksum "fd0718a2854df251cfa264162a04fc31"  
  @update_attrs %{caption: "some updated caption", checksum: "some updated checksum", created_date: ~D[2011-05-18], path: "some updated path", remarks: "some updated remarks"}
  @invalid_attrs %{caption: nil, checksum: nil, created_date: nil, path: nil, remarks: nil}

  def fixture(:photo, user) do
    {:ok, photo} = Photos.create_photo(@valid_photo, user)
    photo
  end
  def fixture(:photo_upload) do
    %Plug.Upload{ filename: "TestPhoto.jpg", path: @valid_photo }
  end
  def fixture(:user) do
    {:ok, user} = Accounts.create_user(%{username: "test"})
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all photos", %{conn: conn} do
      conn = get conn, user_photo_path(conn, :index, fixture(:user).id)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create photo" do
    setup [:create_user]
    test "renders photo when data is valid", %{conn: conn, user: %Accounts.User{} = user} do
      conn = post conn, user_photo_path(conn, :create , user.id), photo: fixture(:photo_upload)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_photo_path(conn, :show, user.id, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "caption" => nil,
        "checksum" => @checksum,
        "created_date" => nil,
        "path" => "/uploads/user/photos/test/original.jpg",
        "remarks" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = post conn, user_photo_path(conn, :create, user.id), photo: @invalid_attrs
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "update photo" do
    setup [:create_photo]

    test "renders photo when data is valid", %{conn: conn, photo: %Photo{id: id} = photo, user: %Accounts.User{} = user} do
      conn = put conn, user_photo_path(conn, :update, user.id, photo), photo: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_photo_path(conn, :show, user.id, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "caption" => "some updated caption",
        "checksum" => "some updated checksum",
        "created_date" => "2011-05-18",
        "path" => "some updated path",
        "remarks" => "some updated remarks"}
    end

    test "renders errors when data is invalid", %{conn: conn, photo: photo, user: user} do
      conn = put conn, user_photo_path(conn, :update, user.id, photo), photo: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete photo" do
    setup [:create_photo]

    test "deletes chosen photo", %{conn: conn, photo: photo, user: user} do
      conn = delete conn, user_photo_path(conn, :delete, user.id, photo)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_photo_path(conn, :show, user.id, photo)
      end
    end
  end

  defp create_photo(_) do
    user = fixture(:user)    
    photo = fixture(:photo, user)
    {:ok, photo: photo, user: user}
  end
  defp create_user(_) do
    user = fixture(:user)    
    {:ok, user: user}
  end
end
