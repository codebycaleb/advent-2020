require Utils

defmodule D1 do
  @moduledoc """
  --- Day 1: Report Repair ---
  After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island. Surely, Christmas will go on without you.

  The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.

  To save your vacation, you need to get all fifty stars by December 25th.

  Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

  Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.

  Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

  Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?

  --- Part Two ---
  The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

  In your expense report, what is the product of the three entries that sum to 2020?
  """

  @behaviour Day

  defp find(input, against) do
    diffs = against |> Enum.map(&(2020 - &1)) |> MapSet.new
    matches = MapSet.intersection(input, diffs)
    Enum.reduce(matches, &(&1 * &2))
  end

  def solve(input) do
    input = input |> Utils.to_ints |> MapSet.new
    sums =  for i <- input, j <- input, i + j < 2020 and i != j, do: i + j

    part_1 = find(input, input)
    part_2 = find(input, sums)

    {
      part_1,
      part_2
    }
  end
end
