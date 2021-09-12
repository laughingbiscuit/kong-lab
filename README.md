# Kong Lab

[![Kong Lab Smoke Tests](https://github.com/laughingbiscuit/kong-lab/actions/workflows/kong-lab.yaml/badge.svg)](https://github.com/laughingbiscuit/kong-lab/actions/workflows/kong-lab.yaml)

Sean's Kong Lab and Handbook

## Dependencies

- `curl`
- some POSIX compliant `sh`
- `docker`
- `git`

## Quickstart

```sh
git clone https://github.com/laughingbiscuit/kong-lab
export KONG_LICENSE="$(cat license.json)"
sh ./kong-lab/scripts/kong-standalone-pg.sh
docker ps
```

## Disclaimer

This is not an official Kong product and as such is not formally supported.
