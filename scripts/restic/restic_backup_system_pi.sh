#!/usr/bin/env bash

if [ -d /media/HDD-Seagate-2TB-Backup/restic-repo ]; then
	# System
	restic \
		--repository-file /root/.restic/restic_repo_name \
		--password-file /root/.restic/restic_pass \
		--host system-ada-pi-server \
		--verbose=2 \
		--compression=max \
		--exclude-caches \
		--one-file-system \
		--exclude=".deleted" \
		--exclude="/proc" \
		--exclude="/sys" \
		--exclude="/dev" \
		--exclude="/run" \
		--exclude="/tmp" \
		--exclude="/var/tmp" \
		--exclude="/var/cache" \
		--exclude="/var/run" \
		--exclude="/lost+found" \
		--exclude="/media" \
		--exclude="/mnt" \
		--exclude="**/.cache" \
		--exclude="**/.node_modules" \
		--exclude="**/.npm" \
		--exclude="**/..Trash" \
		backup /

	 restic \
		--repository-file /root/.restic/restic_repo_name \
		--password-file /root/.restic/restic_pass \
		--host system-ada-pi-server \
		--verbose=2 \
                forget --keep-daily 7 --prune

fi



