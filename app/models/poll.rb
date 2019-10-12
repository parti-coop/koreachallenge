class Poll < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  mount_uploader :image, DefaultImageUploader

  ATTACHMENT_MAX_INDEX = 10

  (1..ATTACHMENT_MAX_INDEX).each do |i|
    mount_uploader :"attachment#{i}", PublicDocumentUploader
    validates :"attachment#{i}", file_size: { less_than_or_equal_to: 50.megabytes }
  end

  scope :order_recent, -> { order(created_at: :desc) }
  before_save :update_type

  def voted_by? someone
    false if someone.blank?
    votes.exists?(user: someone)
  end

  def valid_attachment_name(index)
    self.send(:"attachment#{index}_name").gsub(/\\+/, "%20")
  end

  def attachment_of(index, postfix = nil)
    con = nil
    con = '_' if postfix.present? and postfix != '!' and postfix != '?'
    self.send(:"attachment#{index}#{con}#{postfix}")
  end

  def private_comments?
    false
  end

  def threadable_comment?
    true
  end

  private

  def update_type
    (1..ATTACHMENT_MAX_INDEX).each do |index|
      if self.attachment_of(index).present? && self.send(:"will_save_change_to_attachment#{index}?")
        self.send(:"attachment#{index}_type=", attachment_of(index).file.content_type)
        self.send(:"attachment#{index}_size=", attachment_of(index).file.size)
      end
    end
  end
end
