defmodule KVstoreTest do
  use ExUnit.Case, async: true
  require Logger
  doctest KVstore

  test "CRUD" do
    res = KVstore.Storage.set("testkey0",0)
    assert res == :ok
    res = KVstore.Storage.get("testkey0")
    assert res == 0
    res = KVstore.Storage.upd("testkey0",1)
    assert res == :ok
    res = KVstore.Storage.get("testkey0")
    assert res == 1
    res = KVstore.Storage.del("testkey0")
    assert res == :ok
    res = KVstore.Storage.get("testkey0")
    assert res == {:error, "no found", 200}
  end
  test "get stale key" do
    res = KVstore.Storage.set("testkey1",0,0)
    assert res == :ok
    res = KVstore.Storage.get("testkey1")
    assert res == {:error, "Time to live exist. :(", 202}
    Logger.info "KVStorage #{inspect res}"

  end
end
