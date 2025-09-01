# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ilazar <ilazar@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/08/26 15:32:02 by ilazar            #+#    #+#              #
#    Updated: 2025/08/26 15:59:48 by ilazar           ###   ########.fr        #
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
