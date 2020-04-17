require Logger

defmodule Httpie.Plugins do
  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/users"} = conv) do
    %{conv | path: "/members"}
  end

  def rewrite_path(conv), do: conv

  def log(conv) do
    Logger.info "Logging something"
    
    conv
  end
end