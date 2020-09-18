defmodule Meilisearch.DocumentTest do
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Document, Index}

  @test_index Application.get_env(:meilisearch, :test_index)
  @test_document %{
    id: 1,
    title: "Alien",
    tagline: "In space no one can hear you scream"
  }

  setup do
    Index.delete(@test_index)
    Index.create(@test_index)

    on_exit(fn ->
      Index.delete(@test_index)
    end)

    :timer.sleep(100)

    :ok
  end

  test "Document.add_or_replace" do
    {:ok, update} = Document.add_or_replace(@test_index, @test_document)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  test "Document.add_or_update" do
    {:ok, update} = Document.add_or_update(@test_index, @test_document)
    assert Map.has_key?(update, "updateId")

    wait_for_update(@test_index, Map.get(update, "updateId"))
  end

  describe "existing document" do
    setup do
      Document.add_or_replace(@test_index, @test_document)

      :timer.sleep(100)

      :ok
    end

    test "Document.get" do
      {:ok, document} = Document.get(@test_index, 1)
      assert Map.get(document, "id") == 1
      assert Map.get(document, "title") == "Alien"
      assert Map.get(document, "tagline") == "In space no one can hear you scream"
    end

    test "Document.list" do
      {:ok, [document | _]} = Document.list(@test_index)

      assert Map.get(document, "id") == 1
      assert Map.get(document, "title") == "Alien"
      assert Map.get(document, "tagline") == "In space no one can hear you scream"
    end
  end
end
