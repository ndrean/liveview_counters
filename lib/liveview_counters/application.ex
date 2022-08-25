defmodule LiveviewCounters.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :counters = :ets.new(:counters, [:set, :named_table, :public])

    children = [
      # Start the Telemetry supervisor
      LiveviewCountersWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveviewCounters.PubSub, adapter: Phoenix.PubSub.PG2},
      # Start the Endpoint (http/https)
      LiveviewCountersWeb.Endpoint
      # Start a worker by calling: LiveviewCounters.Worker.start_link(arg)
      # {LiveviewCounters.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveviewCounters.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveviewCountersWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
