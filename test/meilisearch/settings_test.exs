defmodule Meilisearch.SettingsTest do
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Index, Settings}

  @test_index Application.get_env(:meilisearch, :test_index)
  @synonyms %{alien: ["ufo"]}
  @stop_words ["the", "of", "to"]
  @ranking_rules ["typo", "words", "proximity", "attribute"]
  @attributes_for_faceting ["title"]
  @distinct_attribute "id"
  @searchable_attributes ["title"]
  @displayed_attributes ["title"]

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
    {:ok, update} = Settings.update(@test_index, %{synonyms: @synonyms})
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.reset" do
    {:ok, update} = Settings.reset(@test_index)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.get_synonyms" do
    {:ok, synonyms} = Settings.get_synonyms(@test_index)
    assert synonyms == %{}
  end

  test "Settings.update_synonyms" do
    {:ok, update} = Settings.update_synonyms(@test_index, @synonyms)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.reset_synonyms" do
    {:ok, update} = Settings.reset_synonyms(@test_index)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.get_stop_words" do
    {:ok, stop_words} = Settings.get_stop_words(@test_index)
    assert stop_words == []
  end

  test "Settings.update_stop_words" do
    {:ok, update} = Settings.update_stop_words(@test_index, @stop_words)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.reset_stop_words" do
    {:ok, update} = Settings.reset_stop_words(@test_index)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.get_ranking_rules" do
    {:ok, ranking_rules} = Settings.get_ranking_rules(@test_index)

    assert ranking_rules == [
             "typo",
             "words",
             "proximity",
             "attribute",
             "wordsPosition",
             "exactness"
           ]
  end

  test "Settings.update_ranking_rules" do
    {:ok, update} = Settings.update_ranking_rules(@test_index, @ranking_rules)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.reset_ranking_rules" do
    {:ok, update} = Settings.reset_ranking_rules(@test_index)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.get_attributes_for_faceting" do
    {:ok, attributes_for_faceting} = Settings.get_attributes_for_faceting(@test_index)
    assert attributes_for_faceting == []
  end

  test "Settings.update_attributes_for_faceting" do
    {:ok, update} =
      Settings.update_attributes_for_faceting(
        @test_index,
        @attributes_for_faceting
      )

    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.reset_attributes_for_faceting" do
    {:ok, update} = Settings.reset_attributes_for_faceting(@test_index)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.get_distinct_attribute" do
    {:ok, distinct_attribute} = Settings.get_distinct_attribute(@test_index)
    assert distinct_attribute == nil
  end

  test "Settings.update_distinct_attribute" do
    {:ok, update} =
      Settings.update_distinct_attribute(
        @test_index,
        @distinct_attribute
      )

    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.reset_distinct_attribute" do
    {:ok, update} = Settings.reset_distinct_attribute(@test_index)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.get_searchable_attributes" do
    {:ok, searchable_attributes} = Settings.get_searchable_attributes(@test_index)
    assert searchable_attributes == ["*"]
  end

  test "Settings.update_searchable_attributes" do
    {:ok, update} =
      Settings.update_searchable_attributes(
        @test_index,
        @searchable_attributes
      )

    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.reset_searchable_attributes" do
    {:ok, update} = Settings.reset_searchable_attributes(@test_index)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.get_displayed_attributes" do
    {:ok, displayed_attributes} = Settings.get_displayed_attributes(@test_index)
    assert displayed_attributes == ["*"]
  end

  test "Settings.update_displayed_attributes" do
    {:ok, update} =
      Settings.update_displayed_attributes(
        @test_index,
        @displayed_attributes
      )

    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Settings.reset_displayed_attributes" do
    {:ok, update} = Settings.reset_displayed_attributes(@test_index)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end
end
