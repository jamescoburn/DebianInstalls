runrec()
{
	recommendation_applicable
	oc1="$?"
	if [ "$oc1" = "101" ]; then
		$REC
		output_code="$?"
	else
		output_code="$oc1"
	fi
	remediation_output
	return
}

recommendation_applicable()
{
	if [ -s "$BDIR"/exclusion_list.txt ]; then
		grep -Eq "^\s*$RN\b" "$BDIR"/exclusion_list.txt && return "${XCCDF_RESULT_FAIL:-105}"
	elif [ -s "$BDIR"/not_applicable_list.txt ]; then
		grep -Eq "^\s*$RN\b" "$BDIR"/not_applicable_list.txt && return "${XCCDF_RESULT_FAIL:-104}"
	fi
#	if [ -z "$run_profile" ]; then
#		select_profile
#	fi
	case "$run_profile" in
		L1S)
			if echo "$profile" | grep -Eq 'L1S\b'; then
				return "${XCCDF_RESULT_PASS:-101}"
			else
				return "${XCCDF_RESULT_FAIL:-107}"
			fi
			;;
		L2S)
			if echo "$profile" | grep -Eq 'L[12]S\b'; then
				return "${XCCDF_RESULT_PASS:-101}"
			else
				return "${XCCDF_RESULT_FAIL:-107}"
			fi
			;;
		L1W)
			if echo "$profile" | grep -Eq 'L1W\b'; then
				return "${XCCDF_RESULT_PASS:-101}"
			else
				return "${XCCDF_RESULT_FAIL:-107}"
			fi
			;;
		L2W)
			if echo "$profile" | grep -Eq 'L[12]W\b'; then
				return "${XCCDF_RESULT_PASS:-101}"
			else
				return "${XCCDF_RESULT_FAIL:-107}"
			fi
			;;
		*)
			return "${XCCDF_RESULT_FAIL:-102}"
			;;
	esac
}

remediation_output()
{
	case "$output_code" in
		101)
			passed_recommendations=$((passed_recommendations+1))
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - PASSED - Remediation not required" | tee -a "$SLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			;;
		102)
			failed_recommendations=$((failed_recommendations+1))
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - FAILED - Recommendation failed remediation" | tee -a "$SLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			# Send Failed Recommendations to the FRLOG
			echo "*****************************************************************" | tee -a "$FRLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$FRLOG" 2>> "$ELOG"
			echo " - FAILED - Recommendation failed remediation" | tee -a "$FRLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$FRLOG" 2>> "$ELOG"
			;;
		103)
			remediated_recommendations=$((remediated_recommendations+1))
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - REMEDIATED - Recommendation successfully remediated" | tee -a "$SLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			;;
		104)
			not_applicable_recommendations=$((not_applicable_recommendations+1))
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - N/A - Recommendation is non applicable" | tee -a "$SLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			;;
		105)
			excluded_recommendations=$((excluded_recommendations+1))
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - EXCLUDED - Recommendation on the excluded list" | tee -a "$SLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			;;
		106)
			manual_recommendations=$((manual_recommendations+1))
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - MANUAL - Recommendation needs to be remediated manually" | tee -a "$SLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			# Send Manual recommendations to the MANLOG
			echo "*****************************************************************" | tee -a "$MANLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$MANLOG" 2>> "$ELOG"
			echo " - MANUAL - Recommendation needs to be remediated manually" | tee -a "$MANLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$MANLOG" 2>> "$ELOG"
			;;
		107)
			skipped_recommendations=$((skipped_recommendations+1))
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - SKIPPED - Recommendation not in selected profile" | tee -a "$SLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			;;
		201)
			remediated_recommendations=$((remediated_recommendations+1))
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - REMEDIATED - Recommendation remediation run" | tee -a "$SLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			;;
		*)
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - $RN - $RNA -" | tee -a "$SLOG" 2>> "$ELOG"
			echo " - ERROR - Output code not set" | tee -a "$SLOG" 2>> "$ELOG"
			echo "*****************************************************************" | tee -a "$SLOG" 2>> "$ELOG"
			return "${XCCDF_RESULT_FAIL:-108}"
			;;
	esac
	output_code=""
}