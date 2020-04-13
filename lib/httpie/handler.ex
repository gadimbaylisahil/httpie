defmodule Httpie.Handler do
  def handle(request) do
    request 
      |> parse
      |> rewrite_path
      |> log 
      |> route 
      |> track
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

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/users"} = conv) do
    %{conv | path: "/members"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  def route(%{method: "GET", path: "/products" <> id} = conv) do
    %{ conv | status: 200, res_body: "Product #{id}"}
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
GET /membersfsdf HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = 
  Httpie.Handler.handle(request)

IO.puts response