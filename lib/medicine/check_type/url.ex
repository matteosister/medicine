defmodule Medicine.CheckType.Url do
  defmacro __using__(options) do
    quote do
      @url Keyword.get(unquote(options), :url)

      def do_check(check) do
        %{check|status: Medicine.CheckType.Url.get_response(@url)}
      end
    end
  end

  def get_response(url) do
    try do
      response = HTTPotion.get(url)
      case HTTPotion.Response.success?(response) do
        true -> :ok
        _ -> :error
      end
    rescue
      HTTPotion.HTTPError -> :error
    end
  end
end
