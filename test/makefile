 @if [ -n "$$(docker network ls --format "{{.Name}}" | grep -vE '^(bridge|host|none)$$')" ]; then docker network ls --format "{{.Name}}" | grep -vE '^(bridge|host|none)$$' | xargs -r docker network rm; echo " ✔ Done"; \
	@ 	else echo " ✘ No networks other than default found"; fi
