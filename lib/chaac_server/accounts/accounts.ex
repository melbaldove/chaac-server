defmodule ChaacServer.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ChaacServer.{Repo, Utils, Accounts.User}


  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> User.generate_password()
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias ChaacServer.Accounts.Session

  @doc """
  Authenticates a user

  ## Examples
      iex> authenticate_user(username, password)
      {:ok, token}

      iex> authenticate_user(invalid_username, invalid_password)
      {:error, :invalid_credentials}
  """
  def authenticate_user(username, password) do
    with %User{} = user <- Repo.get_by(User, username: username, password: password),
         {:ok, session} <- create_session(user.id)
    do
      {:ok, session.token}         
    else
      _ -> {:error, :invalid_credentials}
    end
  end

  @doc """
  Validates a token for a user

  ## Examples
      
      iex> validate_token(user_id, valid_token)
      {:ok, valid_token}

      iex> validate_token(user_id, invalid_token)
      {:error, :not_authenticated}
  """
  def validate_token(user_id, token) when is_binary(token) do
    case Repo.get_by(Session, user_id: user_id, token: token) do
      nil -> {:error, :not_authenticated}
      session -> {:ok, session.token}
    end
  end
  def validate_token(_, _) do
    {:error, :not_authenticated}
  end

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the Session does not exist.

  ## Examples

      iex> get_session!(123)
      %Session{}

      iex> get_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_session!(token), do: Repo.get_by!(Session, token: token)

  @doc """
  Creates a session.

  ## Examples

      iex> create_session(valid_user_id)
      {:ok, %Session{}}

      iex> create_session(invalid_user_id)
      {:error, %Ecto.Changeset{}}

  """
  def create_session(user_id) do
    token = Utils.generate_string
    date = Ecto.DateTime.utc
    %Session{}
    |> Session.changeset(%{token: token, expiry: date, user_id: user_id})
    |> Repo.insert()
  end

  @doc """
  Deletes a Session.

  ## Examples

      iex> delete_session(session)
      {:ok, %Session{}}

      iex> delete_session(session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end
end
