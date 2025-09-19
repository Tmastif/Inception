# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ilazar <ilazar@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/08/26 15:32:02 by ilazar            #+#    #+#              #
#    Updated: 2025/09/03 14:39:17 by ilazar           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #



SECRETS := \
if [ ! -f ./srcs/.env ] || [ ! -d ./secrets/ ]; then \
	echo "secrets and or .env is missing. Provide these files and try again"; \
	exit 1; \
fi

all : up

up : 
	@$(SECRETS)
	docker compose -f ./srcs/docker-compose.yml up -d

down : 
	@$(SECRETS)
	docker compose -f ./srcs/docker-compose.yml down

stop :
	@$(SECRETS)
	docker compose -f ./srcs/docker-compose.yml stop

start : 
	@$(SECRETS)
	docker compose -f ./srcs/docker-compose.yml start

status : 
	@docker ps

logs :
	@docker compose -f ./srcs/docker-compose.yml logs

# Deletes volumes too
downvol :
	@docker compose -f ./srcs/docker-compose.yml down -v

clean :
	@echo "Removing unused containers.."
	@sudo docker system prune -a --volumes -f

# Full delete. inc folders on host. inc unused containers
downfull :
	make down
	@echo "Deleting web and database folders..."
	@sudo rm -rf /home/$(USER)/data/web /home/$(USER)/data/database
	make clean

# Create the bind mount folders on host and give permissions
folders :
	@if [ ! -d "/home/$(USER)/data/database" ]; then \
		mkdir -p /home/$(USER)/data/database && \
		chown -R $(USER):$(USER) /home/$(USER)/data/database && \
		chmod -R 755 /home/$(USER)/data/database && \
		echo "Created /home/$(USER)/data/database"; \
	fi

	@if [ ! -d "/home/$(USER)/data/web" ]; then \
		mkdir -p /home/$(USER)/data/web && \
		chown -R $(USER):$(USER) /home/$(USER)/data/web && \
		chmod -R 755 /home/$(USER)/data/web && \
		echo "Created /home/$(USER)/data/web"; \
	fi

# Verfiy if folders exist on host
checkfolders :
	@if [ ! -d "/home/$(USER)/data/web" ]; then \
		echo "Web folder doesn't exist"; \
	else \
		echo "##Web##"; \
		ls -la "/home/$(USER)/data/web"; \
	fi
	@if [ ! -d "/home/$(USER)/data/database" ]; then \
			echo "Database folder doesn't exist"; \
	else \
		echo "##Database##"; \
		ls -la "/home/$(USER)/data/database"; \
	fi


secrets :
	@echo "Copying the secrets folder and .env file"
	@cp -r ~/secrets/ .
	@mv ./secrets/.env ./srcs/.env
	@ls -l && ls -la ./srcs/

delsecrets :
	@echo "Deleting secrets folder and .env file"
	@rm -rf ./secrets && rm ./srcs/.env
	@ls -l && ls -la ./srcs

# Full build of folders and containers as new
upfull : folders
	@$(SECRETS)
	docker compose -f ./srcs/docker-compose.yml build --no-cache
	@make up

# Full clean and build of folders and containers as new
restart : downfull
	make upfull


# Debugging:
#exwp :
#	@docker compose -f ./srcs/docker-compose.yml exec -it wordpress sh
