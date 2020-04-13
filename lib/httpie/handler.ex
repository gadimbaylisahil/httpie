defmodule Httpie.Handler do
  def handle(request) do
    request 
      |> parse
      |> rewrite_path
      |> log 
      |> route 
      |> format_response
  end

  def parse(request) do
    [method, path, _] = 
      request 
      |> String.split("\n") 
      |> List.first
      |> String.split(" ")
    
    %{
      method: method, 
      path: path, 
      res_body: "",
      status: nil
      }
  end

  def rewrite_path(%{path: "/users"} = conv) do
    %{conv | path: "/members"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/products/" <> id) do
    %{ conv | status: 200, res_body: "Product #{id}"}
  end

  def route(conv, "GET", "/products") do
    %{conv | status: 200, res_body: "Product1, Product2, Product2"}
  end

  def route(conv, "GET", "/members") do
    %{conv | status: 200, res_body: "Member1, Member2, Member2"} 
  end

  def route(conv, _method, path) do
    %{ conv | status: 404, res_body: "No #{path} here!"}
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
GET /members HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = 
  Httpie.Handler.handle(request)

IO.puts response