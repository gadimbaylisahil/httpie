defmodule Httpie.Handler do

  @moduledoc """
    HTTP Server
  """

  import Httpie.Plugins, 
    only: [track: 1, rewrite_path: 1, log: 1]

  import Httpie.Parser, 
    only: [parse: 1]
  @pages_path Path.expand("../pages", __DIR__)

  alias Httpie.Conv, as: Conv
  @doc "Handles the request"
  def handle(request) do
    request 
      |> parse
      |> rewrite_path
      |> log 
      |> route 
      |> track
      |> format_response
  end

  def route(%Conv{method: "GET", path: "/products" <> id} = conv) do
    %{ conv | status: 200, res_body: "Product #{id}"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/products"} = conv) do
    %{conv | status: 200, res_body: "Product1, Product2, Product2"}
  end

  def route(%Conv{method: "GET", path: "/members"} = conv) do
    %{conv | status: 200, res_body: "Member1, Member2, Member2"} 
  end

  def route(%Conv{path: path} = conv) do
    %{ conv | status: 404, res_body: "No #{path} here!"}
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, res_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, res_body: "File not found!"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, res_body: "Error: #{reason}."}
  end

  def format_response(%Conv{} = conv) do
    """
      HTTP/1.1 #{Conv.full_status(conv)}
      Content-Type: text/html
      Content-Length: #{String.length(conv.res_body)}

      #{conv.res_body}
    """
  end
end

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = 
  Httpie.Handler.handle(request)

IO.puts response