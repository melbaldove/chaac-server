defmodule ChaacServerWeb.Plugs.Authentication do
  import Plug.Conn

  alias ChaacServer.Accounts

  def init(default), do: default

  def call(conn, _) do
    token = List.first(get_req_header(conn, "authorization"))
    case Accounts.validate_token(conn.params["user_id"], token) do
      {:ok, valid_token} -> conn
      err -> 
        conn 
      |> halt() 
      |> ChaacServerWeb.FallbackController.call(err)
    end
  end
end