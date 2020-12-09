defmodule Pass do
  defstruct [:row, :col, :id]

  def new(row, col) do
    %Pass{row: row, col: col, id: row * 8 + col}
  end

  def compare(p1, p2) do
    cond do
      p1.id < p2.id -> :lt
      p1.id > p2.id -> :gt
      true -> :eq
    end
  end
end

defmodule D5 do
  @moduledoc """
  --- Day 5: Binary Boarding ---
  You board your plane only to discover a new problem: you dropped your boarding pass! You aren't sure which seat is yours, and all of the flight attendants are busy with the flood of people that suddenly made it through passport control.

  You write a quick program to use your phone's camera to scan all of the nearby boarding passes (your puzzle input); perhaps you can find your seat through process of elimination.

  Instead of zones or groups, this airline uses binary space partitioning to seat people. A seat might be specified like FBFBBFFRLR, where F means "front", B means "back", L means "left", and R means "right".

  The first 7 characters will either be F or B; these specify exactly one of the 128 rows on the plane (numbered 0 through 127). Each letter tells you which half of a region the given seat is in. Start with the whole list of rows; the first letter indicates whether the seat is in the front (0 through 63) or the back (64 through 127). The next letter indicates which half of that region the seat is in, and so on until you're left with exactly one row.

  Every seat also has a unique seat ID: multiply the row by 8, then add the column. In this example, the seat has ID 44 * 8 + 5 = 357.

  As a sanity check, look through your list of boarding passes. What is the highest seat ID on a boarding pass?

  --- Part Two ---
  Ding! The "fasten seat belt" signs have turned on. Time to find your seat.

  It's a completely full flight, so your seat should be the only missing boarding pass in your list. However, there's a catch: some of the seats at the very front and back of the plane don't exist on this aircraft, so they'll be missing from your list as well.

  Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.

  What is the ID of your seat?
  """
  @behaviour Day

  defp to_int(list) do
    list
    |> Enum.map(fn
      ?B -> 1
      ?F -> 0
      ?L -> 0
      ?R -> 1
    end)
    |> Integer.undigits(2)
  end

  defp interpret_passes(input) do
    input
    |> Enum.map(fn pass ->
      <<row_string::binary-size(7), col_string::binary-size(3)>> = pass
      row = to_charlist(row_string)
      col = to_charlist(col_string)
      Pass.new(to_int(row), to_int(col))
    end)
  end

  defp find_pass(last, [pass | passes]) do
    if last.id - pass.id != 1, do: last.id - 1, else: find_pass(pass, passes)
  end

  defp find_pass(passes), do: find_pass(hd(passes), tl(passes))

  @impl true
  def solve(input) do
    passes =
      input
      |> interpret_passes
      |> Enum.sort({:desc, Pass})

    part_1 = hd(passes).id

    part_2 = find_pass(passes)

    {part_1, part_2}
  end
end
