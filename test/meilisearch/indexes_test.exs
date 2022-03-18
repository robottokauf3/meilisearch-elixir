defmodule Meilisearch.IndexTest do
  use ExUnit.Case
  import Meilisearch.Wait
  alias Meilisearch.Indexes

  @test_index Meilisearch.Config.get(:test_index)

  setup do
    Indexes.delete(@test_index) |> wait()

    :ok
  end

  describe "Indexes.list" do
    test "returns an empty list if no indexes exist" do
      assert {:ok, []} = Indexes.list()
    end

    test "returns list of existing indexes" do
      Indexes.create(@test_index) |> wait()

      assert {:ok, [index]} = Indexes.list()
      assert %{"name" => @test_index, "uid" => @test_index, "primaryKey" => nil} = index
    end
  end

  describe "Indexes.get" do
    test "returns index details" do
      Indexes.create(@test_index) |> wait()
      assert {:ok, index} = Indexes.get(@test_index)
      assert %{"name" => @test_index, "uid" => @test_index, "primaryKey" => nil} = index
    end

    test "creates index if index does not exists" do
      assert {:error, 404, _} = Indexes.get(@test_index)
    end
  end

  describe "Indexes.create" do
    test "creates a new index" do
      Indexes.create(@test_index) |> wait()

      assert {:ok, %{"name" => @test_index, "uid" => @test_index, "primaryKey" => nil}} =
               Indexes.get(@test_index)
    end

    test "create new index with primary key if given" do
      Indexes.create(@test_index, primary_key: "test_key") |> wait()
      assert {:ok, %{"uid" => @test_index, "primaryKey" => "test_key"}} = Indexes.get(@test_index)
    end
  end

  describe "Indexes.update" do
    test "updates primary key" do
      Indexes.create(@test_index) |> wait()
      Indexes.update(@test_index, primary_key: "new_primary_key") |> wait()

      assert {:ok, %{"primaryKey" => "new_primary_key"}} = Indexes.get(@test_index)
    end

    test "returns error if not given primary key" do
      Indexes.create(@test_index) |> wait()

      assert {:error, "primary_key is required"} = Indexes.update(@test_index)
    end
  end

  describe "Indexes.delete" do
    test "deletes index" do
      Indexes.create(@test_index) |> wait()
      Indexes.delete(@test_index) |> wait()
      assert {:ok, false} = Indexes.exists?(@test_index)
    end
  end

  describe "Indexes.exists?" do
    test "returns false if index does not exist" do
      Indexes.delete(@test_index) |> wait()
      assert {:ok, false} = Indexes.exists?(@test_index)
    end

    test "returns true if index exists" do
      Indexes.create(@test_index) |> wait()
      assert {:ok, true} = Indexes.exists?(@test_index)
    end
  end
end
