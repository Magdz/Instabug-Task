class AppController < ApplicationController
    def create
        @app = App.new(app_params)
        o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
        string = (0...50).map { o[rand(o.length)] }.join
        @app.token = string

        if @app.save
            ActiveRecord::Base.connection.execute("CREATE DATABASE app_" + @app.id.to_s)

            render json: @app, status: :ok
        end
    end

    private
        def app_params
            params.require(:app).permit(:name)
        end
end
