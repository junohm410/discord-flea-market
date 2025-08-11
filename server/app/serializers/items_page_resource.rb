# frozen_string_literal: true

class ItemsPageResource < ApplicationResource
  many :data, resource: ItemResource do |obj|
    obj[:data]
  end

  attribute :meta do |obj|
    obj[:meta]
  end
end
