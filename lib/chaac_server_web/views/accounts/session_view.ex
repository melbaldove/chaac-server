defmodule ChaacServerWeb.Accounts.SessionView do
  use ChaacServerWeb, :view
  alias ChaacServerWeb.Accounts.SessionView

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end
  
  def render("show.json", %{token: token}) do
    %{data: %{token: token}}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      token: session.token,
      expiry: session.expiry}
  end
end
