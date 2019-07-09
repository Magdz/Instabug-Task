class ChatsController < ApplicationController
    def create
        ChatJob.perform_later(params[:app_token])
    end
end
