defmodule Meilisearch.SettingsTest do
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Index, Settings}

  @test_index Application.get_env(:meilisearch, :test_index)

  setup_all do
    Index.delete(@test_index)
    Index.create(@test_index)

    on_exit(fn ->
      Index.delete(@test_index)
    end)

    :ok
  end

  test "Settings.get" do
    {:ok, settings} = Settings.get(@test_index)

    assert Map.has_key?(settings, "rankingRules")
    assert Map.has_key?(settings, "attributesForFaceting")
    assert Map.has_key?(settings, "displayedAttributes")
    assert Map.has_key?(settings, "distinctAttribute")
    assert Map.has_key?(settings, "searchableAttributes")
    assert Map.has_key?(settings, "stopWords")
    assert Map.has_key?(settings, "synonyms")
  end

  test "Settings.update" do
    {:ok, update} = Settings.update(@test_index, %{synonyms: %{alien: ["ufo"]}})
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.reset" do
    {:ok, update} = Settings.reset(@test_index)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end
end
