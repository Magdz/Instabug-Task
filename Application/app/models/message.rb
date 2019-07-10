require 'elasticsearch/model'

class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
end

Message.import(force: true)
