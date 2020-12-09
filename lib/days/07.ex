defmodule D7 do
  @moduledoc """
  --- Day 7: Handy Haversacks ---
  You land at the regional airport in time for your next flight. In fact, it looks like you'll even have time to grab some food: all flights are currently delayed due to issues in luggage processing.

  Due to recent aviation regulations, many rules (your puzzle input) are being enforced about bags and their contents; bags must be color-coded and must contain specific quantities of other color-coded bags. Apparently, nobody responsible for these regulations considered how long they would take to enforce!

  How many bag colors can eventually contain at least one shiny gold bag? (The list of rules is quite long; make sure you get all of it.)

  --- Part Two ---
  It's getting pretty expensive to fly these days - not because of ticket prices, but because of the ridiculous number of bags you need to buy!

  Consider again your shiny gold bag and the rules from the above example:

  Of course, the actual rules have a small chance of going several levels deeper than this example; be sure to count all of the bags, even if the nesting becomes topologically impractical!

  How many individual bags are required inside your single shiny gold bag?
  """
  @behaviour Day

  @regex ~r/^(\d+) (\w+ \w+) bags?/

  def dfs(graph, node) do
    graph
    |> Graph.out_edges(node)
    |> Enum.map(fn %Graph.Edge{v2: out, weight: weight} ->
      weight + weight * dfs(graph, out)
    end)
    |> Enum.sum()
  end

  def solve(input) do
    input_map =
      input
      |> Enum.flat_map(fn line ->
        [key, value_strings] = String.split(line, " bags contain ")

        values =
          if value_strings == "no other bags." do
            []
          else
            value_strings
            |> String.split(", ")
            |> Enum.map(&Regex.run(@regex, &1, capture: :all_but_first))
          end

        edges =
          values
          |> Enum.map(fn [weight_string, to_key] ->
            {key, to_key, weight: Utils.to_int(weight_string)}
          end)

        edges
      end)

    graph = Graph.add_edges(Graph.new(), input_map)

    part_1 = graph |> Graph.reaching_neighbors(["shiny gold"]) |> length
    part_2 = dfs(graph, "shiny gold")
    {part_1, part_2}
  end
end
