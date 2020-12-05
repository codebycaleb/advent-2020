use Bitwise

defmodule D3 do
  @moduledoc """
  --- Day 3: Toboggan Trajectory ---
  With the toboggan login problems resolved, you set off toward the airport. While travel by toboggan might be easy, it's certainly not safe: there's very minimal steering and the area is covered in trees. You'll need to see which angles will take you near the fewest trees.

  Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

  These aren't the only trees, though; due to something you read about once involving arboreal genetics and biome stability, the same pattern repeats to the right many times:

  The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

  From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

  The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:

  Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?

  --- Part Two ---
  Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

  Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

  What do you get if you multiply together the number of trees encountered on each of the listed slopes?
  """
  @behaviour Day

  defp bin_at(bin, at) do
    mask = 1 <<< at
    mask == (bin &&& mask)
  end

  @impl true
  def solve(input) do
    input = input |> Utils.to_strings()
    lines = Enum.count(input)
    line_length = input |> List.first() |> String.length()
    total_length = lines * line_length
    joined = Enum.join(input, "")

    bin =
      joined
      |> to_charlist
      |> Enum.reverse()
      |> Enum.reduce(0, fn
        ?., acc -> acc <<< 1
        ?#, acc -> acc <<< 1 ||| 1
      end)

    tree_count = fn right, down ->
      0..div(lines - 1, down)
      |> Enum.map(fn i ->
        index = rem(i * line_length * down + rem(i * right, line_length), total_length)
        bin_at(bin, index)
      end)
      |> Enum.count(& &1)
    end

    part_1 = tree_count.(3, 1)

    part_2 =
      [
        [1, 1],
        [5, 1],
        [7, 1],
        [1, 2]
      ]
      |> Enum.map(fn [right, down] -> tree_count.(right, down) end)
      |> Enum.reduce(part_1, &(&1 * &2))

    {part_1, part_2}
  end
end
