class Gallery < ApplicationRecord
  DEFALUT_ROUND_SLUG = 'pre'

  include Likable
  paginates_per 10

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :round_slug, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :image, presence: true
  mount_uploader :image, DefaultImageUploader

  scope :order_recent, -> { order(created_at: :desc) }
  scope :for_round_slug, -> (round_slug) { where(round_slug: round_slug) }
end