defmodule Meilisearch.SystemTest do
  use ExUnit.Case

  alias Meilisearch.System

  test "System.info" do
    {:ok, info} = System.info()

    total_memory =
      info
      |> Map.get("global")
      |> Map.get("totalMemory")

    assert Map.has_key?(info, "memoryUsage")
    assert Map.has_key?(info, "processorUsage")
    assert Map.has_key?(info, "global")
    assert Map.has_key?(info, "process")
    assert is_number(total_memory)
  end

  test "System.info_pretty" do
    {:ok, info} = System.info_pretty()

    total_memory =
      info
      |> Map.get("global")
      |> Map.get("totalMemory")

    assert Map.has_key?(info, "memoryUsage")
    assert Map.has_key?(info, "processorUsage")
    assert Map.has_key?(info, "global")
    assert Map.has_key?(info, "process")
    assert is_binary(total_memory)
  end
end
