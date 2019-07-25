class Member < ApplicationRecord
  belongs_to :idea

  extend Enumerize
  enumerize :sex, in: [:male, :female], predicates: true, scope: true

  validates :name, presence: true, if: :submitted?
  validates :age, presence: true, if: :submitted?
  validates :sex, presence: true, if: :submitted?
  validates :address, presence: true, if: :submitted?
  validates :tel, presence: true, if: :submitted?
  validates :email, presence: true, if: :submitted?

  private

  def submitted?
    self.idea.try(:submitted?) and self.idea.try(:persisted?)
  end
end