class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable,
  # :recoverable, :validatable
  devise :database_authenticatable, :registerable,
         :rememberable, :omniauthable

  has_one :idea, dependent: :destroy
  has_many :notices, dependent: :destroy
  has_many :stories, dependent: :restrict_with_error
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates_format_of       :email, with: Devise.email_regexp, allow_blank: true, if: :will_save_change_to_email?
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true
  validates :uid, uniqueness: { scope: [:provider] }

  before_validation :downcase_email

  scope :order_recent, -> { order(created_at: :desc) }
  scoped_search on: [:name, :email]

  mount_uploader :profile_image, DefaultImageUploader


  def self.find_for_omniauth(provider, uid)
    where(provider: provider, uid: uid).first
  end

  def self.parse_omniauth(data, params)
    result = { provider: data['provider'],
      uid: data['uid'],
      email: data['info']['email'],
      image: data['info']['image'],
      name: data['info']['name'] || data['info']['nickname'] }

    remember_me = params.try(:fetch, "remember_me", false)
    result[:remember_me] = remember_me
    result
  end

  def self.find_or_initialize_for_omniauth(parsed_data)
    user = User.find_or_initialize_by(provider: parsed_data[:provider], uid: parsed_data[:uid]) do |user|
      user.email = parsed_data[:email]
      user.name = parsed_data[:name] || user.email
      user.password = Devise.friendly_token[0,20]
      user.remote_profile_image_url = parsed_data[:image]
    end
    user.remember_me = parsed_data[:remember_me]
    user
  end

  def email_required?
    false
  end

  def admin?
    self.admin or fixed_admin?
  end

  def fixed_admin?
    %w(contact@parti.xyz foroso@gmail.com).include?(self.email)
  end

  def confirmation?
    confirmation_terms == true and confirmation_privacy == true
  end

  def cancelable?
    !self.stories.exists?
  end

  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def downcase_email
    if self.email.present?
      self.email = self.email.downcase
    end
  end
end
