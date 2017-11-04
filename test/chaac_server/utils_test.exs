defmodule ChaacServer.UtilsTest do
  use ChaacServer.DataCase

  alias ChaacServer.Utils

  @valid "elixir"
  
  test "generate_string/1 generates random string with given string" do
    assert Utils.generate_string(@valid) == "74b565"
  end

  test "generate_string/1 returns nil if nil is passed" do
    assert Utils.generate_string(nil) == nil
  end  
end