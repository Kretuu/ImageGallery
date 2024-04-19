# Image Gallery

### Run in production mode

In order to run the app in production you need to have Docker and Docker compose installed on your machine.
All commands need to be executed from repository root directory.

1. Create master key and credentials to encrypt the app.

```
rails credentials:edit
```

2. Create `.env` in root directory and fill with following variables.
Please replace everything which is in brackets `<...>`.

```
RAILS_ENV=production
POSTGRES_HOST=db
POSTGRES_USER=<Put here username of your choice>
POSTGRES_PASSWORD=<Put here password of your choice>
RAILS_MASTER_KEY=<Put here contents of config/master.key generated in previous step>
```

3. Build and run the code using following command. App will be built and run
 in detached mode which means it will run in the background.

```
sudo docker compose build && sudo docker compose -p gallery up -d
```

4. In order to stop the app you can just use

```
sudo docker compose -p gallery down -v
```
