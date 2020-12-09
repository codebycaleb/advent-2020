require Utils

defmodule D9 do
  @moduledoc """
  --- Day 9: Encoding Error ---
  With your neighbor happily enjoying their video game, you turn your attention to an open data port on the little screen in the seat in front of you.

  Though the port is non-standard, you manage to connect it to your computer through the clever use of several paperclips. Upon connection, the port outputs a series of numbers (your puzzle input).

  The data appears to be encrypted with the eXchange-Masking Addition System (XMAS) which, conveniently for you, is an old cypher with an important weakness.

  XMAS starts by transmitting a preamble of 25 numbers. After that, each number you receive should be the sum of any two of the 25 immediately previous numbers. The two numbers will have different values, and there might be more than one such pair.

  The first step of attacking the weakness in the XMAS data is to find the first number in the list (after the preamble) which is not the sum of two of the 25 numbers before it. What is the first number that does not have this property?

  --- Part Two ---
  The final step in breaking the XMAS encryption relies on the invalid number you just found: you must find a contiguous set of at least two numbers in your list which sum to the invalid number from step 1.

  Again consider the above example:

  To find the encryption weakness, add together the smallest and largest number in this contiguous range; in this example, these are 15 and 47, producing 62.
  """

  @behaviour Day

  defp find(sum, nums, target, [next | remaining] = list) do
    case sum + next do
      new_sum when new_sum < target ->
        find(new_sum, nums ++ [next], target, remaining)

      new_sum when new_sum == target ->
        nums = [next | nums]
        Enum.min(nums) + Enum.max(nums)

      _ ->
        [first | rest] = nums
        find(sum - first, rest, target, list)
    end
  end

  defp scan(sums, [_ | new_window], [next | remaining]) do
    if next in sums do
      {_, sums} = Enum.split(sums, 24)
      new_sums = for i <- new_window, do: i + next
      scan(sums ++ new_sums, new_window ++ [next], remaining)
    else
      next
    end
  end

  defp scan(preamble, remaining) do
    sums = for i <- preamble, j <- preamble, i != j, do: i + j
    scan(sums, preamble, remaining)
  end

  @impl true
  def solve(input) do
    input = input |> Utils.to_ints()
    {preamble, remaining} = Enum.split(input, 25)

    part_1 = scan(preamble, remaining)
    part_2 = find(0, [], part_1, input)

    {
      part_1,
      part_2
    }
  end
end
