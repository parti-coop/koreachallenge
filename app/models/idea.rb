class Idea < ApplicationRecord
  belongs_to :user

  extend Enumerize
  enumerize :mode, in: [:solo, :team], predicates: true, scope: true
  mount_uploader :attachment, DefaultDocumentUploader

  validates :category, presence: true, if: :submitted?
  validates :title, presence: true, if: :submitted?
  validates :mode, presence: true, if: :submitted?
  validates :team_member_count, presence: true, if: :team_submitted?
  validates :team_name, presence: true, if: :team_submitted?
  validates :planner_name, presence: true, if: :submitted?
  validates :planner_age, presence: true, if: :submitted?
  validates :planner_sex, presence: true, if: :submitted?
  validates :planner_address, presence: true, if: :submitted?
  validates :planner_tel, presence: true, if: :submitted?
  validates :planner_email, presence: true, if: :submitted?
  validates :attachment, file_size: { less_than_or_equal_to: 3.megabytes }

  before_save :update_type

  scope :order_recent, -> { order(created_at: :desc) }

  def submitted?
    self.submitted_at.present?
  end

  def team_submitted?
    submitted? and self.mode.team?
  end

  def valid_attachment_name
    self.attachment_name.gsub(/\\+/, "%20")
  end

  private

  def update_type
    if attachment.present? && will_save_change_to_attachment?
      self.attachment_type = attachment.file.content_type
      self.attachment_size = attachment.file.size
    end
  end
end