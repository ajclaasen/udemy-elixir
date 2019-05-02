defmodule Identicon do
  @moduledoc """
    Contains methods for generating an identicon and saving it
  """

  @doc """
    Generates an identicon from a given `seed`
  """
    def generate(seed) do
    seed
    |> hash_string
    |> pick_color
    |> build_grid
    |> filter_even_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(seed)
  end

  @doc """
    Saves the `image` to the file system as the `filename`
  """
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  @doc """
    Draws an image out of the Identicon.Image using its `color` and `pixel_map` properties
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill_color = :egd.color(color)

    Enum.each(pixel_map, fn({top_left, bottom_right}) ->
      :egd.filledRectangle(image, top_left, bottom_right, fill_color)
    end)

    :egd.render(image)
  end

  @doc """
    Builds a pixel map out of a `grid`
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map(grid, fn({_number, index}) ->
      x = rem(index, 5) * 50
      y = div(index, 5) * 50

      top_left = {x, y}
      bottom_right = {x + 50, y + 50}

      {top_left, bottom_right}
    end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
    Returns an Identicon.Image with only the indices that have an even number
  """
  def filter_even_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn({number, _index}) ->
      rem(number, 2) == 0
    end)

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Builds a list of 25 tuples containing a number and its digit representing the grid of the identicon.
    Mirrors the numbers along the vertical axis.
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Appends the first two elements of the `row` to the end of the `row`, but mirrored.
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
    Hashes a `string` using MD5 and returns an Identicon.Image
  """
  def hash_string(string) do
    hex = :crypto.hash(:md5, string)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
