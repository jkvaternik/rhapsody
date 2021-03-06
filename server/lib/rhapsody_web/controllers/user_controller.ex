defmodule RhapsodyWeb.UserController do
  use RhapsodyWeb, :controller

  alias Rhapsody.Users
  alias Rhapsody.Users.User

  action_fallback RhapsodyWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    # users = Enum.map(users, fn user -> Users.load_user(user) end)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    IO.inspect(user_params)
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      user = user
      |> Users.load_user()
      
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id) |> Users.load_user
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
