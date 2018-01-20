defmodule ChaacServer.Utils do
  @moduledoc """
  ChaacServer generic utilities
  """
  
  @doc """
  Returns a pseudo random `string`

  ## Examples

      iex> generate_string()
  """
  def generate_string() do
    import Enum
    :crypto.hash(:sha256, :os.system_time(:millisecond) |> Integer.to_charlist)
    |> Base.encode16
    |> String.codepoints
    |> join
    |> String.downcase
  end

  def checksum(nil), do: {:error, "path required"}
  def checksum(""), do: checksum(nil)
  def checksum(file) do
    checksum = File.stream!(file,[],2048) 
    |> Enum.reduce(:crypto.hash_init(:md5), fn(line, acc) -> :crypto.hash_update(acc,line) end ) 
    |> :crypto.hash_final 
    |> Base.encode16 
    |> String.downcase
  end
end