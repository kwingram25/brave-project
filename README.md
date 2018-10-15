# Brave Coding Project (SWApi Viewer)

## Development
```
bundle install
rake create:db migrate:db
rails start
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
docker-compose run web rake migrate:db RAILS_ENV=production
# visit http://localhost:3000
```