function module_loadable_fix()
{
output=""
output=$(modprobe -n -v "$XCCDF_VALUE_REGEX")

if modprobe -n -v "$XCCDF_VALUE_REGEX" | grep -Eq "^\s*install\s+\/bin\/(true|false)\b"; then
	output=$(modprobe -n -v "$XCCDF_VALUE_REGEX")
#	echo "PASSED, \"$output\""
	return "${XCCDF_RESULT_PASS:-101}"
else
	echo "install $XCCDF_VALUE_REGEX /bin/true" >> /etc/modprobe.d/"$XCCDF_VALUE_REGEX".conf
	output=$(modprobe -n -v "$XCCDF_VALUE_REGEX")
	if modprobe -n -v "$XCCDF_VALUE_REGEX" | grep -Eq "^\s*install\s+\/bin\/(true|false)\b"; then
#		echo "PASSED, \"$output\""
		return "${XCCDF_RESULT_PASS:-103}"
	else
#		echo "Failed: \"$output\""
    	return "${XCCDF_RESULT_FAIL:-102}"
    fi
fi
}

function module_loaded_fix()
{

}
