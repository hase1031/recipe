class Tag < ApplicationRecord
  has_many :recipe_tags
  has_many :recipes, through: :recipe_tags
  validates_presence_of :name, maximum: {length: 255}
end
