# app/controllers/sessions_controller.rb

class SessionsController < ApplicationController
    def create
        auth = request.env['omniauth.auth']

        user = User.find_or_create_by(discord_id: auth['extra']['raw_info']['id']) do |u|
          u.username = auth['extra']['raw_info']['global_name']
          u.profile_image = auth['info']['image']
          u.discord_id = auth['extra']['raw_info']['id']
          u.user_type = 42
          # Add more fields as needed
        end

        # Check if user is nil and handle the error
        if user.nil?
          # Redirect to root path with an error message, or handle as appropriate
          redirect_to root_path, alert: "User could not be created. Please try again."
          return # This is important to stop execution of the method here
        end

        # Store user information in the session
        session[:user_id] = user.id
        session[:username] = user.username

        redirect_to dashboard_path
      end

      def destroy
        reset_session
        redirect_to root_path, notice: "You have successfully logged out."
      end
  
    def failure
      redirect_to root_path, alert: "Failed to log in with Discord."
    end
  end
  