defmodule Meilisearch.KeysTest do
  use ExUnit.Case
  alias Meilisearch.Keys

  test "Keys.get returns public and private keys" do
    assert {:ok, %{"results" => keys}} = Keys.get()
    assert Enum.find(keys, & Map.get(&1, "actions") == ["search"])
    assert Enum.find(keys, & Map.get(&1, "actions") == ["*"])
  end
end
