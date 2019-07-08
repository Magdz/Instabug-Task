class ChatsJob < ApplicationJob
  queue_as :chats

  def perform(*args)
    # Do something later
    puts "DA"
  end
end
