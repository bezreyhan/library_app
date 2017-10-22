class User < ApplicationRecord
  has_many :book_ownerships
  has_many :books, through: :book_ownerships
  validates :username, presence: true, uniqueness: true
end
