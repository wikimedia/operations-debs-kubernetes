#
# Regular cron jobs for the kubernetes package
#
0 4	* * *	root	[ -x /usr/bin/kubernetes_maintenance ] && /usr/bin/kubernetes_maintenance
