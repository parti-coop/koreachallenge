class Idea < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy

  extend Enumerize
  enumerize :mode, in: [:solo, :team], predicates: true, scope: true
  enumerize :category, in: [:dae, :han, :min, :kook, :etc], predicates: true, scope: true
  mount_uploader :attachment, DefaultDocumentUploader

  validates :category, presence: true, if: :submitted?
  validates :title, presence: true, if: :submitted?
  validates :mode, presence: true, if: :submitted?
  validates :team_name, presence: true, if: :team_submitted?
  # validates :planner_name, presence: true, if: :submitted?
  # validates :planner_age, presence: true, if: :submitted?
  # validates :planner_sex, presence: true, if: :submitted?
  # validates :planner_address, presence: true, if: :submitted?
  # validates :planner_tel, presence: true, if: :submitted?
  # validates :planner_email, presence: true, if: :submitted?
  validates :attachment, file_size: { less_than_or_equal_to: 20.megabytes }

  before_save :update_type

  scope :order_recent, -> { order(created_at: :desc) }

  accepts_nested_attributes_for :members, reject_if: :all_blank, allow_destroy: true

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