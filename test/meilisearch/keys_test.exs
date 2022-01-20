defmodule Meilisearch.KeysTest do
  use ExUnit.Case
  alias Meilisearch.Keys

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
end
