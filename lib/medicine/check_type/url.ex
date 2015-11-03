defmodule Medicine.CheckType.Url do
  defmacro __using__(options) do
    quote do
      @url Keyword.get(unquote(options), :url)

      def do_check(check) do
        %{check|status: Medicine.CheckType.CheckHelper.http_client.status(@url)}
      end
    end
  end
end
