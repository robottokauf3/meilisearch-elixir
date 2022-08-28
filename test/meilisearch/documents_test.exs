defmodule Meilisearch.DocumentsTest do
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Documents, Indexes}

  @test_index Meilisearch.Config.get(:test_index)
  @test_document %{
    id: 1,
    title: "Alien",
    tagline: "In space no one can hear you scream"
  }

  setup do
    Indexes.delete(@test_index)
    Indexes.create(@test_index)

    on_exit(fn ->
      Indexes.delete(@test_index)
    end)

    :timer.sleep(100)

    :ok
  end

  test "Documents.add_or_replace" do
    {:ok, task} = Documents.add_or_replace(@test_index, @test_document)
    assert Map.has_key?(task, "taskUid")

    wait_for_update(Map.get(task, "taskUid"))
  end

  test "Documents.add_or_update" do
    {:ok, task} = Documents.add_or_update(@test_index, @test_document)
    assert Map.has_key?(task, "taskUid")

    wait_for_update(Map.get(task, "taskUid"))
  end

  describe "existing document" do
    setup do
      Documents.add_or_replace(@test_index, @test_document)

      :timer.sleep(100)

      :ok
    end

    test "Documents.get" do
      {:ok, document} = Documents.get(@test_index, 1)
      assert Map.get(document, "id") == 1
      assert Map.get(document, "title") == "Alien"
      assert Map.get(document, "tagline") == "In space no one can hear you scream"
    end

    test "Documents.list" do
      {:ok, %{ "results" => [document | _] }} = Documents.list(@test_index)

      assert Map.get(document, "id") == 1
      assert Map.get(document, "title") == "Alien"
      assert Map.get(document, "tagline") == "In space no one can hear you scream"
    end
  end
end
