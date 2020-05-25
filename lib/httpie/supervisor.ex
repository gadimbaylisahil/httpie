defmodule Httpie.Supervisor do
  use Supervisor

  def start_link do
    IO.puts "Starting THE supervisor..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Httpie.KickStarter,
      Httpie.ServicesSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
