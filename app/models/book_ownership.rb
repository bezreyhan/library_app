class BookOwnership < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :user_id, presence: true
  validates :book_id, presence: true
  validates :read, inclusion: [true, false]
  validates :user, uniqueness: { scope: :book, message: 'already owns that book' }

  def self_and_book_attrs
    book = Book.find(self.book_id)
    self.as_json(only: [:read]).merge(book.as_json)
  end
end
