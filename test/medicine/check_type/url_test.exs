defmodule Medicine.CheckType.UrlTest do
  use ExUnit.Case

  test "status is ok when http_client responds ok" do
    check = Medicine.Check.new(CheckTypeUrlOk)
    assert CheckTypeUrlOk.do_check(check).status
  end

  test "status is error when http_client responds error" do
    check = Medicine.Check.new(CheckTypeUrlWrong)
    refute CheckTypeUrlWrong.do_check(check).status
  end
end

defmodule CheckTypeUrlOk do
  import Medicine.Check
  use Medicine.CheckType.Url, url: "http://pipe.cypresslab.net"

  check "test check type url", 10
  description "test"
end

defmodule CheckTypeUrlWrong do
  import Medicine.Check
  use Medicine.CheckType.Url, url: "http://idonotexists.net"

  check "test check type url", 10
  description "test"
end
