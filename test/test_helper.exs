ExUnit.start()

%{
  host: host,
  port: port
} = URI.parse(Application.get_env(:meilisearch, :endpoint))

case :gen_tcp.connect(to_charlist(host), 7700, []) do
  {:ok, socket} -> :gen_tcp.close(socket)
  _ -> Mix.raise("Cannot connect to Meilisearch instance at #{host}:#{port}")
end

Support.Helpers.delete_all_indexes()
