.PHONY: help build up down restart logs agents agents-down backup restore validate check

help:
	@echo "build        Build the controller image"
	@echo "up           Start Jenkins"
	@echo "down         Stop Jenkins"
	@echo "restart      Restart Jenkins"
	@echo "logs         Follow Jenkins logs"
	@echo "agents       Start the local agent (needs AGENT_SECRET in .env)"
	@echo "agents-down  Stop the local agent"
	@echo "backup       Encrypted backup of jenkins_home"
	@echo "restore      Restore: make restore FILE=backups/xxx.tar.gz.gpg"
	@echo "validate     Validate examples/Jenkinsfile.* against Jenkins"
	@echo "check        Run the security self-check"

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart jenkins

logs:
	docker logs -f jenkins

agents:
	docker compose --env-file .env -f agents/docker-compose.agents.yml up -d

agents-down:
	docker compose --env-file .env -f agents/docker-compose.agents.yml down

backup:
	./scripts/backup.sh

restore:
	./scripts/restore.sh $(FILE)

validate:
	./scripts/validate-jenkinsfiles.sh

check:
	./scripts/security-check.sh
