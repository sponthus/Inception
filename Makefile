NETWORK = srcs_network

IMAGE = srcs-nginx

CONTAINER = nginx-container

VOLUMES = 

all:
	docker compose -f ./srcs/docker-compose.yml up -d --build

re:
	docker compose -f srcs/docker-compose.yml up -d --build

clean:
	@echo "① Stopping and deleting containers"
	@if [ -n "$$(docker ps | grep -E '$(CONTAINER)')" ]; \
		then \
			for container in $(CONTAINER); do \
				docker stop $$container; \
				echo "  ➥ Stopped"; \
				docker rm $$container; \
				echo "  ➥ Suppressed"; \
			done; \
		echo " ✔ Done"; \
		else echo " ✘ No container up"; fi

	@echo "② Suppressing docker images"
	@if [ -n "$$(docker images -a | grep -E '$(IMAGE)')" ]; \
	then \
		for image in $(IMAGE); do \
			docker image rm $$(docker images --filter=reference="$$image" --format="{{.ID}}"); \
		done; \
	echo " ✔ Done"; \
	else echo " ✘ No images up"; fi

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