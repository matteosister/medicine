defmodule Medicine.HttpClient do
  @doc """
  given an url returns :ok for a status code of 20*, otherwise :error
  """
  def ok?(url) do
    try do
      success? get_response(url)
    rescue
      HTTPotion.HTTPError -> false
    end
  end

  defp success?(response) do
    HTTPotion.Response.success?(response)
  end

  defp get_response(url) do
    HTTPotion.get(url)
  end
end
