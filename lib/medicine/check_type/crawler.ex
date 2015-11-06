defmodule Medicine.CheckType.Crawler do
  defmacro __using__(options) do
    quote bind_quoted: [options: options] do
      alias Medicine.CheckType.CheckHelper

      @url Keyword.get(options, :url)
      @search Keyword.get(options, :search)

      def do_check(check) do
        {:ok, %HTTPoison.Response{body: body}} =
          CheckHelper.http_client.get_response(@url)
        results = CheckHelper.get_text(body, @search[:selector])
        is_contained = String.contains?(results, @search[:text])
        %{check|status: CheckHelper.status(is_contained)}
      end
    end
  end
end
