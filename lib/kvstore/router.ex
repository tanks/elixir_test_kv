defmodule KVstore.WebRouter do
  @moduledoc """
  Маршрутизатор для запросов
  """
  use Plug.Router
  # represented by a local match/2 function,
  # and then call the :dispatch plug which will execute the matched code
  plug :match
  plug :dispatch

  get "/" do
    conn  |> send_resp(200, "TODO need help here!")
  end
  # todo воспользоватся регэкспами
  get "/set/:key/:val/:ttl", do: Help.r(conn, KVstore.Storage.set(key,val,ttl))
  get "/create/:key/:val/:ttl", do: Help.r(conn, KVstore.Storage.set(key,val,ttl))
  get "/upd/:key/:val/:ttl", do: Help.r(conn, KVstore.Storage.set(key,val,ttl))

  get "/create/:key/:val", do: Help.r(conn, KVstore.Storage.set(key,val))
  get "/set/:key/:val", do: Help.r(conn, KVstore.Storage.set(key,val))
  get "/upd/:key/:val", do: Help.r(conn, KVstore.Storage.set(key,val))

  get "/get/:key", do: Help.r(conn, KVstore.Storage.get(key))
  get "/del/:key", do: Help.r(conn, KVstore.Storage.del(key))
  get "/delete/:key", do: Help.r(conn, KVstore.Storage.del(key))

  match _, do: send_resp(conn, 501, "Not implemented")
end
