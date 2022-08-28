defmodule Meilisearch.StatsTest do
  use ExUnit.Case
  import Support.Helpers, only: [{:create_index, 1}]

  alias Meilisearch.{Indexes, Stats}

  @test_index Meilisearch.Config.get(:test_index)

  setup do
    Indexes.delete(@test_index)

    :ok
  end

  test "get returns stats for given index" do
    create_index(@test_index)

    assert {:ok, %{"fieldDistribution" => _, "isIndexing" => _, "numberOfDocuments" => _}} =
             Stats.get(@test_index)
  end

  test "get_all returns stats for all indexes" do
    create_index(@test_index)

    assert {:ok, %{"databaseSize" => _, "indexes" => %{@test_index => _}}} = Stats.list()
  end
end
