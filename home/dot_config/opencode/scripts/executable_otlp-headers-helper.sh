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
authz_header=$(gopass cat opencode/otlp_authz_header) || exit "$?"
if [ "$authz_header" = "" ]; then
	printf '%s\n' 'OTLP Authorization header is empty.' >&2
	exit 1
fi

printf '{"Authorization":"%s"}\n' "$authz_header"
