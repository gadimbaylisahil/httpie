require Logger

defmodule Httpie.Plugins do

  alias Httpie.Conv, as: Conv

  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/users"} = conv) do
    %{conv | path: "/members"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    Logger.info "Logging something"
    
    conv
  end
end