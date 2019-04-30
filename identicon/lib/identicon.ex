defmodule Identicon do
  @moduledoc """
    Contains methods for generating an identicon and saving it
  """

  @doc """
    Generates an identicon from a given seed
  """
  def generate_identicon(seed) do
    seed
    |> hash_string
    |> pick_color
  end

  def pick_color(image) do
    %Identicon.Image{hex: hex_list} = image
    [r, g, b | _tail] = hex_list

    [r, g, b]
  end

  @doc """
    Hashes a string using MD5 and returns an Identicon.Image
  """
  def hash_string(string) do
    hex = :crypto.hash(:md5, string)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
