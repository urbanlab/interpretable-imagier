# Interpretable Imagier

## Docker usage
### Use dev docker image
```
docker compose --profile dev  up -d
docker cp dev-interpretable-imagier:/app/node_modules ./
docker compose down

docker compose --profile dev up
```

### Add a npm package using docker
```
docker compose up -d
docker compose exec dev-interpretable-imagier npm install <package>
docker compose down
```
### Build npm static files
'''
docker compose up -d
docker exec dev-interpretable-imagier npm run build
docker cp dev-interpretable-imagier:/app/build ./build
docker compose down
'''