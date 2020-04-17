defmodule Httpie.Parser do
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
end