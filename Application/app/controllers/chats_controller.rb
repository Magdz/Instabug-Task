class ChatsController < ApplicationController
    def create
        @app = App.where(token: params[:app_token]).first

        redis = Redis.new(:host => 'queue')
        chat_num = redis.incr("app_" + @app.id.to_s)
        redis.set("chat_" + @app.id.to_s + "_" + chat_num.to_s, 0)

        ChatJob.perform_later(params[:app_token])

        render json: {:chat_num => chat_num}, status: :ok
    end
end
