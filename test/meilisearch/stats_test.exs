defmodule Meilisearch.StatsTest do
  use ExUnit.Case
  import Meilisearch.Wait

  alias Meilisearch.{Indexes, Stats}

  @test_index Meilisearch.Config.get(:test_index)

  setup do
    Indexes.delete(@test_index) |> wait()

    :ok
  end

  test "get returns stats for given index" do
    Indexes.create(@test_index) |> wait()

    assert {:ok, %{"fieldDistribution" => _, "isIndexing" => _, "numberOfDocuments" => _}} =
             Stats.get(@test_index)
  end

  test "get_all returns stats for all indexes" do
    Indexes.create(@test_index) |> wait()
    assert {:ok, %{"databaseSize" => _, "indexes" => %{@test_index => _}}} = Stats.list()
  end
end
