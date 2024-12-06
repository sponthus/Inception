$(NETWORK) : srcs_network

$(IMGS) : nginx-container

all:
	docker compose -f ./srcs/docker-compose.yml up -d --build

re:
	docker compose -f srcs/docker-compose.yml up -d --build

clean:
	@echo "Stopping and deleting containers"
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa) && docker rm $$(docker ps -qa) && echo " ✔ Done"; \
		else echo " ✘ No containers up"; fi

	@echo "Suppressing docker images"
	@if [ -n "$$(docker images -qa)" ]; then docker image rm $$(docker images -qa) && echo " ✔ Done"; \
		else echo " ✘ No images up"; fi

	@echo "Suppressing docker volumes"
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q) && echo " ✔ Done"; \
		else echo " ✘ No volumes found"; fi
	
	@echo "Suppressing docker networks"

# Marche pas supprime rien avec -xE et tout avec -E LOL
	@if [ -n "$$(docker network ls --format "{{.Name}}" | grep -E '$(NETWORK)')" ]; \
		then docker network ls --format "{{.Name}}" | grep -E '$(NETWORK)' | xargs -r docker network rm; \
		echo " ✔ Done"; \
		else echo " ✘ No networks other than default found"; fi

.PHONY: all re clean