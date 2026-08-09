#!/bin/bash

set -euo pipefail
cron_jobs() {
	*/4 * * * * find "health_check.sh" -type f -name "*.sh" | ./health_check.sh
	\n
	0 2 * * * find "log_rotate.sh" -type f -name "*.sh" | ./log_rotate.sh /var/log/journal
	\n
	0 3 * * 0 find "back_up.sh" -type f -name "*.sh" | ./back_up.sh /var/log/apache2 backup1

}
cron_jobs
