defmodule ChaacServerWeb.PageController do
  use ChaacServerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
