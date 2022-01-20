defmodule Meilisearch.TasksTest do
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Documents, Indexes, Tasks}

  @test_index Meilisearch.Config.get(:test_index)
  @test_document %{
    id: 100,
    title: "The Thing",
    tagline: "Man is the warmest place to hide"
  }

  setup_all do
    Indexes.delete(@test_index)
    {:ok, task} = Indexes.create(@test_index)
    wait_for_task(task)

    on_exit(fn ->
      Indexes.delete(@test_index)
    end)

    :ok
  end

  describe "Tasks.get" do
    test "returns error, 404 with invalid task id" do
      {:error, status_code, message} = Tasks.get(@test_index, 10_071_982)

      assert status_code == 404
      assert is_binary(message)
    end

    test "returns task status" do
      {:ok, %{"uid" => task_id}} = Documents.add_or_replace(@test_index, [@test_document])

      assert {:ok,
              %{
                "uid" => _,
                "indexUid" => @test_index,
                "status" => _,
                "type" => _,
                "details" => %{},
                "duration" => _,
                "enqueuedAt" => _,
                "startedAt" => _,
                "finishedAt" => _
              }} = Tasks.get(@test_index, task_id)
    end
  end

  test "Tasks.list returns list of tasks" do
    Documents.add_or_replace(@test_index, [@test_document])
    {:ok, %{"results" => [task | _]}} = Tasks.list(@test_index)

    assert %{
             "uid" => _,
             "indexUid" => @test_index,
             "status" => _,
             "type" => _,
             "details" => %{},
             "duration" => _,
             "enqueuedAt" => _,
             "startedAt" => _,
             "finishedAt" => _
           } = task
  end
end
