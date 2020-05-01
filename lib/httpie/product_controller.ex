defmodule Httpie.ProductController do
  alias Httpie.Shop

  @products_template Path.expand("../templates", __DIR__)

  def index(conv) do
    content = @products_template
      |> Path.join("index.eex")
      |> EEx.eval_file(products: Shop.list_products)

    %{conv | status: 200, res_body: content}
  end

  def show(conv, %{"id" => id}) do
    content = @products_template
      |> Path.join("show.eex")
      |> EEx.eval_file(product: Shop.get_product(id))

     %{conv | status: 200, res_body: content}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{ conv |
       status: 201,
       res_body: "Created a #{type} product named #{name}"
    }
  end
end
