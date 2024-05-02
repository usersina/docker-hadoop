DOCKER_NETWORK = hadoop_network
ENV_FILE = hadoop.env
VERSION = 2.0.0-hadoop3.3.6-java11

build:
	docker build -t bde2020/hadoop-base:$(VERSION) ./base
	docker build -t bde2020/hadoop-namenode:$(VERSION) ./namenode
	docker build -t bde2020/hadoop-datanode:$(VERSION) ./datanode
	docker build -t bde2020/hadoop-resourcemanager:$(VERSION) ./resourcemanager
	docker build -t bde2020/hadoop-nodemanager:$(VERSION) ./nodemanager
	docker build -t bde2020/hadoop-historyserver:$(VERSION) ./historyserver
	docker build -t bde2020/hadoop-submit:$(VERSION) ./submit

up:
	docker-compose up -d

down:
	docker-compose down

delete:
	docker-compose down -v

shell:
	docker run \
		--rm -it --name temp_hadoop_shell \
		--volume $(PWD)/data:/data \
		--network ${DOCKER_NETWORK} \
		--env-file ${ENV_FILE} \
		bde2020/hadoop-base:$(VERSION) /bin/bash
    
wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(VERSION) hdfs dfs -rm -r /output || true
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(VERSION) hdfs dfs -mkdir -p /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(VERSION) hdfs dfs -copyFromLocal -f /opt/hadoop-3.3.6/README.txt /input/
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(VERSION) hdfs dfs -cat /output/*
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(VERSION) hdfs dfs -rm -r /output
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} bde2020/hadoop-base:$(VERSION) hdfs dfs -rm -r /input

debug:
	@printf "Docker network: ${DOCKER_NETWORK}\n"
	@printf "Environment file: ${ENV_FILE}\n"
	@printf "Hadoop version: ${VERSION}\n"
	@printf "Current directory: $(PWD)\n"
