defmodule KVstore.Storage do
  @moduledoc """
  модуль реализует СRUD для хранения данных.

  """
  use GenServer
  require Logger
  defmodule State do
    defstruct options: nil, table_name: nil, file_name: nil
  end
  @dets_options [auto_save: 500, access: :read_write, ram_file: true, type: :set]


  @doc """
  Starts with the given name.
  """
  def start_link(), do: start_link([])
  def start_link(params) do
    file_name = "/tmp/KVstore.db"
    # todo если файла нет
    if :dets.is_dets_file(file_name)
    do
     GenServer.start_link(__MODULE__,
      %State{options: params ++ @dets_options, file_name: file_name }, [{:name, __MODULE__}])
    else
    Logger.error("Error initializing db dets file : #{inspect file_name}")
    {:error, file_name}
    end
  end


  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.stop(server)
  end




  @doc """

  """
  def create(key, value), do: set(key, value, 60*2)
  def create(key, value, ttl), do: set(key, value, ttl)
  def set(key, value), do: set(key, value, 60*2)
  def set(key, value, ttl) do
    GenServer.call(__MODULE__, {:set, key, value, ttl})
  end
  def read(key), do: get(key)
  def get(key), do: GenServer.call(__MODULE__, {:get, key})

  def upd(key, value, ttl), do: update(key, value, ttl)
  def update(key, value, ttl), do: set(key, value, ttl)

  def del(key), do: delete(key)
  def delete(key), do: GenServer.cast(__MODULE__, {:del, key})

  ## local function
  defp now(), do:  :calendar.datetime_to_gregorian_seconds(:calendar.local_time())
  ## Server callbacks

  def init(state) do
    #
    #_name = :ets.new(state.table_name, [:named_table, read_concurrency: true])
    {:ok, table} = :dets.open_file(state.file_name, state.options )
    state = %{state |  table_name: table }
    Logger.info "KVStorage #{inspect self()} ready with state: #{inspect state}"
    {:ok, state}
  end


  def terminate(_reason, _state) do
    Logger.info "Stored Service terminated!"
    # :dets.delete(state.table_name)
    :ok
  end


  def handle_call({:set, key, value, ttl}, _from, state) do
        :dets.insert(state.table_name, {key, value, ttl, now()})
        Logger.info "KVStored key #{inspect key} value: #{inspect value} ttl: #{inspect ttl} "
        {:reply, :ok, state}
  end
    def handle_call({:get, key}, _from, state) do

    case :dets.lookup(state.table_name, key) do
      [{_, value, ttl, update_time}] ->

        if update_time + ttl < now()  do
        {:reply, value, state}
        else
        Logger.info " TTL Exist #{inspect update_time} + #{inspect ttl} <  #{inspect now()} "
        # todo delete
        {:reply, {:error, "stale"}, state}
        end
      any ->
        Logger.info "KVStored value #{inspect any} "
        {:reply, {:error, "no found"}, state}
    end
  end



  def handle_call(:stop, _from, state) do
   {:stop, :normal, :stopped, state}
  end


  def handle_cast({:del, key}, state) do
    # удялем указаный ключ
    case :dets.lookup(state.table_name, key) do
      [_st] ->
        :dets.delete(state.table_name, key)
        {:noreply,  state}
      :error ->
        {:noreply, state}
    end
  end

  def handle_info(_msg, state), do:    {:noreply, state}
  def code_change(_old_version, state, _extra), do: {:ok, state}

end
