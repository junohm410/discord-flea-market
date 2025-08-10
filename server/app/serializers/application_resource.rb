# frozen_string_literal: true

class ApplicationResource
  include Alba::Resource

  # lowerCamelCase に統一
  key_transform :camel_lower

  def self.pagination_meta(pagy_like)
    {
      total: pagy_like.total_count,
      totalPages: pagy_like.total_pages,
      currentPage: pagy_like.current_page,
      per: pagy_like.limit_value
    }
  end
end
