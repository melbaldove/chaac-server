defmodule ChaacServerWeb.PhotoControllerTest do
  use ChaacServerWeb.ConnCase

  alias ChaacServer.Photos
  alias ChaacServer.Photos.Photo

  @create_attrs %{caption: "some caption", checksum: "some checksum", created_date: ~D[2010-04-17], path: "some path", remarks: "some remarks"}
  @update_attrs %{caption: "some updated caption", checksum: "some updated checksum", created_date: ~D[2011-05-18], path: "some updated path", remarks: "some updated remarks"}
  @invalid_attrs %{caption: nil, checksum: nil, created_date: nil, path: nil, remarks: nil}

  def fixture(:photo) do
    {:ok, photo} = Photos.create_photo(@create_attrs)
    photo
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all photos", %{conn: conn} do
      conn = get conn, photo_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create photo" do
    test "renders photo when data is valid", %{conn: conn} do
      conn = post conn, photo_path(conn, :create), photo: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, photo_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "caption" => "some caption",
        "checksum" => "some checksum",
        "created_date" => ~D[2010-04-17],
        "path" => "some path",
        "remarks" => "some remarks"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, photo_path(conn, :create), photo: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update photo" do
    setup [:create_photo]

    test "renders photo when data is valid", %{conn: conn, photo: %Photo{id: id} = photo} do
      conn = put conn, photo_path(conn, :update, photo), photo: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, photo_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "caption" => "some updated caption",
        "checksum" => "some updated checksum",
        "created_date" => ~D[2011-05-18],
        "path" => "some updated path",
        "remarks" => "some updated remarks"}
    end

    test "renders errors when data is invalid", %{conn: conn, photo: photo} do
      conn = put conn, photo_path(conn, :update, photo), photo: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete photo" do
    setup [:create_photo]

    test "deletes chosen photo", %{conn: conn, photo: photo} do
      conn = delete conn, photo_path(conn, :delete, photo)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, photo_path(conn, :show, photo)
      end
    end
  end

  defp create_photo(_) do
    photo = fixture(:photo)
    {:ok, photo: photo}
  end
end
