# Brave Coding Project (SWApi Viewer)

JSON viewer and PostgreSQL-backed caching system for [SWApi](https://swapi.co) resources

## Development
Install PostgreSQL locally
```
bundle install
rake create:db migrate:db
rails s
# visit http://localhost:3000
```

## Test
```
rspec spec
```

## Build
```
docker-compose build
docker-compose up
# In another terminal:
docker-compose run web rails create:db migrate:db assets:precompile RAILS_ENV=production
# visit http://localhost:3000
```
