defmodule Meilisearch.SearchTest do
  use ExUnit.Case

  alias Meilisearch.{Documents, Indexes, Search, Settings}

  @test_index Meilisearch.Config.get(:test_index)
  @test_documents [
    %{
      id: 1,
      title: "Alien",
      tagline: "In space no one can hear you scream"
    },
    %{
      id: 2,
      title: "The Thing",
      tagline: "Man is the warmest place to hide"
    }
  ]

  setup do
    Indexes.delete(@test_index)
    Indexes.create(@test_index)
    Settings.update_filterable_attributes(@test_index, ["id"])
    Documents.add_or_replace(@test_index, @test_documents)

    on_exit(fn ->
      Indexes.delete(@test_index)
    end)

    :timer.sleep(100)

    :ok
  end

  describe "Search.search" do
    test "should return matching results" do
      {:ok, %{"hits" => [hit]}} = Search.search(@test_index, "warmest")

      assert Map.get(hit, "id") == 2
      assert Map.get(hit, "title") == "The Thing"
    end

    test "placeholder search should return matching results" do
      {:ok, %{"hits" => [hit]}} = Search.search(@test_index, nil, filter: "id = 1")

      assert Map.get(hit, "id") == 1
      assert Map.get(hit, "title") == "Alien"
    end
  end
end
