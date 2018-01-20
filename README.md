# ChaacServer

To setup:

  * Run initially with `docker-compose up -d`
  * Create and migrate your database with `docker-compose run web mix ecto.create && docker-compose run web mix ecto.migrate`
  * Start Phoenix endpoint with `docker-compose up`

Now you can check routes using `docker-compose run web mix phx.routes`

