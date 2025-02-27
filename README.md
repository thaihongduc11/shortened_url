# README
## How to install
- Install ruby 2.7.7
- Install rails 6.0.6.1
- Install Mysql
- bundle install
- Set username, password, database in config/database.yml
- bundle exec rails db:migrate (run rails db:create if you want to create database)
- rails s

## Run rspec for endpoint
- rspec


### API endpoint
[API document](API_DOCS.md)

### Potential attack vectors on the application

- Cross-site scripting (XSS) attacks: An attacker could inject malicious code into the application, which would then execute when other users click on the shortened URL. This could allow the attacker to steal user credentials or perform other malicious actions.

- SQL injection attacks: If the application uses a database to store URLs or other user data, an attacker could manipulate the input fields to inject malicious SQL code. This could allow the attacker to view or modify sensitive data, such as user credentials.

- Denial of Service (DoS) attacks: An attacker could flood the application with requests or other traffic to overwhelm the server, causing it to crash or become unavailable. This could prevent legitimate users from accessing the application or its resources.

- Beside of we need setting for secure application as:
  - XSS
    - A CSP restricts which scripts can run on your page.
    - Allow only safe characters in inputs

  - SQL injection:
    - Use parameterized queries
    - Use ORMs like ActiveRecord
    - Restrict database permissions

  - DoS:
    - Use services like Cloudflare help block malicious traffic.
    - Move long-running tasks to background jobs using Sidekiq or Resque.

## Solution for scale up and resolve problem the duplicate or collision
### Solution for scale up
1. A single relational database (MySQL/PostgreSQL) will become a bottleneck with high read/write traffic.
- Solution:
  - Use database indexing on original_url and code fields for faster lookups.
  - Implement caching (Redis, Memcached) for frequently accessed URLs.
  - Partition the database by sharding data across multiple servers.
  - Use NoSQL solutions (e.g., Cassandra, DynamoDB) for distributed storage.

2. URL Expiry & Cleanup
- Over time, a large number of URLs may become stale or unused, leading to unnecessary storage consumption.
- Solution:
  - Implement an expiration policy for inactive URLs.
  - Run background jobs to clean up expired URLs periodically.

### Resolve problem the duplicate or collision
- We can use Snowflake ID.
- Snowflake ID is a unique, distributed, and time-based ID generation algorithm originally developed by Twitter. It ensures that each generated ID is globally unique, highly scalable, and ordered based on time.
#### Step by step
##### Encode
- When a user creates a new URL, our API server requests a new unique key from the Snowflake ID(we can use the library from another programming language like Golang).
- Snowflake ID provides a unique key to the API server and marks the key as used.
- API server writes the new URL entry to the database.
- Our service returns an HTTP 200 response to the user.

##### Accessing a URL
- When a client navigates to a certain short URL, the request is sent to the API servers.
- The request first hits the cache, and if the entry is not found there then it is retrieved from the database and an HTTP 302 (Redirect) is issued to the original URL.
- If the key is still not found in the database, an HTTP 404 (Not found) error is sent to the user.