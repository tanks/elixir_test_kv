defmodule KVstore do
  @moduledoc """
  Модуль <b>KVstore</b> - точкой входа приложения.

  """
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    # TODO listen порт в качестве параметра
    children = [
      # Starts a worker by calling
      worker(__MODULE__, [], function: :start_web_site),
      worker(KVstore.Storage,[])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KVstore.Supervisor]
    sup_res = Supervisor.start_link(children, opts)
    Logger.info "Starting Root supervisor #{inspect sup_res}"
    sup_res
  end

  def start_web_site do
    # можно задать acceptors:
    {:ok, res} = Plug.Adapters.Cowboy.http(KVstore.WebRouter, [],[port: 8080])
    Logger.info "WebRouter ready: #{inspect res}"
    {:ok, res}
  end
end