defmodule KVstore.WebRouter do
  @moduledoc """
  Маршрутизатор для запросов
  """
  use Plug.Router
  plug :match
  plug :dispatch
  # todo get
  # todo set
  # todo del
  # todo upd
  # todo list
  get "/" do

    conn  |> send_resp(200, "Plug!")
  end

  get "/set/:key/:val/:ttl", do: send_resp(conn, 200, "set: " <> key <> ","<> val <> ":" <>ttl <> "!")

  match _, do: send_resp(conn, 404, "Not implemented")
end
