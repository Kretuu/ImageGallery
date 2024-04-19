# Image Gallery

### Run in production mode

In order to run the app in production you need to have Docker and Docker compose, ruby and bundler installed on your machine.
All commands need to be executed from repository root directory.

1. Install gems

```
bundle install
```

2. Create master key and credentials to encrypt the app.

```
rails credentials:edit
```

3. Create `.env` in root directory and fill with following variables.
Please replace everything which is in brackets `<...>`.

```
RAILS_ENV=production
POSTGRES_HOST=db
POSTGRES_USER=<Put here username of your choice>
POSTGRES_PASSWORD=<Put here password of your choice>
RAILS_MASTER_KEY=<Put here contents of config/master.key generated in previous step>
```

4. If you are using MacOS on Silicon processor, you may need to run this command

```
bundle lock --add-platform aarch64-linux
```

5. Build and run the code using following command. App will be built and run
 in detached mode which means it will run in the background.

```
docker compose build && docker compose -p gallery up -d
```

6. In order to stop the app you can just use

```
docker compose -p gallery down -v
```

### Run tests

You need to have Ruby installed on your machine. Run following commands
from the root directory of this app.

1. Install all gems needed to run the app

```
bundle install
```

2. You can run tests with the command
```
rspec spec
```