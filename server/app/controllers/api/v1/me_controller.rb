# frozen_string_literal: true

module Api
  module V1
    class MeController < Api::BaseController
      before_action :authenticate_user!

      def show
        render body: UserResource.new(current_user).serialize, content_type: 'application/json'
      end

      def destroy
        current_user.destroy!
        sign_out current_user
        reset_session
        head :no_content
      end
    end
  end
end
