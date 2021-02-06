defmodule Meilisearch.DocumentsTest do
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Documents, Indexes}

  @test_index Application.get_env(:meilisearch, :test_index)
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
    {:ok, update} = Documents.add_or_replace(@test_index, @test_document)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Documents.add_or_update" do
    {:ok, update} = Documents.add_or_update(@test_index, @test_document)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
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
      {:ok, [document | _]} = Documents.list(@test_index)

      assert Map.get(document, "id") == 1
      assert Map.get(document, "title") == "Alien"
      assert Map.get(document, "tagline") == "In space no one can hear you scream"
    end
  end
end
