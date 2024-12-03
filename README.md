
# Admin for a Clinic

This repository contains a Ruby on Rails application that leverages PostgreSQL as its database and follows industry best practices for development, testing, and deployment.

---

## Requirements

Ensure you have the following installed on your system:

- **Ruby**: 3.0.6
- **PostgreSQL**: 16.2
- **Bundler**: >= 2.3.0
- **Node.js**: >= 14.0.0
- **Yarn**: >= 1.22.0 (for managing JavaScript dependencies)

---

## Setup Instructions

Follow these steps to set up the application locally:

### 1. Clone the Repository

```bash
git clone https://github.com/your_username/your_repo.git
cd your_repo
```

### 2. Install Dependencies

#### Ruby Gems
Install the required gems using Bundler:

```bash
bundle install
```

#### JavaScript Dependencies
Install JavaScript dependencies using Yarn:

```bash
yarn install
```

### 3. Configure the Database

#### Database Configuration
Create a `config/database.yml` file. Use the provided template `config/database.yml.example` as a reference:

```bash
cp config/database.yml.example config/database.yml
```

Edit `config/database.yml` to match your local database credentials using the .env file for passwords.

#### Database Setup
Run the following commands to create, migrate, and seed the database:

```bash
rails db:create
rails db:migrate
rails db:seed
```

---

## Running the Application

### Start the Rails Server
Launch the Rails application locally:

```bash
rails server
```

Access the application at [http://localhost:3000](http://localhost:3000).

---

## Testing

### Run RSpec Tests
To execute the test suite, run:

```bash
bundle exec rspec
```

### Run Linters
Check for linting issues using RuboCop:

```bash
bundle exec rubocop
```

---

## Deployment Instructions

### 1. Prepare the Application
Ensure the following steps are complete before deploying:

- All migrations are up to date: `rails db:migrate`.
- Precompile assets:

  ```bash
  bundle exec rails assets:precompile
  ```

### 2. Deployment Steps
Deploy to the production server using your preferred method (e.g., Capistrano, Docker, or Heroku).

#### Example for Heroku
If deploying to Heroku, follow these steps:

```bash
heroku create
git push heroku main
heroku run rails db:migrate
```

---

## CI/CD

This application includes GitHub Actions workflows for Continuous Integration. Each pull request triggers:

1. **Rubocop**: Ensures code quality and style adherence.
2. **RSpec**: Runs the test suite to verify application behavior.
3. **Build Verification**: Ensures the application builds successfully.

Refer to the `.github/workflows/` directory for the configuration files.

---

## Update Instructions

### 1. Update Gems
Keep your gems up to date:

```bash
bundle update
```

### 2. Update JavaScript Dependencies
Update Yarn packages:

```bash
yarn upgrade
```

### 3. Apply Migrations
After pulling new changes, apply any pending migrations:

```bash
rails db:migrate
```

---

## Troubleshooting

### Common Issues

- **Database Connection Error**: Ensure PostgreSQL is running locally and that the credentials in `config/database.yml` are correct.
- **Missing Dependencies**: Run `bundle install` and `yarn install` to ensure all dependencies are installed.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
