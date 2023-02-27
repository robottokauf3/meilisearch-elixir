defmodule Meilisearch.SettingsTest do
  @moduledoc false
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Indexes, Settings, Tasks}

  @test_index Meilisearch.Config.get(:test_index)
  @synonyms %{alien: ["ufo"]}
  @stop_words ["the", "of", "to"]
  @ranking_rules ["typo", "words", "proximity", "attribute"]
  @distinct_attribute "id"
  @searchable_attributes ["title"]
  @faceting_settings %{"maxValuesPerFacet" => 99}
  @pagination_settings %{"maxTotalHits" => 999}
  @typo_tolerance_settings %{
    "minWordSizeForTypos" => %{
      "oneTypo" => 5,
      "twoTypos" => 9
    }
  }
  @filterable_attributes ["title"]
  @sortable_attributes ["title"]
  @displayed_attributes ["title"]

  @default_type_tolerance_settings %{
    "disableOnAttributes" => [],
    "disableOnWords" => [],
    "enabled" => true,
    "minWordSizeForTypos" => %{"oneTypo" => 5, "twoTypos" => 9}
  }

  setup do
    Indexes.delete(@test_index)
    {:ok, task} = Indexes.create(@test_index)
    wait_for_task(task)

    on_exit(fn ->
      Indexes.delete(@test_index)
    end)

    :timer.sleep(100)

    :ok
  end

  test "Settings.get" do
    assert {:ok,
            %{
              "rankingRules" => _,
              "filterableAttributes" => _,
              "distinctAttribute" => _,
              "searchableAttributes" => _,
              "displayedAttributes" => _,
              "stopWords" => _,
              "synonyms" => _
            }} = Settings.get(@test_index)
  end

  test "Settings.update" do
    {:ok, task} = Settings.update(@test_index, %{synonyms: @synonyms})

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
  end

  test "Settings.reset" do
    {:ok, task} = Settings.reset(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
  end

  test "Settings.get_synonyms" do
    {:ok, synonyms} = Settings.get_synonyms(@test_index)
    assert synonyms == %{}
  end

  test "Settings.update_synonyms" do
    {:ok, task} = Settings.update_synonyms(@test_index, @synonyms)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
  end

  test "Settings.reset_synonyms" do
    {:ok, task} = Settings.reset_synonyms(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
  end

  test "Settings.get_stop_words" do
    {:ok, stop_words} = Settings.get_stop_words(@test_index)
    assert stop_words == []
  end

  test "Settings.update_stop_words" do
    {:ok, task} = Settings.update_stop_words(@test_index, @stop_words)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
  end

  test "Settings.reset_stop_words" do
    {:ok, task} = Settings.reset_stop_words(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
  end

  test "Settings.get_ranking_rules" do
    assert {:ok,
            [
              "words",
              "typo",
              "proximity",
              "attribute",
              "sort",
              "exactness"
            ]} = Settings.get_ranking_rules(@test_index)
  end

  test "Settings.update_ranking_rules" do
    assert wait_for_task_success(Settings.update_ranking_rules(@test_index, @ranking_rules))

    assert {:ok, @ranking_rules} = Settings.get_ranking_rules(@test_index)
  end

  test "Settings.reset_ranking_rules" do
    assert wait_for_task_success(Settings.reset_ranking_rules(@test_index))

    assert {:ok,
            [
              "words",
              "typo",
              "proximity",
              "attribute",
              "sort",
              "exactness"
            ]} = Settings.get_ranking_rules(@test_index)
  end

  test "Settings.get_distinct_attribute" do
    assert {:ok, nil} = Settings.get_distinct_attribute(@test_index)
  end

  test "Settings.update_distinct_attribute" do
    {:ok, task} =
      Settings.update_distinct_attribute(
        @test_index,
        @distinct_attribute
      )

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, "id"} = Settings.get_distinct_attribute(@test_index)
  end

  test "Settings.reset_distinct_attribute" do
    Settings.update_distinct_attribute(@test_index, @distinct_attribute)
    {:ok, task} = Settings.reset_distinct_attribute(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, nil} = Settings.get_distinct_attribute(@test_index)
  end

  test "Settings.get_searchable_attributes" do
    assert {:ok, ["*"]} = Settings.get_searchable_attributes(@test_index)
  end

  test "Settings.update_searchable_attributes" do
    {:ok, task} =
      Settings.update_searchable_attributes(
        @test_index,
        @searchable_attributes
      )

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, ["title"]} = Settings.get_searchable_attributes(@test_index)
  end

  test "Settings.reset_searchable_attributes" do
    {:ok, task} = Settings.reset_searchable_attributes(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, ["*"]} = Settings.get_searchable_attributes(@test_index)
  end

  test "Settings.get_displayed_attributes" do
    assert {:ok, ["*"]} = Settings.get_displayed_attributes(@test_index)
  end

  test "Settings.update_displayed_attributes" do
    {:ok, task} =
      Settings.update_displayed_attributes(
        @test_index,
        @displayed_attributes
      )

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, ["title"]} = Settings.get_displayed_attributes(@test_index)
  end

  test "Settings.reset_displayed_attributes" do
    Settings.update_displayed_attributes(@test_index, @displayed_attributes)
    {:ok, task} = Settings.reset_displayed_attributes(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, ["*"]} = Settings.get_displayed_attributes(@test_index)
  end

  test "Settings.get_sortable_attributes" do
    assert {:ok, []} = Settings.get_sortable_attributes(@test_index)
  end

  test "Settings.update_sortable_attributes" do
    {:ok, task} =
      Settings.update_sortable_attributes(
        @test_index,
        @sortable_attributes
      )

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, ["title"]} = Settings.get_sortable_attributes(@test_index)
  end

  test "Settings.reset_sortable_attributes" do
    Settings.update_sortable_attributes(@test_index, @sortable_attributes)
    {:ok, task} = Settings.reset_sortable_attributes(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, []} = Settings.get_sortable_attributes(@test_index)
  end

  test "Settings.get_faceting_settings" do
    assert {:ok, %{"maxValuesPerFacet" => 100}} = Settings.get_faceting_settings(@test_index)
  end

  test "Settings.update_faceting_settings" do
    {:ok, task} =
      Settings.update_faceting_settings(
        @test_index,
        @faceting_settings
      )

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, @faceting_settings} = Settings.get_faceting_settings(@test_index)
  end

  test "Settings.reset_faceting_settings" do
    wait_for_task(
      Settings.update_faceting_settings(
        @test_index,
        @faceting_settings
      )
    )

    {:ok, task} = Settings.reset_faceting_settings(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, %{"maxValuesPerFacet" => 100}} = Settings.get_faceting_settings(@test_index)
  end

  test "Settings.get_pagination_settings" do
    assert {:ok, %{"maxTotalHits" => 1000}} = Settings.get_pagination_settings(@test_index)
  end

  test "Settings.update_pagination_settings" do
    {:ok, task} =
      Settings.update_pagination_settings(
        @test_index,
        @pagination_settings
      )

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, @pagination_settings} = Settings.get_pagination_settings(@test_index)
  end

  test "Settings.reset_pagination_settings" do
    wait_for_task(
      Settings.update_pagination_settings(
        @test_index,
        @pagination_settings
      )
    )

    {:ok, task} = Settings.reset_pagination_settings(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, %{"maxTotalHits" => 1000}} = Settings.get_pagination_settings(@test_index)
  end

  test "Settings.get_filterable_attributes" do
    assert {:ok, []} = Settings.get_filterable_attributes(@test_index)
  end

  test "Settings.update_filterable_attributes" do
    {:ok, task} =
      Settings.update_filterable_attributes(
        @test_index,
        @filterable_attributes
      )

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, ["title"]} = Settings.get_filterable_attributes(@test_index)
  end

  test "Settings.reset_filterable_attributes" do
    {:ok, task} = Settings.reset_filterable_attributes(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, []} = Settings.get_filterable_attributes(@test_index)
  end

  test "Settings.get_typo_tolerance_settings" do
    assert {:ok, @default_type_tolerance_settings} =
             Settings.get_typo_tolerance_settings(@test_index)
  end

  test "Settings.update_typo_tolerance_settings" do
    {:ok, task} =
      Settings.update_typo_tolerance_settings(
        @test_index,
        @typo_tolerance_settings
      )

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))
    assert {:ok, @typo_tolerance_settings} = Settings.get_typo_tolerance_settings(@test_index)
  end

  test "Settings.reset_typo_tolerance_settings" do
    wait_for_task(
      Settings.update_typo_tolerance_settings(
        @test_index,
        @typo_tolerance_settings
      )
    )

    {:ok, task} = Settings.reset_typo_tolerance_settings(@test_index)

    wait_for_task(task)
    assert {:ok, %{"status" => "succeeded"}} = Tasks.get(Map.get(task, "taskUid"))

    assert {:ok, @default_type_tolerance_settings} =
             Settings.get_typo_tolerance_settings(@test_index)
  end
end
