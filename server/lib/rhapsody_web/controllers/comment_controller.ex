defmodule RhapsodyWeb.CommentController do
  use RhapsodyWeb, :controller

  alias Rhapsody.Comments
  alias Rhapsody.Comments.Comment

  alias RhapsodyWeb.Plugs
  plug Plugs.RequireAuth when action
   in [:create]

  action_fallback RhapsodyWeb.FallbackController

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    user = conn.assigns[:current_user]
    comment_params = comment_params
    |> Map.put("user_id", user.id)
    IO.puts(inspect(user))
    
    with {:ok, %Comment{} = comment} <- Comments.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.comment_path(conn, :show, comment))
      |> send_resp(:ok, Jason.encode!(%{}))
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    |> Comments.load_user()
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Comments.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)

    with {:ok, %Comment{}} <- Comments.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
