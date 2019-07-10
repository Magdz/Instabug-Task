config = {
    host: "http://search:9200"
}

Elasticsearch::Model.client = Elasticsearch::Client.new(config)