defmodule Meilisearch.IndexTest do
  use ExUnit.Case
  alias Meilisearch.Indexes

  @test_index Application.get_env(:meilisearch, :test_index)

  setup do
    Indexes.delete(@test_index)

    :ok
  end

  describe "Indexes.list" do
    test "returns an empty list if no indexes exist" do
      assert {:ok, []} = Indexes.list()
    end

    test "returns list of existing indexes" do
      Indexes.create(@test_index)

      assert {:ok, [index]} = Indexes.list()
      assert %{"name" => @test_index, "uid" => @test_index, "primaryKey" => nil} = index
    end
  end

  describe "Indexes.get" do
    test "returns index details" do
      Indexes.create(@test_index)
      assert {:ok, index} = Indexes.get(@test_index)
      assert %{"name" => @test_index, "uid" => @test_index, "primaryKey" => nil} = index
    end

    test "returns an error if index does not exist" do
      assert {:error, 404, _} = Indexes.get(@test_index)
    end
  end

  describe "Indexes.create" do
    test "creates a new index" do
      assert {:ok, %{"name" => @test_index, "uid" => @test_index, "primaryKey" => nil}} =
               Indexes.create(@test_index)
    end

    test "returns an error when given duplicate index uid" do
      Indexes.create(@test_index)
      assert {:error, 400, _} = Indexes.create(@test_index)
    end

    test "create new index with primary key if given" do
      assert {:ok, %{"uid" => @test_index, "primaryKey" => "test_key"}} =
               Indexes.create(@test_index, primary_key: "test_key")
    end
  end

  describe "Indexes.update" do
    test "updates primary key" do
      Indexes.create(@test_index)
      Indexes.update(@test_index, primary_key: "new_primary_key")

      assert {:ok, %{"primaryKey" => "new_primary_key"}} = Indexes.get(@test_index)
    end

    test "returns error if not given primary key" do
      Indexes.create(@test_index)

      assert {:error, "primary_key is required"} = Indexes.update(@test_index)
    end

    test "returns error if primary key is already set" do
      Indexes.create(@test_index)
      Indexes.update(@test_index, primary_key: "new_primary_key")

      assert {:error, 400, _} = Indexes.update(@test_index, primary_key: "another_primary_key")
    end
  end

  describe "Indexes.delete" do
    test "deletes index and returns details" do
      Indexes.create(@test_index)
      assert {:ok, nil} = Indexes.delete(@test_index)
      assert {:ok, false} = Indexes.exists?(@test_index)
    end

    test "returns an error if index does not exist" do
      assert {:error, 404, _} = Indexes.delete(@test_index)
    end
  end

  describe "Indexes.exists?" do
    test "returns false if index does not exist" do
      assert {:ok, false} = Indexes.exists?(@test_index)
    end

    test "returns true if index exists" do
      Indexes.create(@test_index)
      assert {:ok, true} = Indexes.exists?(@test_index)
    end
  end
end
