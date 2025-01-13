NETWORK = srcs_network

IMAGE = nginx \
	mariadb \
	wordpress

CONTAINER = nginx \
	mariadb \
	wordpress

VOLUMES = srcs_mariadb \
	srcs_wordpress

all: up

re: fclean all

env:
	sh script.sh
	echo ".env created, feel free to modify informations if needed"

up: 
	@mkdir -p /home/sponthus/data
	@mkdir -p /home/sponthus/data/wordpress
	@mkdir -p /home/sponthus/data/mariadb
	docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml down 

clean:
	docker compose -f ./srcs/docker-compose.yml down --rmi all -v --remove-orphans;

manual_clean: clean_network

clean_containers:
	@echo "① Stopping and deleting containers"
	@if [ ! "$$(docker ps -q)" ]; then \
		echo " ✘ No container found"; \
	else \
		for container in $(CONTAINER); do \
			if [ -n "$$(docker ps -a --format="{{.Names}}" --filter=name="$$container")" ]; then \
				docker stop $$container && \
				echo " ➥ Stopped $$container" && \
				docker rm $$container && \
				echo " ➥ Suppressed $$container"; \
			fi \
		done; \
		echo " ✔ Done"; \
	fi

clean_images: clean_containers
	@echo "② Suppressing docker images"
	@if [ ! "$$(docker image ls -q)" ]; then echo " ✘ No images found"; fi
	@for image in $(IMAGE); do \
		if [ -n "$$(docker images -qa --filter=reference="$$image")" ]; then \
			docker image rm $$(docker images --filter=reference="$$image" --format="{{.ID}}"); \
			echo "  ➥ Suppressed $$image"; \
		fi; \
	done
	@echo " ✔ Done";

clean_volumes: clean_images
	@echo "③ Suppressing docker volumes"
	@if [ ! "$$(docker volume ls -q)" ]; then echo " ✘ No volumes found"; \
	else \
		for volume in $(VOLUMES); do \
			if [ -n "$$(docker volume ls -q --filter=name="$$volume")" ]; then \
				docker volume rm -f $$volume; \
				echo "  ➥ Suppressed $$volume"; \
			fi; \
		done; \
	fi

clean_network: clean_volumes
	@echo "④ Suppressing docker networks"
	@if [ -n "$$(docker network ls --format "{{.Name}}" | grep -E '$(NETWORK)')" ]; \
		then docker network ls --format "{{.Name}}" | grep -E '$(NETWORK)' | xargs -r docker network rm; \
		echo " ✔ Done"; \
	else \
		echo " ✘ No networks other than default found"; \
	fi

fclean: clean
	@echo "⑤ Deep clean = Prune :";
	@echo " ✔ Images";
	@docker image prune -f
	@echo " ✔ Volumes";
	@docker volume prune -f
	@echo " ✔ Network";
	@docker network prune -f
	@echo " ✔ Builder";
	@docker builder prune -f
	@echo " ✔ System";
	@docker system prune -a -f --volumes
	sudo rm -rf /home/sponthus/data

subject:
	docker stop $$(docker ps -qa)
	docker rm $$(docker ps -qa)
	docker rmi -f $$(docker images -qa)
	docker volume rm $$(docker volume ls -q)
	docker network rm $$(docker network ls -q)

.PHONY: all re clean fclean down up subject env