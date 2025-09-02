# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ilazar <ilazar@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/08/26 15:32:02 by ilazar            #+#    #+#              #
#    Updated: 2025/09/02 23:20:03 by ilazar           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


all : up

up : 
	@docker compose -f ./srcs/docker-compose.yml up -d

down : 
	@docker compose -f ./srcs/docker-compose.yml down

stop : 
	@docker compose -f ./srcs/docker-compose.yml stop

start : 
	@docker compose -f ./srcs/docker-compose.yml start

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
	@docker compose -f ./srcs/docker-compose.yml down -v
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

# Full build of folders and containers as new
upfull : folders
	@docker compose -f ./srcs/docker-compose.yml build --no-cache
	make up

# Full clean and build of folders and containers as new
restart : downfull
	make upfull

exwp :
	@docker compose -f ./srcs/docker-compose.yml exec -it wordpress sh