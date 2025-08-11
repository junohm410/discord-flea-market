# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    include ActionController::Cookies
    include Devise::Controllers::Helpers
  end
end
