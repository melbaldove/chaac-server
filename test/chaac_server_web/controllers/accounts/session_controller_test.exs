defmodule ChaacServerWeb.Accounts.SessionControllerTest do
  use ChaacServerWeb.ConnCase

  alias ChaacServer.Accounts
  alias ChaacServer.Accounts.Session

  @create_attrs %{expiry: ~D[2010-04-17], token: "some token"}
  @update_attrs %{expiry: ~D[2011-05-18], token: "some updated token"}
  @invalid_attrs %{expiry: nil, token: nil}

  def fixture(:session) do
    user = fixture(:user)
    {:ok, session} = Accounts.create_session(user.id)
    session
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(%{username: "some username"})
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sessions", %{conn: conn} do
      
    end
  end

  describe "create session" do
    test "returns token when user credentials are valid", %{conn: conn} do
      user = fixture(:user)
      conn = post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
      assert %{"token" => token} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: %{username: "some user", password: "some password"}
      assert json_response(conn, 401)["errors"] != %{}
    end
  end


  describe "delete session" do
    setup [:create_session]

    test "deletes chosen session", %{conn: conn, session: session} do
      conn = delete conn, session_path(conn, :delete, session.token)
      assert response(conn, 204)
    end
  end

  defp create_session(_) do
    session = fixture(:session)
    {:ok, session: session}
  end
end
