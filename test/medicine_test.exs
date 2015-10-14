defmodule MedicineTest do
  use ExUnit.Case
  doctest Medicine
  
  test "more truth" do
     assert 1 + 1 + 1 == 3
  end 

  test "the truth" do
    assert 1 + 1 == 2
  end
end
