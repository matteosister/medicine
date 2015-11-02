defmodule Medicine.CheckType.Crawler do
  defmacro __using__(options) do
    quote do
      @url Keyword.get(unquote(options), :url)

      def do_check(check) do
        %{check|status: http_client.get_response(@url)}
      end

      defp http_client do
        Application.get_env(:medicine, :http_client)
      end
    end
  end
end
