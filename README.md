# COMPANIES REVIEWS PROJECT

This README would normally document whatever steps are necessary to get the
application up and running.

**Ruby version**

2.1.3

**System dependencies**

- postgresql
- nodejs as js runtime environment
- mongodb for parser

**Configuration**

- For i18n working setup host name to `example.local` in `/etc/config` and setup and add it to secrets as host variable.
- Application configured from `secrets.yml` and `database.yml` using `ENV` variables

**Database creation**

 - `rails db:create`

**Database initialization**

- `rails db:migrate`

**How to run the test suite**

- `rails test`

**How to run code linter**

 - `rubocop`

**Services (job queues, cache servers, search engines, etc.)**

 - `rails s` starts just pumas

**Deployment instructions**

 - `cap staging deploy`

**Parser**

- Fetch parser as submodule
- `cap staging parser:start`
