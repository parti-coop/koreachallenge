class Image < ApplicationRecord
  mount_uploader :file, DefaultImageUploader
  validates :file, file_size: { less_than_or_equal_to: 10.megabytes }
end
