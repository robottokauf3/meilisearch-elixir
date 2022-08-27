defmodule Meilisearch.IndexTest do
  use ExUnit.Case
  alias Meilisearch.{Indexes, Tasks}
  import Support.Helpers, only: [{:wait_for_update, 1}, {:create_index, 1}]

  @test_index Meilisearch.Config.get(:test_index)

  setup do
    Indexes.delete(@test_index)

    :ok
  end

  describe "Indexes.list" do
    test "returns an empty list if no indexes exist" do
      assert {:ok, []} = Indexes.list()
    end

    test "returns list of existing indexes" do
      create_index(@test_index)

      assert {:ok, [index]} = Indexes.list()
      assert %{"createdAt" => _, "updatedAt" => _, "uid" => @test_index, "primaryKey" => nil} = index
    end
  end

  describe "Indexes.get" do
    test "returns index details" do
      create_index(@test_index)

      assert {:ok, index} = Indexes.get(@test_index)
      assert %{"uid" => @test_index, "primaryKey" => nil} = index
    end

    test "returns an error if index does not exist" do
      assert {:error, 404, _} = Indexes.get(@test_index)
    end
  end

  describe "Indexes.create" do
    test "creates a new index" do
      assert {:ok, %{ "taskUid" => update_id }} = Indexes.create(@test_index)
    
      wait_for_update(update_id)

      assert {:ok, index} = Indexes.get(@test_index)
      assert %{"uid" => @test_index, "primaryKey" => nil} = index
    end

    test "returns an error when given duplicate index uid" do
      create_index(@test_index)

      {:ok, %{ "taskUid" => update_id }} = Indexes.create(@test_index)

      assert {:ok, %{ "error" => %{ "code" => "index_already_exists" }}} = Tasks.get(update_id)
    end

    test "create new index with primary key if given" do
      assert {:ok, %{ "taskUid" => update_id }} = Indexes.create(@test_index, primary_key: "test_key")
    
      wait_for_update(update_id)

      assert {:ok, index} = Indexes.get(@test_index)
      assert %{"uid" => @test_index, "primaryKey" => "test_key"} = index
    end
  end

  describe "Indexes.update" do
    test "Tasks primary key" do
      create_index(@test_index)

      {:ok, %{ "taskUid" => update_id }} = Indexes.update(@test_index, primary_key: "new_primary_key")
      wait_for_update(update_id)

      assert {:ok, %{"primaryKey" => "new_primary_key"}} = Indexes.get(@test_index)
    end

    test "returns error if not given primary key" do
      create_index(@test_index)

      assert {:error, "primary_key is required"} = Indexes.update(@test_index)
    end

    @tag :skip
    test "returns error if primary key is already set" do
      create_index(@test_index)

      {:ok, %{ "taskUid" => update_id }} = Indexes.update(@test_index, primary_key: "new_primary_key")
      wait_for_update(update_id)

      {:ok, %{ "taskUid" => update_id }} = Indexes.update(@test_index, primary_key: "another_primary_key")
      assert {:ok, %{ "status" => "failed" }} = wait_for_update(update_id)

      # assert {:error, 400, _} = Indexes.update(@test_index, primary_key: "another_primary_key")
    end
  end

  describe "Indexes.delete" do
    test "deletes index and returns details" do
      create_index(@test_index)

      assert {:ok, %{ "taskUid" => update_id, "status" => "enqueued", "type" => "indexDeletion" }} = Indexes.delete(@test_index)
      wait_for_update(update_id)
      assert {:ok, false} = Indexes.exists?(@test_index)
    end

    test "results in an error if index does not exist" do
      assert {:ok, %{ "status" => "enqueued", "taskUid" => update_id }} = Indexes.delete(@test_index)

      assert {:ok, %{ "error" => %{ "code" => "index_not_found" }}} = Tasks.get(update_id)
    end
  end

  describe "Indexes.exists?" do
    test "returns false if index does not exist" do
      assert {:ok, false} = Indexes.exists?(@test_index)
    end

    test "returns true if index exists" do
      create_index(@test_index)

      assert {:ok, true} = Indexes.exists?(@test_index)
    end
  end
end
