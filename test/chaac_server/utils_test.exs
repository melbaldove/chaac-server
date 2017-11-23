defmodule ChaacServer.UtilsTest do
  use ChaacServer.DataCase

  alias ChaacServer.Utils

  @valid "elixir"
  @test_file "test/chaac_server/TestFile"  
  
  test "generate_string/1 generates random string with given string" do
    assert Utils.generate_string(@valid) == "74b565"
  end

  test "generate_string/1 returns nil if nil is passed" do
    assert Utils.generate_string(nil) == nil
  end
  
  test "checksum/1 returns correct checksum for file" do
    checksum = Path.expand(@test_file)
    |> Utils.checksum
    assert checksum == "fa80ddf05dc43491d57573cc1b2ee010"
  end
end