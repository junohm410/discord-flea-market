# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      # 開発ではローカル Next を常に許可
      origins 'http://localhost:3000', 'http://127.0.0.1:3000'
    else
      # 本番等では .env の CORS_ORIGINS（カンマ区切り）で管理
      origins_list =
        ENV.fetch('CORS_ORIGINS', '')
        .split(',')
        .map(&:strip)
        .reject(&:empty?)

      origins(*origins_list)
    end

    resource '/api/*', headers: :any,
                  methods: %i[get post put patch delete options head],
                  credentials: true
  end
end
