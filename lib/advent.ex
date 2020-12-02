defmodule Day do
  @callback solve(arg :: [binary]) :: {integer | binary, integer | binary}
end

defmodule Advent do
  @moduledoc """
  Documentation for Advent.
  """

  defp tee(buffer, content) do
    # writes the content to stdio and also concats it to the buffer with a newline
    IO.puts(content)
    buffer <> content <> "\n"
  end

  @doc """
  Runs all days, printing the time to run (in microsecodns) and the outputs for
  part 1 and part 2 in a 2-tuple.
  """
  def all do
    # used for padding spaces
    format = fn x, leading -> x |> Integer.to_string() |> String.pad_leading(leading) end
    files = File.ls("lib/days") |> elem(1)
    initial_buffer = File.read!("README_template.md")
    # code formatting
    initial_buffer = initial_buffer <> "```\n"

    {total_runtime, buffer} =
      files
      |> Enum.sort()
      |> Enum.reduce({0, initial_buffer}, fn filename, {runtime, buffer} ->
        # pattern match on file name, only reading first two chars
        <<x, y>> <> _rest = filename
        # convert chars to int
        n = (x - ?0) * 10 + (y - ?0)
        # convert to 0-padded string
        nn = to_string([x, y])
        module = String.to_existing_atom("Elixir.D#{n}")
        input = "assets/inputs/#{nn}.txt" |> File.read!() |> String.trim() |> String.split("\n")
        {time, {result_1, result_2}} = :timer.tc(module, :solve, [input])

        buffer =
          tee(
            buffer,
            "Problem #{format.(n, 2)}: #{format.(time, 8)} μs (#{result_1}, #{result_2})"
          )

        {runtime + time, buffer}
      end)

    buffer =
      buffer
      |> tee("-------------------")
      |> tee("Total:  #{format.(total_runtime, 12)} μs")

    # code formatting
    buffer = buffer <> "```\n"

    File.write!("README.md", buffer)
  end

  def get(i) do
    path = "assets/inputs/#{if i < 10, do: "0" <> <<i + 48>>, else: <<i + 48>>}.txt"

    if File.exists?(path) do
      IO.puts("Already here!")
    else
      Application.ensure_all_started(:inets)
      Application.ensure_all_started(:ssl)
      url = 'https://adventofcode.com/2020/day/' ++ [i + 48] ++ '/input'
      cookie = 'session=' ++ to_charlist(System.get_env("ADVENT_COOKIE"))

      {:ok, {{_, 200, _}, _headers, body}} =
        :httpc.request(:get, {url, [{'cookie', cookie}]}, [], [])

      File.write!(path, to_string(body))
      IO.puts("Copied!")
    end
  end
end
