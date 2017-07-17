class Recipe < ApplicationRecord

  enum status: [
      :editing, # 執筆中
      :published, # 公開済み
  ]

  mount_uploader :video, VideoUploader

  validates_presence_of :title, length: {maximum: 48}
  validates :description, length: {maximum: 255}
  validates_presence_of :description, if: :is_published?
  validates_presence_of :video, if: :is_published?
  validates :prep_time, length: {maximum: 32}
  validates :cook_time, length: {maximum: 32}
  validates :total_time, length: {maximum: 32}
  validates :recipe_yield, length: {maximum: 32}

  belongs_to :user

  scope :latest, -> {
    where(status: :published).order(published_at: :desc)
  }

  def is_author(user)
    user.present? and user_id == user.id
  end

  private

  def is_published?
    self.published?
  end

end
