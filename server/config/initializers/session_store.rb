# frozen_string_literal: true

# セッション Cookie の属性を明示。
# - SameSite=Lax（既定）でリンク遷移GETは許可、クロスサイトPOSTは送信されない
# - HttpOnly: true で JS から読み取れない
# - Secure: 本番のみ true（HTTPS 前提）
# - domain: 必要時のみ ENV で上書き（同一eTLD+1運用想定）

Rails.application.config.session_store :cookie_store,
  key: '_dfm_session',
  same_site: :lax,
  httponly: true,
  secure: Rails.env.production?,
  domain: (ENV['SESSION_COOKIE_DOMAIN'] if ENV['SESSION_COOKIE_DOMAIN'].present?)
