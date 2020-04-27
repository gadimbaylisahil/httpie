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
end