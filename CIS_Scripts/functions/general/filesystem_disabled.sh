function filesystem_disabled()
{
# Check and if nessassary remediate if filesystem is loadable
echo "- $(date +%d-%b-%Y' '%T) - starting verify $XCCDF_VALUE_REGEX module is not loadable" | tee -a "$LOG" 2>> "$ELOG"
module_loadable_fix
case "$?" in
	101) 
		test1=passed
		echo "PASSED: \"$output\"" | tee -a "$LOG" 2>> "$ELOG"
		;;
	102) 
		test1=failed
		echo "Failed: \"$output\"" | tee -a "$LOG" 2>> "$ELOG"
		;;
	103) 
		test1=remediated
		echo "Remediated: \"$output\"" | tee -a "$LOG" 2>> "$ELOG"
		;;
	*)
		echo "module_loadable_fix failed" | tee -a "$LOG" 2>> "$ELOG"
		return "${XCCDF_RESULT_FAIL:-102}"
		;;
esac
echo "- $(date +%d-%b-%Y' '%T) - completed verify $XCCDF_VALUE_REGEX module is not loadable" | tee -a "$LOG" 2>> "$ELOG"

echo "- $(date +%d-%b-%Y' '%T) - starting verify $XCCDF_VALUE_REGEX module is not loaded" | tee -a "$LOG" 2>> "$ELOG"
module_loaded_fix
case "$?" in
	101) 
		test2=passed
		echo "PASSED: \"$output\"" | tee -a "$LOG" 2>> "$ELOG"
		;;
	102) 
		test2=failed
		echo "Failed: \"$output\"" | tee -a "$LOG" 2>> "$ELOG"
		;;
	103) 
		test2=remediated
		echo "Remediated: \"$output\"" | tee -a "$LOG" 2>> "$ELOG"
		;;
	*)
		echo "module_loaded_fix failed" | tee -a "$LOG" 2>> "$ELOG"
		return "${XCCDF_RESULT_FAIL:-102}"
		;;
esac
echo "- $(date +%d-%b-%Y' '%T) - completed verify $XCCDF_VALUE_REGEX module is not loaded" | tee -a "$LOG" 2>> "$ELOG"
# Set return code and return
passing=""
if [ "$test1" = passed ] && [ "$test2" = passed ]; then
	echo "Recommendation \"$RNA\" No remediation required" | tee -a "$LOG" 2>> "$ELOG"
	return "${XCCDF_RESULT_PASS:-101}"
elif [ "$test1" != failed ] && [ "$test2" != failed ]; then
	echo "Recommendation \"$RNA\" successfully remediated" | tee -a "$LOG" 2>> "$ELOG"
	return "${XCCDF_RESULT_PASS:-103}"
else
	echo "Recommendation \"$RNA\" remediation failed" | tee -a "$LOG" 2>> "$ELOG"
	return "${XCCDF_RESULT_FAIL:-102}"
fi
}