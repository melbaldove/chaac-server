defmodule ChaacServerWeb.Accounts.SessionControllerTest do
  use ChaacServerWeb.ConnCase

  alias ChaacServer.Accounts
  alias ChaacServer.Accounts.Session

  @create_attrs %{expiry: ~D[2010-04-17], token: "some token"}
  @update_attrs %{expiry: ~D[2011-05-18], token: "some updated token"}
  @invalid_attrs %{expiry: nil, token: nil}

  def fixture(:session) do
    {:ok, session} = Accounts.create_session(@create_attrs)
    session
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sessions", %{conn: conn} do
      
    end
  end

  describe "create session" do
    test "renders session when data is valid", %{conn: conn} do
      
    end

    test "renders errors when data is invalid", %{conn: conn} do
    end
  end

  describe "update session" do
    setup [:create_session]

    test "renders session when data is valid", %{conn: conn, session: %Session{id: id} = session} do
      
    end

    test "renders errors when data is invalid", %{conn: conn, session: session} do
      
    end
  end

  describe "delete session" do
    setup [:create_session]

    test "deletes chosen session", %{conn: conn, session: session} do
      
    end
  end

  defp create_session(_) do
    session = fixture(:session)
    {:ok, session: session}
  end
end
