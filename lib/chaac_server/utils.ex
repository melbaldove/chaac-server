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
end