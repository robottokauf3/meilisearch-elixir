defmodule Meilisearch.UpdatesTest do
  use ExUnit.Case
  alias Meilisearch.{Documents, Indexes, Updates}

  @test_index Meilisearch.Config.get(:test_index)
  @test_document %{
    id: 100,
    title: "The Thing",
    tagline: "Man is the warmest place to hide"
  }

  setup_all do
    Indexes.delete(@test_index)
    Indexes.create(@test_index)

    on_exit(fn ->
      Indexes.delete(@test_index)
    end)

    :ok
  end

  describe "Updates.get" do
    test "returns error, 404 with invalid update id" do
      {:error, status_code, message} = Updates.get(@test_index, 10_071_982)

      assert status_code == 404
      assert is_binary(message)
    end

    test "returns update status" do
      {:ok, %{"updateId" => update_id}} = Documents.add_or_replace(@test_index, [@test_document])

      assert {:ok,
              %{
                "enqueuedAt" => _,
                "status" => _,
                "type" => _,
                "updateId" => _
              }} = Updates.get(@test_index, update_id)
    end
  end

  test "Updates.list returns list of updates" do
    Documents.add_or_replace(@test_index, [@test_document])
    {:ok, [update | _]} = Updates.list(@test_index)

    assert %{
             "enqueuedAt" => _,
             "status" => _,
             "type" => _,
             "updateId" => _
           } = update
  end
end
