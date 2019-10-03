class Vote < ApplicationRecord
  belongs_to :poll, counter_cache: true
  belongs_to :user
end
