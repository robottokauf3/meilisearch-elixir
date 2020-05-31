defmodule Meilisearch.StatsTest do
  use ExUnit.Case

  alias Meilisearch.{Index, Stats}

  @test_index Application.get_env(:meilisearch, :test_index)

  setup do
    Index.delete(@test_index)

    :ok
  end

  test "get returns stats for given index" do
    Index.create(@test_index)

    assert {:ok, %{"fieldsFrequency" => _, "isIndexing" => _, "numberOfDocuments" => _}} =
             Stats.get(@test_index)
  end

  test "get_all returns stats for all indexes" do
    Index.create(@test_index)
    assert {:ok, %{"databaseSize" => _, "indexes" => %{@test_index => _}}} = Stats.get_all()
  end
end
