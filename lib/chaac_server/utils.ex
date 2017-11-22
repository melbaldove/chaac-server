defmodule ChaacServer.Utils do
  @moduledoc """
  ChaacServer generic utilities
  """
  
  @doc """
  Returns a random `string` from string 

  ## Examples

      iex> generate_string("elixir")
  """
  def generate_string(nil) do end
  def generate_string(string) do
    import Enum
    :crypto.hash(:md5, string)
    |> Base.encode16
    |> String.codepoints
    |> take(6)
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