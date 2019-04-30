defmodule Identicon do
  @moduledoc """
    Contains methods for generating an identicon and saving it
  """

  @doc """
    Generates an identicon from a given seed
  """
  def generate(seed) do
    seed
    |> hash_string
    |> pick_color
    |> build_grid
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    hex
    |> Enum.chunk_every(3, 3, :discard)
    |> Enum.map(&mirror_row/1)
  end

  @doc """

  """
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @doc """
    Adds the first three bytes as the RGB values to the Identicon.Image
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
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
