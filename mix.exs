defmodule KVstore.Mixfile do
    @moduledoc """
	Конфигурационный файл сборщика проектов Mix.

	"""
  use Mix.Project
  @doc """
  Функция <b>project</b> возвращает список параметров проекта.
  """
  def project do
    [app: :kvstore,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: "KV store",
	 name: "KVS"
     ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  @doc """
  точка входа в приложение: модуль KVstore
  и список зависимостей
  """
  def application do
    [
      applications: [:logger, :cowboy, :plug],
      mod: {KVstore, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:calendar,">= 0.17.2"},
      {:plug, "~> 1.3.3"},
      {:cowboy, "~> 1.1.2"}
    ]
  end
end
