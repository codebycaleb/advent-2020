defmodule D4 do
  @moduledoc """
  --- Day 4: Passport Processing ---
  You arrive at the airport only to realize that you grabbed your North Pole Credentials instead of your passport. While these documents are extremely similar, North Pole Credentials aren't issued by a country and therefore aren't actually valid documentation for travel in most of the world.

  It seems like you're not the only one having problems, though; a very long line has formed for the automatic passport scanners, and the delay could upset your travel itinerary.

  Due to some questionable network security, you realize you might be able to solve both of these problems at the same time.

  The automatic passport scanners are slow because they're having trouble detecting which passports have all required fields. The expected fields are as follows:

  byr (Birth Year)
  iyr (Issue Year)
  eyr (Expiration Year)
  hgt (Height)
  hcl (Hair Color)
  ecl (Eye Color)
  pid (Passport ID)
  cid (Country ID)
  Passport data is validated in batch files (your puzzle input). Each passport is represented as a sequence of key:value pairs separated by spaces or newlines. Passports are separated by blank lines.

  Count the number of valid passports - those that have all required fields. Treat cid as optional. In your batch file, how many passports are valid?

  --- Part Two ---
  The line is moving more quickly now, but you overhear airport security talking about how passports with invalid data are getting through. Better add some data validation, quick!

  You can continue to ignore the cid field, but each other field has strict rules about what values are valid for automatic validation:

  byr (Birth Year) - four digits; at least 1920 and at most 2002.
  iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  hgt (Height) - a number followed by either cm or in:
  If cm, the number must be at least 150 and at most 193.
  If in, the number must be at least 59 and at most 76.
  hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  pid (Passport ID) - a nine-digit number, including leading zeroes.
  cid (Country ID) - ignored, missing or not.
  Your job is to count the passports where all required fields are both present and valid according to the above rules. Here are some example values:

  Count the number of valid passports - those that have all required fields and valid values. Continue to treat cid as optional. In your batch file, how many passports are valid?
  """
  @behaviour Day

  @required MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])

  defp initial_pass(input) do
    input
    |> Enum.join("\n")
    |> String.split("\n\n")
    |> Enum.map(fn pass ->
      kvs = String.split(pass)

      if length(kvs) < 7 do
        nil
      else
        map =
          kvs
          |> Enum.map(&String.split(&1, ":"))
          |> Map.new(fn [a, b] -> {a, b} end)

        if MapSet.subset?(@required, MapSet.new(Map.keys(map))), do: map, else: nil
      end
    end)
    |> Enum.filter(& &1)
  end

  defp digits(x, 4), do: Regex.match?(~r/^\d{4}$/, x)
  defp digits(x, 9), do: Regex.match?(~r/^\d{9}$/, x)

  defp btwn(x, min, max) do
    x = Utils.to_int(x)
    min <= x and x <= max
  end

  defp hgt_fmt(x), do: Regex.match?(~r/^(\d{3}cm)|^(\d{2}in)$/, x)
  defp hgt_bnd([x, "cm"]), do: btwn(x, 150, 193)
  defp hgt_bnd([x, "in"]), do: btwn(x, 59, 76)
  defp hgt_bnd(x), do: hgt_bnd(Regex.run(~r/(\d+)(\w+)/, x, capture: :all_but_first))
  defp hex(x), do: Regex.match?(~r/^#[a-f0-9]{6}$/, x)
  defp ecl(x), do: x in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

  defp second_pass(passports) do
    requirements = [
      {"byr", &digits(&1, 4)},
      {"iyr", &digits(&1, 4)},
      {"eyr", &digits(&1, 4)},
      {"pid", &digits(&1, 9)},
      {"byr", &btwn(&1, 1920, 2002)},
      {"iyr", &btwn(&1, 2010, 2020)},
      {"eyr", &btwn(&1, 2020, 2030)},
      {"hgt", &hgt_fmt/1},
      {"hgt", &hgt_bnd/1},
      {"hcl", &hex/1},
      {"ecl", &ecl/1}
    ]

    passports
    |> Enum.filter(fn passport ->
      Enum.all?(requirements, fn {prop, fun} ->
        apply(fun, [passport[prop]])
      end)
    end)
  end

  @impl true
  def solve(input) do
    passports = initial_pass(input)

    part_1 = Enum.count(passports)

    part_2 =
      passports
      |> second_pass
      |> Enum.count()

    {part_1, part_2}
  end
end
