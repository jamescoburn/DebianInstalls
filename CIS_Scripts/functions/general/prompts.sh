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

SELECT_PROFILE()
{
    profile_options="L1S L1W L2S L2W"
    request_profile()
    {
        # Print options to std-out
        echo -e "Please enter the number for the desired profile: \n\t1: L1S - Level 1 Server\n\t2: L1W - Level 1 Workstation\n\t3: L2S - Level 2 Server\n\t4: L2W - Level 2 Workstation"

        read -p "Profile: " p
        profile_input=$(echo $p | tr '[:lower:]' '[:upper:]')

        case $profile_input in
            1|L1S)
                run_profile="L1S"
                ;;
            2|L1W)
                run_profile="L1W"
                ;;
            3|L2S)
                run_profile="L2S"
                ;;
            4|L2W)
                run_profile="L2W"
                ;;
            *)
                echo -e "\n::Error selecting profile: $profile_input::"
                request_profile
                ;;
        esac
	}
	#if run_profile doesn't exist, or isn't set to something from profile_options, prompt for user selection
    if [ -z "$run_profile" ]; then
        request_profile
    else
        if ! echo "$profile_options" | grep -q "$run_profile"; then
            request_profile
        fi
    fi
}