defmodule Meilisearch.IndexTest do
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
    wait_for_task(Indexes.delete(@test_index))

    :ok
  end

  describe "Indexes.list" do
    test "returns an empty list if no indexes exist" do
      {:ok, response} = Indexes.list()

      assert %{"limit" => 20, "offset" => 0, "results" => [], "total" => 0} == response
    end

    test "returns list of existing indexes" do
      wait_for_task(Indexes.create(@test_index))

      {:ok, response} = Indexes.list()

      assert %{"limit" => 20, "offset" => 0, "results" => [index], "total" => 1} = response
      assert %{"uid" => @test_index, "primaryKey" => nil} = index
    end
  end

  describe "Indexes.get" do
    test "returns index details" do
      wait_for_task(Indexes.create(@test_index))
      assert {:ok, index} = Indexes.get(@test_index)

      assert %{
               "uid" => @test_index,
               "primaryKey" => nil,
               "createdAt" => _,
               "updatedAt" => _
             } = index
    end

    test "returns an error if index does not exist" do
      assert {:error, 404, _} = Indexes.get(@test_index)
    end
  end

  describe "Indexes.create" do
    test "creates a new index" do
      assert wait_for_task_success(Indexes.create(@test_index))
    end

    test "returns an error when given duplicate index uid" do
      wait_for_task(Indexes.create(@test_index))
      assert wait_for_task_failure(Indexes.create(@test_index))
    end

    test "create new index with primary key if given" do
      assert wait_for_task_success(Indexes.create(@test_index, primary_key: "test_key"))
      assert {:ok, %{"primaryKey" => "test_key"}} = Indexes.get(@test_index)
    end
  end

  describe "Indexes.update" do
    test "updates primary key" do
      wait_for_task(Indexes.create(@test_index))
      assert wait_for_task_success(Indexes.update(@test_index, primary_key: "new_primary_key"))
      assert {:ok, %{"primaryKey" => "new_primary_key"}} = Indexes.get(@test_index)
    end

    test "returns error if not given primary key" do
      wait_for_task(Indexes.create(@test_index))
      assert {:error, 400, "primary_key is required"} = Indexes.update(@test_index)
    end

    test "updates primary key if index is empty " do
      wait_for_task(Indexes.create(@test_index, primary_key: "id"))

      assert wait_for_task_success(
               Indexes.update(@test_index, primary_key: "another_primary_key")
             )
    end

    test "returns error if primary key is already set with documents" do
      wait_for_task(Indexes.create(@test_index, primary_key: "id"))
      wait_for_task(Documents.add_or_replace(@test_index, @test_document))

      assert wait_for_task_failure(
               Indexes.update(@test_index, primary_key: "another_primary_key")
             )
    end
  end

  describe "Indexes.delete" do
    test "deletes index and returns details" do
      wait_for_task(Indexes.create(@test_index))
      assert wait_for_task_success(Indexes.delete(@test_index))
      assert {:ok, false} = Indexes.exists?(@test_index)
    end

    test "returns an error if index does not exist" do
      assert wait_for_task_failure(Indexes.delete(@test_index))
    end
  end

  describe "Indexes.exists?" do
    test "returns false if index does not exist" do
      assert {:ok, false} = Indexes.exists?(@test_index)
    end

    test "returns true if index exists" do
      wait_for_task(Indexes.create(@test_index))
      assert {:ok, true} = Indexes.exists?(@test_index)
    end
  end
end
