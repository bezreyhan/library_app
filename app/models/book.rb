class Book < ApplicationRecord
  has_many :book_ownerships
  validates :author, presence: true
  validates :title, presence: true
  validates :title, uniqueness: { scope: :author, message: 'with that author already exists' }
end
