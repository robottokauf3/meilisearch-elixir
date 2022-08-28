ExUnit.start(exclude: [:skip])

%{
  host: host,
  port: port
} = URI.parse(Meilisearch.Config.endpoint())

case :gen_tcp.connect(to_charlist(host), port, []) do
  {:ok, socket} -> :gen_tcp.close(socket)
  _ -> Mix.raise("Cannot connect to Meilisearch instance at #{host}:#{port}")
end

Support.Helpers.delete_all_indexes()
