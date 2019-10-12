class Comment < ApplicationRecord
  include Likable
  paginates_per 20

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :parent, class_name: 'Comment', foreign_key: :parent_id, optional: true
  has_many :children, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

  scope :order_recent, -> { order(created_at: :desc) }
  scope :order_past, -> { order(created_at: :asc) }
  scope :parents_only, -> { where(parent_id: nil) }
  scope :parents_for_panel, -> { parents_only.order_recent }

  def private_for? someone
    return false unless self.private?
    return true if someone.blank?
    self.user != someone and !someone.admin? and commentable.user != someone
  end

  def parent?
    self.parent_id.nil?
  end

  def deleted?
    self.deleted_at.present?
  end
end
