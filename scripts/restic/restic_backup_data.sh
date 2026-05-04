#!/usr/bin/env bash

if [ -d /media/HDD-Seagate-2TB-Backup/restic-repo ]; then
	# HDD backup
	restic \
		--repository-file /root/.restic/restic_repo_name \
		--password-file /root/.restic/restic_pass \
		--host data-primary \
		--verbose=2 \
		--compression=max \
		--exclude=".deleted" \
		backup /media/HDD-Seagate-1TB-Primary

	 # HDD prune
	 restic \
		--repository-file /root/.restic/restic_repo_name \
		--password-file /root/.restic/restic_pass \
		--host data-primary \
		--verbose=2 \
                forget --keep-daily 7 --prune

fi



