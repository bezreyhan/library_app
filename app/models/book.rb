class Book < ApplicationRecord
  validates :author, presence: true
  validates :title, presence: true
  validates :author, uniqueness: { scope: :title, message: 'with that title already exists' }
end
