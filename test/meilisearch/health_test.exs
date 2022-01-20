defmodule Meilisearch.HealthTest do
  use ExUnit.Case

  alias Meilisearch.Health

  describe "Health.get" do
    test ~s(returns `{:ok, %{"status" => "available"}}` when instance is healthy) do
      assert {:ok, %{"status" => "available"}} = Health.get()
    end
  end

  describe "Health.is_healthy?/0" do
    test "returns `true` when instance is healthy" do
      assert true == Health.healthy?()
    end
  end
end
