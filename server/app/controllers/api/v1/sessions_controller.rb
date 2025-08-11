# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Api::BaseController
      before_action :authenticate_user!

      def destroy
        sign_out current_user
        reset_session
        head :no_content
      end
    end
  end
end
