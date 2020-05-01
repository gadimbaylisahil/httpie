defmodule Httpie.ProductController do
  alias Httpie.Shop

  @products_template Path.expand("../templates", __DIR__)

  defp render(conv, template, bindings) do
    content = @products_template
      |> Path.join(template)
      |> EEx.eval_file(bindings)

      %{conv | status: 200, res_body: content}
  end

  def index(conv) do
    render(conv, "index.eex", products: Shop.list_products)
  end

  def show(conv, %{"id" => id}) do
    render(conv, "show.eex", product: Shop.get_product(id))
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{ conv |
       status: 201,
       res_body: "Created a #{type} product named #{name}"
    }
  end
end
