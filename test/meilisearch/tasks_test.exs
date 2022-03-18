defmodule Meilisearch.TasksTest do
  use ExUnit.Case
  import Meilisearch.Wait
  alias Meilisearch.{Documents, Indexes, Tasks}

  @test_index Meilisearch.Config.get(:test_index)
  @test_document %{
    id: 100,
    title: "The Thing",
    tagline: "Man is the warmest place to hide"
  }

  setup_all do
    Indexes.delete(@test_index) |> wait()
    Indexes.create(@test_index) |> wait()

    on_exit(fn ->
      Indexes.delete(@test_index) |> wait()
    end)

    :ok
  end

  describe "Tasks.get" do
    test "returns error, 404 with invalid update id" do
      {:error, status_code, message} = Tasks.get(@test_index, 10_071_982)

      assert status_code == 404
      assert is_binary(message)
    end

    test "returns update status" do
      {:ok, %{"uid" => uid}} = Documents.add_or_replace(@test_index, [@test_document])

      assert {:ok,
              %{
                "enqueuedAt" => _,
                "status" => _,
                "type" => _,
                "uid" => ^uid
              }} = Tasks.get(@test_index, uid)
    end
  end

  test "Tasks.list returns list of updates" do
    Documents.add_or_replace(@test_index, [@test_document])
    {:ok, %{"results" => [update | _]}} = Tasks.list(@test_index)

    assert %{
             "enqueuedAt" => _,
             "status" => _,
             "type" => _,
             "uid" => _
           } = update
  end
end
