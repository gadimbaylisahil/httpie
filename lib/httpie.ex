defmodule Httpie do
  use Application

  def start(_type, _args) do
    IO.puts "Starting the application..."
    Httpie.Supervisor.start_link()
  end
end
