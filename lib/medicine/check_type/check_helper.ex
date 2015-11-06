defmodule Medicine.CheckType.CheckHelper do
  def http_client do
    Application.get_env(:medicine, :http_client, Medicine.HttpClient)
  end

  def get_text(html, selector) do
    Floki.find(html, selector)
    |> Floki.text
  end

  def status(true), do: :ok
  def status(false), do: :error
end
