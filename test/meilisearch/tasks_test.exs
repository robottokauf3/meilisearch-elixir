defmodule Meilisearch.TasksTest do
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Documents, Indexes, Tasks}

  @test_index Meilisearch.Config.get(:test_index)
  @another_index "another_test_index"
  @test_document %{
    id: 100,
    title: "The Thing",
    tagline: "Man is the warmest place to hide"
  }

  setup_all do
    Indexes.delete(@test_index)
    {:ok, task} = Indexes.create(@test_index)
    wait_for_task(task)
    {:ok, task} = Indexes.create(@another_index)
    wait_for_task(task)

    on_exit(fn ->
      Indexes.delete(@test_index)
      Indexes.delete(@another_index)
    end)

    :ok
  end

  describe "Tasks.get" do
    test "returns error, 404 with invalid task id" do
      {:error, status_code, message} = Tasks.get(10_071_982)

      assert status_code == 404
      assert is_binary(message)
    end

    test "returns task status" do
      {:ok, %{"taskUid" => task_uid}} = Documents.add_or_replace(@test_index, [@test_document])

      assert {:ok,
              %{
                "indexUid" => @test_index,
                "status" => _,
                "type" => _,
                "details" => %{},
                "duration" => _,
                "enqueuedAt" => _,
                "startedAt" => _,
                "finishedAt" => _
              }} = Tasks.get(task_uid)
    end
  end

  describe "Tasks.list" do
    test "returns list of tasks of one index" do
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

    test "returns list of tasks of multiple indexes" do
      Documents.add_or_replace(@test_index, [@test_document])
      Documents.add_or_replace(@another_index, [@test_document])

      {:ok, %{"results" => [task | [task2 | _]]}} = Tasks.list([@test_index, @another_index])

      assert %{
               "uid" => _,
               "indexUid" => @another_index,
               "status" => _,
               "type" => _,
               "details" => %{},
               "duration" => _,
               "enqueuedAt" => _,
               "startedAt" => _,
               "finishedAt" => _
             } = task

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
             } = task2
    end
  end
end
