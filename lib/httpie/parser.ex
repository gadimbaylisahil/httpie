defmodule Httpie.Parser do
  
  alias Httpie.Conv, as: Conv

  def parse(request) do
    [top, params_string] = 
      String.split(request, "\n\n")

    [request_line | header_lines ] = 
      String.split(top, "\n")

    params = parse_params(params_string)

    [method, path, _] = 
      top 
      |> String.split("\n") 
      |> List.first
      |> String.split(" ")
    
    %Conv{
      method: method, 
      path: path,
      params: params
      }
  end

  def parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end
end