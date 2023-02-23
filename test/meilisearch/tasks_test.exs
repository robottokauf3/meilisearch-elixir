defmodule Meilisearch.TasksTest do
  @moduledoc false
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.{Documents, Indexes, Tasks}

  @test_index Meilisearch.Config.get(:test_index)
  @test_document %{
    id: 100,
    title: "The Thing",
    tagline: "Man is the warmest place to hide"
  }
  @test_document2 %{
    id: 101,
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
    setup do
      {:ok, task} = Documents.add_or_replace(@test_index, [@test_document])
      {:ok, task2} = Documents.add_or_replace(@test_index, [@test_document2])
      wait_for_task(task2)
      {:ok, task: task, task2: task2}
    end

    test "returns list of tasks of given index" do
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

    test "returns list of tasks of given index with pagination", %{task: task} do
      {:ok,
       %{
         "from" => _,
         "limit" => 1,
         "results" => [found_task | _]
       }} = Tasks.list(@test_index, limit: 1, from: Map.get(task, "taskUid"))

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
             } = found_task
    end

    test "returns list of tasks of all indices with pagination", %{task: task} do
      {:ok,
       %{
         "from" => _,
         "limit" => 1,
         "results" => [found_task | _]
       }} = Tasks.list(limit: 1, from: Map.get(task, "taskUid"))

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
             } = found_task
    end
  end

  describe "Tasks.cancel" do
    setup do
      {:ok, task} = Documents.add_or_replace(@test_index, [@test_document])
      {:ok, task: task}
    end

    test "cancels the task using uid", %{task: task} do
      {:ok,
       %{
         "enqueuedAt" => _,
         "indexUid" => nil,
         "status" => "enqueued",
         "taskUid" => _,
         "type" => "taskCancelation"
       }} = Tasks.cancel(Map.get(task, "taskUid"))
    end

    test "cancels all tasks using filter" do
      {:ok,
       %{
         "enqueuedAt" => _,
         "indexUid" => nil,
         "status" => "enqueued",
         "taskUid" => _,
         "type" => "taskCancelation"
       }} = Tasks.cancel(types: "documentAdditionOrUpdate,documentDeletion")
    end
  end

  describe "Tasks.delete" do
    setup do
      {:ok, task} = Documents.add_or_replace(@test_index, [@test_document])
      wait_for_task(task)

      {:ok, task: task}
    end

    test "deletes the task using uid", %{task: task} do
      {:ok,
       %{
         "enqueuedAt" => _,
         "indexUid" => nil,
         "status" => "enqueued",
         "taskUid" => _,
         "type" => "taskDeletion"
       }} = Tasks.delete(Map.get(task, "taskUid"))
    end

    test "deletes all tasks using filter" do
      {:ok,
       %{
         "enqueuedAt" => _,
         "indexUid" => nil,
         "status" => "enqueued",
         "taskUid" => _,
         "type" => "taskDeletion"
       }} = Tasks.delete(indexUids: "some_index")
    end
  end
end
