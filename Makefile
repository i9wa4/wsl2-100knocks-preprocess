MAKEFLAGS += --warn-undefined-variables
SHELL := /usr/bin/env bash
.SHELLFLAGS := -euo pipefail -o posix -c


.PHONY: setup-step1
setup-step1: write-wsl-conf apt docker-install prompt-restart

.PHONY: setup-step2
setup-step2: docker-systemd setup-knock setup-done


.PHONY: prompt-restart
prompt-restart:
	@echo "Shutdown Ubuntu and restart WSL2."

.PHONY: setup-done
setup-done:
	@echo "Setup for 100-knocks is done!"

.PHONY: write-wsl-conf
write-wsl-conf:
	# enable systemd
	echo "[boot]" | sudo tee /etc/wsl.conf
	echo "systemd=true" | sudo tee -a /etc/wsl.conf

.PHONY: apt
apt:
	sudo apt update
	sudo apt upgrade -y

.PHONY: docker-install
docker-install:
	# https://docs.docker.com/engine/install/ubuntu/
	# Uninstall old versions
	for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove "$${pkg}"; done
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install -y ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	# Add the repository to Apt sources:
	echo \
	  "deb [arch="$$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  "$$(. /etc/os-release && echo "$${VERSION_CODENAME}")" stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	# Install the Docker packages
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	# https://docs.docker.com/engine/install/linux-postinstall/
	# If you're running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.
	# sudo groupadd docker
	sudo usermod -aG docker "$${USER}"

.PHONY: docker-systemd
docker-systemd:
	# configure the daemon with systemd
	sudo systemctl daemon-reload
	sudo systemctl enable docker
	sudo systemctl start docker

.PHONY: setup-knock
setup-knock:
	mkdir -p "$${HOME}"/work/git/
	cd "$${HOME}"/work/git/ \
	&& git clone https://github.com/The-Japan-DataScientist-Society/100knocks-preprocess

.PHONY: start-knock
start-knock:
	cd "$${HOME}"/work/git/100knocks-preprocess \
	&& docker compose up -d --wait

.PHONY: stop-knock
stop-knock:
	cd "$${HOME}"/work/git/100knocks-preprocess \
	&& docker compose stop
