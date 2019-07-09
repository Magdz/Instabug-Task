class MessageJob < ApplicationJob
  queue_as :messages

  def perform(*args)
    @app = App.where(token: args[0]).first

    conn_config = ActiveRecord::Base.connection_config
    conn_config[:database] = "chat_" + @app.id.to_s + "_" + args[1]
    puts conn_config

    ActiveRecord::Base.establish_connection conn_config
    puts "connected!"

    Rake::Task["db:migrate"].invoke
    puts "migrated!"

    @msg = Message.new
    @msg.text = args[2]
    
    if @msg.save
      conn_config[:database] = "app_" + @app.id.to_s
      ActiveRecord::Base.establish_connection conn_config
      puts "connect!"

      @chat = Chat.find(args[1])
      @chat.messages_count += 1
      puts @app.chats_count
      @chat.save

      conn_config[:database] = "applications_dev"
      ActiveRecord::Base.establish_connection conn_config
      puts "reconnected!"
    end

  end

end
