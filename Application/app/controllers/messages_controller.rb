class MessagesController < ApplicationController
    def create
        MessageJob.perform_later(params[:app_token], params[:chat_id], params[:text])
    end
end
