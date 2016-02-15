defmodule Elide do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Elide.Endpoint, []),
      # Start the Ecto repository
      supervisor(Elide.Repo, []),
      worker(Elide.Cache.ApiRateLimit, []),
      worker(Elide.ElinkSeqServer, []),
      worker(Elide.ElinkServer, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elide.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Elide.Endpoint.config_change(changed, removed)
    :ok
  end
end
