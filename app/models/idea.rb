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
  validates :pt, presence: true, if: :submitted?
  validates :motivation, presence: true, if: :submitted?
  validates :summary, presence: true, if: :submitted?
  validates :desc, presence: true, if: :submitted?
  validates :was_reused, inclusion: { in: [true, false] }, if: :submitted?
  validates :reuse_desc, presence: true, if: :should_have_reuse_desc?
  # validates :planner_name, presence: true, if: :submitted?
  # validates :planner_age, presence: true, if: :submitted?
  # validates :planner_sex, presence: true, if: :submitted?
  # validates :planner_address, presence: true, if: :submitted?
  # validates :planner_tel, presence: true, if: :submitted?
  # validates :planner_email, presence: true, if: :submitted?
  validates :attachment, file_size: { less_than_or_equal_to: 20.megabytes }
  validate :valid_members, if: :submitted?

  before_save :update_type

  scope :order_recent, -> { order(created_at: :desc) }

  accepts_nested_attributes_for :members, reject_if: :all_blank, allow_destroy: true

  def submitted?
    self.submitted_at.present? and self.persisted?
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

  def valid_members
    if self.members.length <= 0
      errors.add(:members, I18n.t('errors.messages.idea.no_members'))
    end
  end

  def should_have_reuse_desc?
    self.submitted? and self.was_reused?
  end
end