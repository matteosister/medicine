defmodule Medicine.HttpClient do
  @doc """
  given an url returns :ok for a status code of 20*, otherwise :error
  """
  def status(url) do
    case ok?(url) do
      true  -> :ok
      false -> :error
    end
  end

  defp ok?(url) do
    case get_response(url) do
      {:ok, _} -> true
      _        -> false
    end
  end

  def get_response(url) do
    HTTPoison.get(url, ssl: true)
  end
end
