-include srcs/.env

COMPOSE_PATH = ./srcs/docker-compose.yml

all: up

hosts:
	grep -q "$(DOMAIN_NAME)" /etc/hosts || echo "127.0.0.1\t$(DOMAIN_NAME)" | sudo tee -a /etc/hosts > /dev/null

prepare:
	mkdir -p $(VOLUMES_PATH)/wordpress
	mkdir -p $(VOLUMES_PATH)/mariadb

up: prepare
	docker compose -f $(COMPOSE_PATH) up -d --build

down:
	docker compose -f $(COMPOSE_PATH) down

clean:
	docker compose -f $(COMPOSE_PATH) down -v --rmi local --remove-orphans

fclean: clean
	rm -rf $(VOLUMES_PATH)
	docker builder prune

re: fclean all

.PHONY: all prepare up down clean fclean re
