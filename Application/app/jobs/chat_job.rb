class ChatJob < ApplicationJob
  queue_as :chats

  def perform(*args)
    @app = App.where(token: args[0]).first
    puts @app.id

    conn_config = ActiveRecord::Base.connection_config
    conn_config[:database] = "app_" + @app.id.to_s
    puts conn_config

    ActiveRecord::Base.establish_connection conn_config
    puts "connected!"

    Rake::Task["db:migrate"].invoke
    puts "migrated!"

    @chat = Chat.new
    @chat.messages_count = 0
    
    if @chat.save
      conn_config[:database] = "applications_dev"
      ActiveRecord::Base.establish_connection conn_config
      puts "reconnected!"

      @app.chats_count += 1
      puts @app.chats_count
      @app.save

      begin
        ActiveRecord::Base.connection.execute(
          "CREATE DATABASE chat_" + @app.id.to_s + "_" + @chat.id.to_s
        )
      rescue
          puts "Database exists"
      end
    end

  end

end
