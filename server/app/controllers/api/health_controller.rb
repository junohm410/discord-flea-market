# frozen_string_literal: true

module Api
  class HealthController < BaseController
    def index
      render json: { status: 'ok' }
    end
  end
end
