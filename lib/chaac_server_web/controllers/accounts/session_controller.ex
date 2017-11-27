defmodule ChaacServerWeb.Accounts.SessionController do
  use ChaacServerWeb, :controller

  alias ChaacServer.Accounts
  alias ChaacServer.Accounts.Session

  action_fallback ChaacServerWeb.FallbackController

  def index(conn, _params) do
    sessions = Accounts.list_sessions()
    render(conn, "index.json", sessions: sessions)
  end

  def create(conn, %{"user" => user}) do
    with {:ok, token} <- Accounts.authenticate_user(user["username"], user["password"]) do
      conn
      |> put_status(:created)
      |> render("show.json", token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    session = Accounts.get_session!(id)
    render(conn, "show.json", session: session)
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    session = Accounts.get_session!(id)

    with {:ok, %Session{} = session} <- Accounts.update_session(session, session_params) do
      render(conn, "show.json", session: session)
    end
  end

  def delete(conn, %{"token" => token}) do
    session = Accounts.get_session!(token)
    with {:ok, %Session{}} <- Accounts.delete_session(session) do
      send_resp(conn, :no_content, "")
    end
  end
end
