defmodule D8 do
  @moduledoc """
  --- Day 8: Handheld Halting ---
  Your flight to the major airline hub reaches cruising altitude without incident. While you consider checking the in-flight menu for one of those drinks that come with a little umbrella, you are interrupted by the kid sitting next to you.

  Their handheld game console won't turn on! They ask if you can take a look.

  You narrow the problem down to a strange infinite loop in the boot code (your puzzle input) of the device. You should be able to fix it, but first you need to be able to run the code in isolation.

  The boot code is represented as a text file with one instruction per line of text. Each instruction consists of an operation (acc, jmp, or nop) and an argument (a signed number like +4 or -20).

  acc increases or decreases a single global value called the accumulator by the value given in the argument. For example, acc +7 would increase the accumulator by 7. The accumulator starts at 0. After an acc instruction, the instruction immediately below it is executed next.
  jmp jumps to a new instruction relative to itself. The next instruction to execute is found using the argument as an offset from the jmp instruction; for example, jmp +2 would skip the next instruction, jmp +1 would continue to the instruction immediately below it, and jmp -20 would cause the instruction 20 lines above to be executed next.
  nop stands for No OPeration - it does nothing. The instruction immediately below it is executed next.

  Run your copy of the boot code. Immediately before any instruction is executed a second time, what value is in the accumulator

  --- Part Two ---
  After some careful analysis, you believe that exactly one instruction is corrupted.

  Somewhere in the program, either a jmp is supposed to be a nop, or a nop is supposed to be a jmp. (No acc instructions were harmed in the corruption of this boot code.)

  The program is supposed to terminate by attempting to execute an instruction immediately after the last instruction in the file. By changing exactly one jmp or nop, you can repair the boot code and make it terminate correctly.

  Fix the program so that it terminates normally by changing exactly one jmp (to nop) or nop (to jmp). What is the value of the accumulator after the program terminates?
  """
  @behaviour Day

  def execute(program, i, acc, visited) do
    if MapSet.member?(visited, i) do
      {:error, acc}
    else
      case Map.get(program, i, :end) do
        {:nop, _} -> execute(program, i + 1, acc, MapSet.put(visited, i))
        {:acc, x} -> execute(program, i + 1, acc + x, MapSet.put(visited, i))
        {:jmp, x} -> execute(program, i + x, acc, MapSet.put(visited, i))
        :end -> {:ok, acc}
      end
    end
  end

  def evaluate(program), do: execute(program, 0, 0, MapSet.new())

  def interpret(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {line, i} ->
      {instruction, relative_index} =
        case line do
          "nop " <> ri -> {:nop, ri}
          "jmp " <> ri -> {:jmp, ri}
          "acc " <> ri -> {:acc, ri}
        end

      {i, {instruction, Utils.to_int(relative_index)}}
    end)
    |> Map.new()
  end

  def solve(input) do
    program = interpret(input)

    {:error, part_1} = evaluate(program)

    part_2 =
      program
      |> Enum.flat_map(fn
        {_, {:acc, _}} -> []
        {_, {:nop, 0}} -> []
        {i, {:nop, ri}} -> [Map.put(program, i, {:jmp, ri})]
        {i, {:jmp, ri}} -> [Map.put(program, i, {:nop, ri})]
      end)
      |> Enum.find_value(fn p ->
        case evaluate(p) do
          {:error, _} -> false
          {:ok, acc} -> acc
        end
      end)

    {part_1, part_2}
  end
end
