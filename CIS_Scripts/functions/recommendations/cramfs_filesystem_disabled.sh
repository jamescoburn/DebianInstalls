function cramfs_filesystem_disabled()
{
echo "- $(date +%d-%b-%Y' '%T) - Starting $RNA" | tee -a "$LOG" 2>> "$ELOG"
XCCDF_VALUE_REGEX="cramfs"
filesystem_disabled
}