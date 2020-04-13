defmodule Httpie.Handler do
  def handle(request) do
    request 
      |> parse 
      |> route 
      |> format_response
  end

  def parse(request) do
    [method, path, _] = 
      request 
      |> String.split("\n") 
      |> List.first
      |> String.split(" ")
    
    %{method: method, path: path, res_body: ""}
  end

  def route(conv) do
    %{conv | res_body: "Product1, Product2, Product2"}
  end

  def format_response(conv) do
    """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: #{String.length(conv.res_body)}

      #{conv.res_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = 
  Httpie.Handler.handle(request)

IO.puts response