defmodule Meilisearch.StatsTest do
  use ExUnit.Case

  alias Meilisearch.{Indexes, Stats}

  @test_index Application.get_env(:meilisearch, :test_index)

  setup do
    Indexes.delete(@test_index)

    :ok
  end

  test "get returns stats for given index" do
    Indexes.create(@test_index)

    assert {:ok, %{"fieldsDistribution" => _, "isIndexing" => _, "numberOfDocuments" => _}} =
             Stats.get(@test_index)
  end

  test "get_all returns stats for all indexes" do
    Indexes.create(@test_index)
    assert {:ok, %{"databaseSize" => _, "indexes" => %{@test_index => _}}} = Stats.list()
  end
end
