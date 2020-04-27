defmodule Httpie.ProductController do
  alias Httpie.Shop

  def index(conv) do
    items = 
      Shop.list_products
      |> Enum.sort(fn(a, b) -> a.name <= b.name end)
      |> Enum.map(fn(el) -> "<li>#{el.name}</li>" end)
      |> Enum.join(",")

    %{conv | status: 200, res_body: "<ul>#{items}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    product = Shop.get_product(id)

     %{conv | status: 200, res_body: "Showing Product #{product.name}"}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{ conv | 
       status: 201, 
       res_body: "Created a #{type} product named #{name}"
    }
  end
end