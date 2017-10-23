# Library API for Headspace Challege
## Dependencies
- Ruby v2.3.1
- Postgres v9.6.3

## Requirements
  - Create a user
    - Users must have a unique username, and can have a collection of books.
  - Create a book
    - Books must have a title and author
  - Add a book to a user's library as an unread book
  - Mark a book in a user's library as read or unread
  - Delete a book from a user’s library
  - List all books in a user's library (by author, by read, by read/unread status)

## Getting Started
First clone the repo then follow the following steps:
```bash
$ cd library_app
$ bundle install # install dependencies
$ rails db:create db:migrate # create the database and run the migrations
$ rspec # run the tests
$ rails server # run the server on port 3000
```

## Endpoints
| Action | Endpoint | Parameters | Example |
| ------ | ------ | ------ | ------ |
| Create User | POST /users | username: string | `curl -X POST -H "Content-Type: application/json" -d '{"username":"user_1"}' http://localhost:3000/users`
| Create Book | POST /books | author: string, title: string | `curl -X POST -H "Content-Type: application/json" -d '{"title":"A Confederacy of Dunces", "author": "John Kennedy Toole"}' http://localhost:3000/books`
| Add Book to User's Library| POST /users/:user_id/books | book_id: string | `curl -X POST -H "Content-Type: application/json" -d '{"book_id":"1"}' http://localhost:3000/users/1/books`
| Mark Book as 'read' or 'unread'| PUT /users/:user_id/books/:id | read: boolean | `curl -X PUT -H "Content-Type: application/json" -d '{"read":"true"}' http://localhost:3000/users/1/books/1`
|Delete Book from User's Library | DELETE /users/:user_id/books/:id | NA | `curl -X DELETE -H "Content-Type: application/json" http://localhost:3000/users/1/books/1`
|List User's Books | GET /users/:user_id/books | read: boolean, author: string | `curl -X GET -H "Content-Type: application/json" http://localhost:3000/users/1/books` OR with query params `curl -X GET -H "Content-Type: application/json" -G http://localhost:3000/users/1/books --data-urlencode author="John Kennedy Toole" --data-urlencode read=true`

## Assumptions
An assumption I made was that when a consumer of the API requests a user's books, they want to know if those books have been read or not. For example, if you are building a UI that lists a user's books in a table, you may want to have a 'read' column so that the user can know if the book has been read or not. Therefor, when the API responds with a user's book, the response also contains a 'read' property.