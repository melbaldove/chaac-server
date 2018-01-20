defmodule ChaacServer.UtilsTest do
  use ChaacServer.DataCase

  alias ChaacServer.Utils

  @test_file "test/chaac_server/TestFile"  
  
  test "generate_string/0 generates pseudorandom string" do
    assert Utils.generate_string()
  end
  
  test "checksum/1 returns correct checksum for file" do
    checksum = Path.expand(@test_file)
    |> Utils.checksum
    assert checksum == "fa80ddf05dc43491d57573cc1b2ee010"
  end
end