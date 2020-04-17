defmodule Httpie.Handler do

  @moduledoc """
    HTTP Server
  """

  import Httpie.Plugins, 
    only: [track: 1, rewrite_path: 1, log: 1]

  import Httpie.Parser, 
    only: [parse: 1]
  @pages_path Path.expand("../pages", __DIR__)

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

  def route(%{method: "GET", path: "/products" <> id} = conv) do
    %{ conv | status: 200, res_body: "Product #{id}"}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{method: "GET", path: "/products"} = conv) do
    %{conv | status: 200, res_body: "Product1, Product2, Product2"}
  end

  def route(%{method: "GET", path: "/members"} = conv) do
    %{conv | status: 200, res_body: "Member1, Member2, Member2"} 
  end

  def route(%{path: path} = conv) do
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

  def format_response(conv) do
    """
      HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
      Content-Type: text/html
      Content-Length: #{String.length(conv.res_body)}

      #{conv.res_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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