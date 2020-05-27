defmodule Meilisearch.IndexTest do
  use ExUnit.Case
  alias Meilisearch.Index

  @test_index "meilisearch_test"

  setup do
    Index.delete(@test_index)

    :ok
  end

  describe "Index.list" do
    test "returns an empty list if no indexes exist" do
      assert {:ok, []} = Index.list()
    end

    test "returns list of existing indexes" do
      Index.create(@test_index)

      assert {:ok, [index]} = Index.list()
      assert %{"name" => @test_index, "uid" => @test_index, "primaryKey" => nil} = index
    end
  end

  describe "Index.get" do
    test "returns index details" do
      Index.create(@test_index)
      assert {:ok, index} = Index.get(@test_index)
      assert %{"name" => @test_index, "uid" => @test_index, "primaryKey" => nil} = index
    end

    test "returns an error if index does not exist" do
      assert {:error, 404, _} = Index.get(@test_index)
    end
  end

  describe "Index.create" do
    test "creates a new index" do
      assert {:ok, %{"name" => @test_index, "uid" => @test_index, "primaryKey" => nil}} =
               Index.create(@test_index)
    end

    test "returns an error when given duplicate index uid" do
      Index.create(@test_index)
      assert {:error, 400, _} = Index.create(@test_index)
    end

    test "create new index with primary key if given" do
      assert {:ok, %{"uid" => @test_index, "primaryKey" => "test_key"}} =
               Index.create(@test_index, primary_key: "test_key")
    end
  end

  describe "Index.update" do
    test "updates primary key" do
      Index.create(@test_index)
      Index.update(@test_index, primary_key: "new_primary_key")

      assert {:ok, %{"primaryKey" => "new_primary_key"}} = Index.get(@test_index)
    end

    test "returns error if not given primary key" do
      Index.create(@test_index)

      assert {:error, "primary_key is required"} = Index.update(@test_index)
    end

    test "returns error if primary key is already set" do
      Index.create(@test_index)
      Index.update(@test_index, primary_key: "new_primary_key")

      assert {:error, 400, _} = Index.update(@test_index, primary_key: "another_primary_key")
    end
  end

  describe "Index.delete" do
    test "deletes index and returns details" do
      Index.create(@test_index)
      assert {:ok, nil} = Index.delete(@test_index)
      assert {:ok, false} = Index.exists?(@test_index)
    end

    test "returns an error if index does not exist" do
      assert {:error, 404, _} = Index.delete(@test_index)
    end
  end

  describe "Index.exists?" do
    test "returns false if index does not exist" do
      assert {:ok, false} = Index.exists?(@test_index)
    end

    test "returns true if index exists" do
      Index.create(@test_index)
      assert {:ok, true} = Index.exists?(@test_index)
    end
  end
end
