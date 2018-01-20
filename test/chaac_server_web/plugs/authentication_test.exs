defmodule ChaacServerWeb.AuthenticationTest do
  use ChaacServerWeb.ConnCase
  alias ChaacServer.Accounts
  alias ChaacServer.Accounts.User

  @create_attrs %{username: "some username"}
  
  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  test "authentication plug should return conn on valid token", %{conn: conn} do
    user = fixture(:user)
    {:ok, %{"token" => token, "userId" => _}} = Accounts.authenticate_user(user.username, user.password)
    conn = conn
    |> put_req_header("authorization", token )    
    |> Map.put(:params, %{"user_id" => user.id})    
    assert conn ==  ChaacServerWeb.Plugs.Authentication.call(conn, nil)
  end

  test "authentication plug should return 401 when not authenticated", %{conn: conn} do  
    conn = Map.put(conn, :params, %{"_format" => "json"})
    conn =  ChaacServerWeb.Plugs.Authentication.call(conn, nil)
    assert json_response(conn, 401)["errors"] != %{}
  end
end