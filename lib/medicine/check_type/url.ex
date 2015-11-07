defmodule Medicine.CheckType.Url do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import Medicine.Check
    end
  end

  defmacro url(check_url) do
    quote do
      def do_check(check) do
        %{check|status: Medicine.CheckType.CheckHelper.http_client.status(unquote(check_url))}
      end
    end
  end
end
