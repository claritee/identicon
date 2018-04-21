defmodule Identicon do

  @moduledoc """
    Udemy course on Elixir and Phoenix

    Draw an identicon and save this to a PNG

  ## Examples

    iex> Identicon.main("asdf")
      %Identicon.Image{color: {145, 46, 200},
       grid: [{145, 0}, {46, 1}, {200, 2}, {46, 3}, {145, 4}, {3, 5}, {178, 6},
        {206, 7}, {178, 8}, {3, 9}, {73, 10}, {228, 11}, {165, 12}, {228, 13},
        {73, 14}, {65, 15}, {6, 16}, {141, 17}, {6, 18}, {65, 19}, {73, 20}, {90, 21},
        {181, 22}, {90, 23}, {73, 24}],
       hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112],
       pixel_map: [{{0, 0}, {50, 50}}, {{50, 0}, {100, 50}}, {{100, 0}, {150, 50}},
        {{150, 0}, {200, 50}}, {{200, 0}, {250, 50}}, {{0, 50}, {50, 100}},
        {{50, 50}, {100, 100}}, {{100, 50}, {150, 100}}, {{150, 50}, {200, 100}},
        {{200, 50}, {250, 100}}, {{0, 100}, {50, 150}}, {{50, 100}, {100, 150}},
        {{100, 100}, {150, 150}}, {{150, 100}, {200, 150}}, {{200, 100}, {250, 150}},
        {{0, 150}, {50, 200}}, {{50, 150}, {100, 200}}, {{100, 150}, {150, 200}},
        {{150, 150}, {200, 200}}, {{200, 150}, {250, 200}}, {{0, 200}, {50, 250}},
        {{50, 200}, {100, 250}}, {{100, 200}, {150, 250}}, {{150, 200}, {200, 250}},
        {{200, 200}, {250, 250}}]}
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = 
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end
    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]  
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
