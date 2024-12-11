NETWORK = srcs_network

IMAGE = srcs-nginx \
	srcs-mariadb

CONTAINER = nginx \
	mariadb

VOLUMES = mariadb_vol

all:
	docker compose -f ./srcs/docker-compose.yml up -d --build

re: clean all

clean:
	docker compose -f ./srcs/docker-compose.yml down --volumes --remove-orphans
	
	@echo "① Stopping and deleting containers"
	@for container in $(CONTAINER); do \
		if [ -n "$$(docker ps -a --format="{{.Names}}" --filter=name="$$container")" ]; then \
			docker down $$container; \
			echo "  ➥ Stopped $$container"; \
			docker rm $$container; \
			echo "  ➥ Suppressed $$container"; \
		fi \
	done ;
	@echo " ✔ Done";

	@echo "② Suppressing docker images"
	@for image in $(IMAGE); do \
		if [ -n "$$(docker images -qa --filter=reference="$$image")" ]; then \
			docker image rm $$(docker images --filter=reference="$$image" --format="{{.ID}}"); \
			echo "  ➥ Suppressed $$image"; \
		fi \
	done; \
	echo " ✔ Done";

# Add specified volume destruction plz
	@echo "③ Suppressing docker volumes"
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q) && echo " ✔ Done"; \
		else echo " ✘ No volumes found"; fi
	
	@echo "④ Suppressing docker networks"
	@if [ -n "$$(docker network ls --format "{{.Name}}" | grep -E '$(NETWORK)')" ]; \
		then docker network ls --format "{{.Name}}" | grep -E '$(NETWORK)' | xargs -r docker network rm; \
		echo " ✔ Done"; \
	else echo " ✘ No networks other than default found"; fi

.PHONY: all re clean