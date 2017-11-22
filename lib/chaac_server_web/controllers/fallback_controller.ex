defmodule ChaacServerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ChaacServerWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ChaacServerWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(ChaacServerWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :bad_photo}) do
    conn
    |> put_status(:bad_request)
    |> render(ChaacServerWeb.ErrorView, :"400", errors: %{photo: "Bad photo upload"})
  end
end
