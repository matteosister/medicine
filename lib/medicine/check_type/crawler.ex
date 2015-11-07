defmodule Medicine.CheckType.Crawler do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import Medicine.Check
    end
  end

  defmacro crawl(check_url, opts) do
    quote do
      def do_check(check) do
        url = unquote(check_url)
        options = unquote(opts)
        {:ok, %HTTPoison.Response{body: body}} =
          Medicine.CheckType.CheckHelper.http_client.get_response(url)
        results = Medicine.CheckType.CheckHelper.get_text(body, options[:in])
        is_contained = String.contains?(results, options[:look_for])
        %{check|status: Medicine.CheckType.CheckHelper.status(is_contained)}
      end
    end
  end
end
