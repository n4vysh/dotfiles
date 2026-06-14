#!/bin/sh

# NOTE: Grafana Cloud authz token format:
#       `Basic <base64 encoded "instance-id:api-key">`
#       https://grafana.com/docs/grafana-cloud/send-data/otlp/send-data-otlp/
#
# ```sh
# read -s grafana_cloud_instance_id
# read -s grafana_cloud_api_key
# printf \
#   '%s:%s' \
#   "$grafana_cloud_instance_id" \
#   "$grafana_cloud_api_key" |
#   base64 -w 0 |
#   sed 's/^/Basic /' |
#   gopass insert opencode/otlp_authz_header
# ```
printf \
	'{"Authorization":"%s"}' \
	"$(gopass cat opencode/otlp_authz_header)"
