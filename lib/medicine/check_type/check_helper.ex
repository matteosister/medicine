defmodule Medicine.CheckType.CheckHelper do
  def http_client do
    Application.get_env(:medicine, :http_client, Medicine.HttpClient)
  end
end
