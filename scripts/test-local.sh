services=`docker-compose config --services | xargs echo`

for service in $services; do
    port=`docker inspect --format='{{(index (index .NetworkSettings.Ports "7700/tcp") 0).HostPort}}' meilisearch-elixir_${service}_1`
    echo "Testing against $service"
    MEILISEARCH_ENDPOINT=http://127.0.0.1:$port mix test
done