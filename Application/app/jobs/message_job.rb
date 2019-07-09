class MessageJob < ApplicationJob
  queue_as :messages

  def perform(*args)
    # Do something later
  end
end
