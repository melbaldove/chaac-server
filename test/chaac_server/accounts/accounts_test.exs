defmodule ChaacServer.AccountsTest do
  use ChaacServer.DataCase

  alias ChaacServer.Accounts

  describe "users" do
    alias ChaacServer.Accounts.User

    @valid_attrs %{password: "some password", username: "some username"}
    @update_attrs %{password: "some updated password", username: "some updated username"}
    @invalid_attrs %{password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} = 
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "generate_password/1 returns a changeset with generated password with valid changeset" do
      assert %Ecto.Changeset{changes: %{password: password}} = 
        User.changeset(%User{}, @valid_attrs)
        |> User.generate_password()
      assert password
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.password
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.password == "some updated password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "sessions" do
    alias ChaacServer.Accounts.Session

    def session_fixture() do
      {:ok, session} = Accounts.create_session(user_fixture().id)
      
      session
    end

    test "authenticate/2 with valid user creds generates token" do
      user = user_fixture()
      assert {:ok, %{"token" => _, "userId" => _ } = token} = Accounts.authenticate_user(user.username, user.password)
      assert token
    end

    test "authenticate/2 with invalid user returns {:error, :invalid_credentials}" do
      assert {:error, :invalid_credentials} = Accounts.authenticate_user("some weird", "password")
    end

    test "validate_token/2 with valid token and user_id returns token if it exists in user" do
      session = session_fixture()
      assert {:ok, token} = Accounts.validate_token(session.user_id, session.token)
      assert token
    end

    test "validate_token/2 with invalid token returns {:error, :not_authenticated}" do
      session = session_fixture()
      # Token not valid
      assert {:error, :not_authenticated} = Accounts.validate_token(session.user_id, "some invalid token")      
    end

    test "create_session/1 with valid user_id creates a session" do
      user = user_fixture()
      assert {:ok, %Session{} = session} = Accounts.create_session(user.id)
      assert session.token
      assert session.expiry
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_session(10)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Accounts.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_session!(session.token) end
    end
  end
end
