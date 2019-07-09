class ChatJob < ApplicationJob
  queue_as :chats

  def perform(*args)
    # Do something later
    puts "BOOO"
  end
end
