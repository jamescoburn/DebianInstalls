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