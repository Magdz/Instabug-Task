class MessagesController < ApplicationController
    def create
        MessageJob.perform_later(params[:app_token], params[:chat_id], params[:text])
    end

    def search
        @app = App.where(token: params[:app_token]).first

        conn_config = ActiveRecord::Base.connection_config
        conn_config[:database] = "chat_" + @app.id.to_s + "_" + params[:chat_id]
        puts conn_config

        ActiveRecord::Base.establish_connection conn_config
        puts "connected!"

        Message.import
        sleep(0.5)
        puts params[:q]
        @messages = Message.search(params[:q])
        puts @messages

        conn_config[:database] = "applications_dev"
        ActiveRecord::Base.establish_connection conn_config
        puts "reconnected!"

        render json: @messages, status: :ok
   end
end
