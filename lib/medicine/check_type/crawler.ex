defmodule Medicine.CheckType.Crawler do
  defmacro __using__(options) do
    quote do
      @url Keyword.get(unquote(options), :url)

      def do_check(check) do
        %{check|status: Medicine.CheckType.Url.get_response(@url)}
      end
    end
  end
end
