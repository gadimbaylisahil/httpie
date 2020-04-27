defmodule Httpie.Shop do
  alias Httpie.Product
  
  def list_products do
    [
      %Product{id: 1, type: 'Plastic', name: 'Spoon'},
      %Product{id: 2, type: 'Cotton',  name: 'Toy'},
      %Product{id: 3, type: 'Plastic', name: 'Spoon'},
      %Product{id: 4, type: 'Plastic', name: 'Spoon'},
      %Product{id: 5, type: 'Plastic', name: 'Spoon'}
    ]
  end

  def get_product(id) when is_integer(id) do

    Enum.find(
      list_products(), fn(product) -> product.id == id end
    )
  end

  def get_product(id) when is_binary(id) do
    id |> String.to_integer |> get_product
  end
end