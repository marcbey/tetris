defmodule TetrisWeb.SessionController do
  use TetrisWeb, :controller

  def save_player(conn, %{"player_name" => player_name}) do
    conn
    |> put_session("player_name", String.trim(player_name || ""))
    |> redirect(to: "/game/playing")
  end

  def save_score(conn, %{"score" => score}) do
    score_int =
      case score do
        s when is_integer(s) -> s
        s when is_binary(s) -> case Integer.parse(s) do {i, _} -> i; :error -> 0 end
        _ -> 0
      end

    conn
    |> put_session("last_score", score_int)
    |> send_resp(204, "")
  end
end

