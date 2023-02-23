defmodule Meilisearch.StatsTest do
  @moduledoc false
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Documents, Indexes, Stats}

  @test_index Meilisearch.Config.get(:test_index)

  setup do
    Indexes.delete(@test_index)
    wait_for_task(Indexes.create(@test_index))

    :ok
  end

  test "get returns stats for given index" do
    assert {:ok,
            %{
              "numberOfDocuments" => _,
              "isIndexing" => _,
              "fieldDistribution" => _
            }} = Stats.get(@test_index)
  end

  test "get_all returns stats for all indexes" do
    assert {:ok,
            %{
              "databaseSize" => _,
              "lastUpdate" => _,
              "indexes" => %{@test_index => _}
            }} = Stats.list()
  end
end
