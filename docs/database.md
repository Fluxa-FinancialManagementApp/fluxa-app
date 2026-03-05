# Fluxa Database

## Overview

Fluxa uses **PostgreSQL** as its main database.

Instead of using multiple databases, Fluxa uses **a single database** with **logical separation through schemas**.

Database name:

fluxa_db

Schemas act like logical "drawers" inside the same database.

This approach improves:

- organization
- scalability
- maintainability
- SaaS architecture readiness

--------------------------------------------------

Schemas

auth  
Responsible for authentication and user management.

finance  
Will store financial data such as accounts, transactions, categories and investments.

billing  
Will manage subscriptions, payments and plan control.

Currently implemented:

auth

--------------------------------------------------

Auth Schema

Schema:

auth

This schema stores the authentication system of Fluxa.

Current table:

auth.users

--------------------------------------------------

Table: auth.users

This table stores all system users.

--------------------------------------------------

user_id

Primary key of the user.

Type:

VARCHAR(15)

Default generation rule:

SUBSTRING(gen_random_uuid()::text, 1, 12)

Fluxa uses a **Short ID strategy** derived from UUID.

Example:

a3f82c1d9ab2

Advantages:

- shorter identifiers
- cleaner URLs
- still extremely low collision probability

--------------------------------------------------

display_name

User display name.

Type:

VARCHAR(100)

Example:

Admin Fluxa

--------------------------------------------------

email

User email address.

Type:

CITEXT (case insensitive)

This allows email comparison ignoring uppercase/lowercase differences.

Example:

user@email.com

--------------------------------------------------

password_hash

Encrypted password stored using bcrypt.

Type:

TEXT

Passwords are never stored in plain text.

--------------------------------------------------

role

Defines the user permission level.

Type:

VARCHAR(20)

Possible values:

admin  
cliente

--------------------------------------------------

reset_token

Temporary token used for password reset.

Type:

VARCHAR(255)

--------------------------------------------------

reset_token_expires

Expiration timestamp for password reset tokens.

Type:

TIMESTAMPTZ

--------------------------------------------------

is_active

Indicates whether the account is active.

Type:

BOOLEAN

Default value:

TRUE

--------------------------------------------------

created_at

Timestamp when the account was created.

Type:

TIMESTAMPTZ

--------------------------------------------------

updated_at

Timestamp of the last update.

Type:

TIMESTAMPTZ

--------------------------------------------------

deleted_at

Soft delete column.

Type:

TIMESTAMPTZ

If not null, the account is considered logically deleted.

--------------------------------------------------

Indexes

Unique email index

Ensures that active users cannot share the same email.

Index:

uq_users_email_active

--------------------------------------------------

Active user filter index

Speeds up filtering active accounts.

Index:

idx_users_is_active

--------------------------------------------------

Creation date index

Speeds up ordering users by creation date.

Index:

idx_users_created_at

--------------------------------------------------

Admin Seed

During initialization, the system inserts a default administrator account.

Example:

email  
finmanagement.fluxa@gmail.com

display_name  
Admin Fluxa

role  
admin

--------------------------------------------------

Future Improvements

Planned improvements for the database:

finance schema

Tables planned:

- accounts
- transactions
- categories
- budgets
- investments
- import_jobs (CSV / OFX)

--------------------------------------------------

billing schema

Tables planned:

- subscriptions
- plans
- invoices
- payments