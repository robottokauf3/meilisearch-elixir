defmodule Meilisearch.DocumentsTest do
  @moduledoc false
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
    wait_for_task(Indexes.create(@test_index))

    on_exit(fn ->
      Indexes.delete(@test_index)
    end)

    :ok
  end

  test "Documents.add_or_replace" do
    assert wait_for_task_success(Documents.add_or_replace(@test_index, @test_document))
    assert {:ok, %{"id" => 1}} = Documents.get(@test_index, @test_document.id)
  end

  test "Documents.add_or_update" do
    assert wait_for_task_success(Documents.add_or_update(@test_index, @test_document))
    assert {:ok, %{"id" => 1}} = Documents.get(@test_index, @test_document.id)
  end

  describe "existing document" do
    setup do
      wait_for_task(Documents.add_or_replace(@test_index, @test_document))

      :ok
    end

    test "Documents.get" do
      {:ok, document} = Documents.get(@test_index, 1)

      assert Map.get(document, "id") == 1
      assert Map.get(document, "title") == "Alien"
      assert Map.get(document, "tagline") == "In space no one can hear you scream"
    end

    test "Documents.list" do
      {:ok, response} = Documents.list(@test_index)
      %{"limit" => 20, "offset" => 0, "results" => [document | _], "total" => 1} = response

      assert Map.get(document, "id") == 1
      assert Map.get(document, "title") == "Alien"
      assert Map.get(document, "tagline") == "In space no one can hear you scream"
    end
  end
end
