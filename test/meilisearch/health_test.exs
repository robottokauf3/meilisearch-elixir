defmodule Meilisearch.HealthTest do
  use ExUnit.Case

  alias Meilisearch.Health

  describe "Health.get" do
    test "returns `{:ok, 200, _}` when instanse is healthy" do
      Health.update(true)
      assert {:ok, _} = Health.get()
    end

    test "returns `{:ok, 503, _}` when instanse is unhealthy" do
      Health.update(false)
      assert {:error, 503, _} = Health.get()
      Health.update(true)
    end
  end

  describe "Health.update" do
    test "updates health of instance" do
      Health.update(false)
      assert {:error, 503, _} = Health.get()

      Health.update(true)
      assert {:ok, _} = Health.get()
    end
  end

  describe "Health.is_healthy?/0" do
    test "returns `true` when instance is healthy" do
      Health.update(true)
      assert true == Health.healthy?()
    end

    test "returns `false` when instance is unhealthy" do
      Health.update(false)
      assert false == Health.healthy?()
      Health.update(true)
    end
  end
end
