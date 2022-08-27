defmodule Meilisearch.TasksTest do
  use ExUnit.Case
  alias Meilisearch.{Documents, Indexes, Tasks}

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

  describe "Tasks.get" do
    test "returns error, 404 with invalid update id" do
      {:error, status_code, message} = Tasks.get(10_071_982)

      assert status_code == 404
      assert is_binary(message)
    end

    test "returns update status" do
      {:ok, %{"taskUid" => task_id}} = Documents.add_or_replace(@test_index, [@test_document])

      assert {:ok,
              %{
                "enqueuedAt" => _,
                "status" => _,
                "type" => _,
                "uid" => _
              }} = Tasks.get(task_id)
    end
  end

  test "Tasks.list returns list of tasks" do
    Documents.add_or_replace(@test_index, [@test_document])
    {:ok, [update | _]} = Tasks.list(@test_index)

    assert %{
             "enqueuedAt" => _,
             "status" => _,
             "type" => _,
             "uid" => _
           } = update
  end
end
