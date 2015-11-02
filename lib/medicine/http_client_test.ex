defmodule Medicine.HttpClientTest do
  def ok?("http://pipe.cypresslab.net"), do: true
  def ok?(_), do: false
end
