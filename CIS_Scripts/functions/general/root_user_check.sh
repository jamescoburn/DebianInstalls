ROOTUSRCK()
{
	echo "- $(date +%D-%H:%M:%S) - Starting user check" | tee -a "$LOG" 2>> "$ELOG"
	echo "- $(date +%D-%H:%M:%S) -  Verifying that this Remediation Kit is being run as the root user" | tee -a "$LOG" 2>> "$ELOG"
	echo "- $(date +%D-%H:%M:%S) -  ### Script will exit if it's not being run as root ###" | tee -a "$LOG" 2>> "$ELOG"
	if [ "$(id -u)" = 0 ]; then
		echo "- $(date +%D-%H:%M:%S) - User is root - continuing..." | tee -a "$LOG" 2>> "$ELOG"
	else
        echo "- $(date +%D-%H:%M:%S) - User is NOT root - exiting..." | tee -a "$LOG" 2>> "$ELOG"
		exit 1
	fi
	echo "- $(date +%D-%H:%M:%S) - root user verification successful" | tee -a "$LOG" 2>> "$ELOG"
}
# End of Root user check