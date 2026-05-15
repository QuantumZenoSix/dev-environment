#!/usr/bin/env bash

if [ -d /mnt/myhdd-backup/restic-repo ]; then
	# System
    sudo restic \
		--repository-file /home/zeno/.restic/restic_repo_name \
		--password-file /home/zeno/.restic/restic_pass \
		--host system-monad \
		--verbose=2 \
		--compression=max \
		--exclude-caches \
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

	 sudo restic \
		--repository-file /home/zeno/.restic/restic_repo_name \
		--password-file /home/zeno/.restic/restic_pass \
		--host system-monad \
		--verbose=2 \
                forget --keep-daily 7 --prune

fi



