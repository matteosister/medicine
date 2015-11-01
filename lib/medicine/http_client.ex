defmodule Medicine.HttpClient do
  @doc """
  given an url returns :ok for a status code of 20*, otherwise :error
  """
  def ok?(url) do
    try do
      response = get_response(url)
      HTTPotion.Response.success?(response)
    rescue
      HTTPotion.HTTPError -> false
    end
  end

  def get_response(url) do
    HTTPotion.get(url)
  end

  def success?(response) do
    HTTPotion.Response.success?(response)
  end
end
