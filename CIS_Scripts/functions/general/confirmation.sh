CONFIRM()
{
	read -p "Do you want to continue? y/n [n]: " -r
	RSP=$(echo "$REPLY" | tr '[:lower:]' '[:upper:]')
	if [[ ! $RSP =~ ^(YES|Y)$ ]]
	then
		echo "You responded with: $RSP exiting... " | tee -a "$LOG" 2>> "$ELOG"
		echo "- $(date +%D-%H:%M:%S) - user responded with $RSP - exiting Build Kit" | tee -a "$LOG" 2>> "$ELOG"
		exit 0
	else
		echo "You responded with: $RSP continuing... " | tee -a "$LOG" 2>> "$ELOG"
		echo "- $(date +%D-%H:%M:%S) - user responded with $RSP - continuing" | tee -a "$LOG" 2>> "$ELOG"
	fi
}
# End of Confirm user wants to continue