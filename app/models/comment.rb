class Comment < ApplicationRecord
  include Likable
  paginates_per 20

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :likes, as: :likable, dependent: :destroy

  scope :order_recent, -> { order(created_at: :desc) }

  def private_for? someone
    return false unless self.private? 
    return true if someone.blank?
    self.user != someone and !someone.admin? 
  end
end
