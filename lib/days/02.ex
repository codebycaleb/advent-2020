defmodule D2 do
  @moduledoc """
  --- Day 2: Password Philosophy ---
  Your flight departs in a few days from the coastal airport; the easiest way down to the coast from here is via toboggan.

  The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's wrong with our computers; we can't log in!" You ask if you can take a look.

  Their password database seems to be a little corrupted: some of the passwords wouldn't have been allowed by the Official Toboggan Corporate Policy that was in effect when they were chosen.

  To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and the corporate policy when that password was set.


  How many passwords are valid according to their policies?
  --- Part Two ---
  While it appears you validated the passwords correctly, they don't seem to be what the Official Toboggan Corporate Authentication System is expecting.

  The shopkeeper suddenly realizes that he just accidentally explained the password policy rules from his old job at the sled rental place down the street! The Official Toboggan Corporate Policy actually works a little differently.

  Each policy actually describes two positions in the password, where 1 means the first character, 2 means the second character, and so on. (Be careful; Toboggan Corporate Policies have no concept of "index zero"!) Exactly one of these positions must contain the given letter. Other occurrences of the letter are irrelevant for the purposes of policy enforcement.

  How many passwords are valid according to the new interpretation of the policies?
  """
  @behaviour Day

  @regex ~r/(\d+)-(\d+) ([a-z]): ([a-z]+)/

  @impl true
  def solve(input) do
    input = input
    |> Utils.to_strings()
    |> Enum.map(&Regex.run(@regex, &1, capture: :all_but_first))
    |> Enum.map(fn [min, max, char, pass] ->
      min = Utils.to_int(min)
      max = Utils.to_int(max)
      <<char>> = char
      pass = to_charlist(pass)
      [min, max, char, pass]
    end)

    part_1 = Enum.count(input, fn [min, max, char, pass] ->
      count = Enum.count(pass, &(&1 == char))
      min <= count and count <= max
    end)

    part_2 = Enum.count(input, fn [first, second, char, pass] ->
      p = Enum.at(pass, first - 1) == char
      q = Enum.at(pass, second - 1) == char
      (p or q) and !(p and q)
    end)
    
    {part_1, part_2}
  end
end
