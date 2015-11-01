defmodule Medicine.CheckTest do
  use ExUnit.Case

  test "intance struct and check macro" do
    check = Medicine.Check.new(TestCheck)
    assert check.name == "test_check"
    assert check.frequency == 10
    assert check.description == "test check description"
  end
end

defmodule TestCheck do
  import Medicine.Check

  check "test_check", 10
  description "test check description"

  def do_check(check), do: true
end
