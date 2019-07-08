class MessagesJob < ApplicationJob
  queue_as :messages

  def perform(*args)
    # Do something later
    puts "BRAH"
  end
end
