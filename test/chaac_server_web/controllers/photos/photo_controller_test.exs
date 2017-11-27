defmodule ChaacServerWeb.Photos.PhotoControllerTest do
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
    user = fixture(:user)
    {:ok, token} = Accounts.authenticate_user(user.username, user.password)
    {:ok, conn: conn |> put_req_header("accept", "application/json") 
                     |> put_req_header("authorization", token) , user: user}
  end

  describe "index" do
    test "lists all photos", %{conn: conn, user: user} do
      conn = get conn, user_photo_path(conn, :index, user.id)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create photo" do
    test "renders photo when data is valid", %{conn: conn, user: %Accounts.User{} = user} do
      response = post conn, user_photo_path(conn, :create , user.id), photo: fixture(:photo_upload)
      assert %{"id" => id} = json_response(response, 201)["data"]

      response = get conn, user_photo_path(conn, :show, user.id, id)
      assert json_response(response, 200)["data"] == %{
        "id" => id,
        "caption" => nil,
        "checksum" => @checksum,
        "created_date" => nil,
        "path" => "/uploads/user/photos/test/original_#{@checksum}.jpg",
        "remarks" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      response = post conn, user_photo_path(conn, :create, user.id), photo: @invalid_attrs
      assert json_response(response, 400)["errors"] != %{}
    end
  end

  describe "update photo" do

    test "renders photo when data is valid", %{conn: conn, user: %Accounts.User{} = user} do
      %{id: id} = photo = fixture(:photo, user)
      response = put conn, user_photo_path(conn, :update, user.id, photo), photo: @update_attrs
      assert %{"id" => ^id} = json_response(response, 200)["data"]
      response = get conn, user_photo_path(conn, :show, user.id, id)
      assert json_response(response, 200)["data"] == %{
        "id" => id,
        "caption" => "some updated caption",
        "checksum" => "some updated checksum",
        "created_date" => "2011-05-18",
        "path" => "some updated path",
        "remarks" => "some updated remarks"}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      photo = fixture(:photo, user)      
      response = put conn, user_photo_path(conn, :update, user.id, photo), photo: @invalid_attrs
      assert json_response(response, 422)["errors"] != %{}
    end
  end

  describe "delete photo" do

    test "deletes chosen photo", %{conn: conn, user: user} do
      %{id: id} = photo = fixture(:photo, user)
      response = delete conn, user_photo_path(conn, :delete, user.id, photo)
      assert response(response, 204)
      assert_error_sent 404, fn ->
        get conn, user_photo_path(conn, :show, user.id, photo)
      end
    end
  end
end
