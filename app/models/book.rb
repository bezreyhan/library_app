class Book < ApplicationRecord
  has_many :book_ownerships
  validates :author, presence: true
  validates :title, presence: true
  validates :author, uniqueness: { scope: :title, message: 'with that title already exists' }
end
