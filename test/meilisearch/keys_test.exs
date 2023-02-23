defmodule Meilisearch.KeysTest do
  @moduledoc false
  use ExUnit.Case

  import Support.Helpers
  alias Meilisearch.Keys

  @custom_uid "00813f43-66ec-4316-aa15-f908e92a5fff"

  setup do
    on_exit(fn ->
      Keys.delete(@custom_uid)
    end)
  end

  describe "Keys.list" do
    test "returns a list that contains the default keys (frontend and admin)" do
      assert {:ok,
              %{
                "results" => [
                  %{
                    "key" => _,
                    "indexes" => _,
                    "actions" => ["search"],
                    "description" => _,
                    "createdAt" => _,
                    "updatedAt" => _,
                    "expiresAt" => _
                  },
                  %{
                    "key" => _,
                    "indexes" => _,
                    "actions" => ["*"],
                    "description" => _,
                    "createdAt" => _,
                    "updatedAt" => _,
                    "expiresAt" => _
                  }
                ]
              }} = Keys.list()
    end
  end

  describe "Keys.get" do
    test "get default keys" do
      assert {:ok, %{"results" => [key | _]}} = Keys.list()

      assert {:ok,
              %{
                "key" => _,
                "indexes" => _,
                "actions" => _,
                "description" => _,
                "createdAt" => _,
                "updatedAt" => _,
                "expiresAt" => _
              }} = Keys.get(key["key"])
    end
  end

  @valid_key_data %{
    "uid" => @custom_uid,
    "name" => "Doc adding Key",
    "description" => "Add documents: Products API key",
    "actions" => ["documents.add"],
    "indexes" => ["products"],
    "expiresAt" => "2042-04-02T00:42:42Z"
  }

  describe "Keys.create" do
    test "creates a key" do
      assert {:ok,
              %{
                "uid" => @custom_uid,
                "name" => "Doc adding Key",
                "description" => "Add documents: Products API key",
                "key" => _,
                "actions" => ["documents.add"],
                "indexes" => ["products"],
                "expiresAt" => "2042-04-02T00:42:42Z",
                "createdAt" => _,
                "updatedAt" => _
              }} = Keys.create(@valid_key_data)
    end
  end

  @valid_key_update_data %{
    "name" => "Document adding Key"
  }

  describe "Keys.update" do
    setup do
      {:ok, key} = Keys.create(@valid_key_data)

      {:ok, key: key}
    end

    test "can result in a 404" do
      assert {:error, 404, _} = Keys.update("not-a-real-key", @valid_key_update_data)
    end

    test "updates a key via uid" do
      assert {:ok,
              %{
                "uid" => @custom_uid,
                "name" => "Document adding Key",
                "description" => "Add documents: Products API key",
                "key" => _,
                "actions" => _,
                "indexes" => _,
                "expiresAt" => _,
                "createdAt" => _,
                "updatedAt" => _
              }} = Keys.update(@custom_uid, @valid_key_update_data)

      {:ok, %{"results" => keys}} = Keys.list()
    end

    test "updates a key via key field", %{key: key} do
      assert {:ok,
              %{
                "uid" => @custom_uid,
                "name" => "Document adding Key",
                "description" => "Add documents: Products API key",
                "key" => _,
                "actions" => _,
                "indexes" => _,
                "expiresAt" => _,
                "createdAt" => _,
                "updatedAt" => _
              }} = Keys.update(Map.get(key, "key"), @valid_key_update_data)
    end
  end

  describe "Keys.delete" do
    test "can result in a 404" do
      assert {:error, 404, _} = Keys.delete("not-a-real-key")
    end

    test "deletes a key via uid" do
      {:ok, key} = Keys.create(@valid_key_data)

      assert {:ok, _} = Keys.delete(Map.get(key, "uid"))

      {:ok, %{"results" => keys}} = Keys.list()

      assert length(keys) == 2
    end

    test "deletes a key via key field" do
      {:ok, key} = Keys.create(@valid_key_data)

      assert {:ok, _} = Keys.delete(Map.get(key, "key"))

      {:ok, %{"results" => keys}} = Keys.list()

      assert length(keys) == 2
    end
  end

  # test "Keys.reset" do
  #   wait_for_task(
  #     Keys.update(
  #       @test_index,
  #       @typo_tolerance_settings
  #     )
  #   )

  #   {:ok, task} = Keys.reset(@test_index)

  #   wait_for_task(task)
  #   assert {:ok, %{"status" => "succeeded"}} = Keys.get(Map.get(task, "taskUid"))

  #   assert {:ok, @default_type_tolerance_settings} =
  #            Settings.get_typo_tolerance_settings(@test_index)
  # end
end
