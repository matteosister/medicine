defmodule Medicine.CheckType.Crawler do
  defmacro __using__(options) do
    quote bind_quoted: [options: options] do
      @url Keyword.get(options, :url)
      @search Keyword.get(options, :search)

      def do_check(check) do
        {:ok, %HTTPoison.Response{body: body}} =
          Medicine.CheckType.CheckHelper.http_client.get_response(@url)
        result = Medicine.CheckType.CheckHelper.get_text(body, @search[:selector])
        IO.puts body
        IO.inspect result
        #Medicine.CheckType.CheckHelper.get_text(html, @search[:selector])
        %{check|status: Medicine.CheckType.CheckHelper.http_client.status(@url)}
      end
    end
  end
end
