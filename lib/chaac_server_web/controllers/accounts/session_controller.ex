defmodule ChaacServerWeb.Accounts.SessionController do
  use ChaacServerWeb, :controller

  alias ChaacServer.Accounts
  alias ChaacServer.Accounts.Session

  action_fallback ChaacServerWeb.FallbackController

  def index(conn, _params) do
    sessions = Accounts.list_sessions()
    render(conn, "index.json", sessions: sessions)
  end

  def create(conn, %{"session" => session_params}) do
    with {:ok, %Session{} = session} <- Accounts.create_session(session_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_session_path(conn, :show, session))
      |> render("show.json", session: session)
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

  def delete(conn, %{"id" => id}) do
    session = Accounts.get_session!(id)
    with {:ok, %Session{}} <- Accounts.delete_session(session) do
      send_resp(conn, :no_content, "")
    end
  end
end
