# Fluxa API

## Overview

The Fluxa API is responsible for handling authentication, business logic and communication with the PostgreSQL database.

Technologies used:

- Node.js
- Express
- Prisma ORM
- PostgreSQL
- bcrypt (password encryption)

Base URL (development):

http://localhost:3000


--------------------------------------------------

LOGIN ENDPOINT

POST /login

This endpoint authenticates a user using email and password.

--------------------------------------------------

Request

Header:

Content-Type: application/json

Body example:

{
  "email": "user@email.com",
  "password": "password123"
}

--------------------------------------------------

Backend Login Flow

1. The API receives the email and password.
2. The email is normalized (lowercase and trim).
3. The API searches for the user in the database.
4. If the user exists, it checks if the account is active.
5. bcrypt compares the password with the stored password_hash.
6. If the password is correct, the API returns the user data.

--------------------------------------------------

Success Response

HTTP Status

200 OK

Response example

{
  "message": "Login realizado com sucesso!",
  "user": {
    "id": "abc123xyz",
    "nome": "Admin Fluxa",
    "cargo": "admin"
  }
}

--------------------------------------------------

Error Responses

Email not found

401 Unauthorized

{
  "message": "E-mail não cadastrado."
}

--------------------------------------------------

Wrong password

401 Unauthorized

{
  "message": "Senha incorreta."
}

--------------------------------------------------

Inactive account

403 Forbidden

{
  "message": "Esta conta está desativada."
}

--------------------------------------------------

Server error

500 Internal Server Error

{
  "message": "Erro ao conectar com o banco de dados."
}

--------------------------------------------------

Security

Current security measures:

- Password hashing with bcrypt
- Email normalization
- Active account verification
- Environment variables (.env)

--------------------------------------------------

Future Endpoints

The API will later include:

POST /auth/register
POST /auth/logout
POST /auth/reset-password

GET /finance/accounts
POST /finance/transactions
GET /finance/dashboard