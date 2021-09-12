#!/bin/sh

set -e
set -x

# cleanup
docker rm -f kong-lab-ee kong-lab-database
docker network rm kong-lab-net || true

## setup
docker pull kong/kong-gateway:2.5.0.0-alpine
docker tag kong/kong-gateway:2.5.0.0-alpine kong-ee

## create network
docker network create kong-lab-net

## start db
docker run -d --name kong-lab-database \
  --network=kong-lab-net \
  -p 5432:5432 \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  -e "POSTGRES_PASSWORD=kong" \
  postgres:9.6

sleep 10

## bootstrap db
docker run --rm --network=kong-lab-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-lab-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PASSWORD=password" \
  kong-ee kong migrations bootstrap

sleep 2

## start kong
docker run -d --name kong-lab-ee --network=kong-lab-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-lab-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 8001:8001 \
  -p 8444:8444 \
  -p 8002:8002 \
  -p 8445:8445 \
  -p 8003:8003 \
  -p 8004:8004 \
  kong-ee

sleep 10

## add license
curl -i -X POST http://localhost:8001/licenses \
  -d payload="$(echo $KONG_LICENSE)"

sleep 2

## enable portal
echo "KONG_PORTAL_GUI_HOST=localhost:8003 KONG_PORTAL=on kong reload exit" \
   | docker exec -i kong-lab-ee /bin/sh

sleep 2

curl -f -X PATCH --url http://localhost:8001/workspaces/default \
     --data "config.portal=true"

# check the status is OK
curl -q http://localhost:8001/status

echo "Successfully reached end of script"
