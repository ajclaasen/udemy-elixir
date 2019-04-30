defmodule Identicon do
  @moduledoc """
    Contains methods for generating an identicon and saving it.
  """

  @doc """
    Generates an identicon from a given seed.
  """
  def generate_identicon(seed) do
    seed
    |> hash_string
  end

  @doc """
    Generates a list of 16 bytes by hashing a string using MD5.
  """
  def hash_string(string) do
    :crypto.hash(:md5, string)
    |> :binary.bin_to_list
  end
end
