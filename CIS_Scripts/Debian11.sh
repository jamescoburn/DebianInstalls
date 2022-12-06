if [ ! "$BASH_VERSION" ] ; then
	exec /bin/bash "$0" "$@"
fi

# Set global variables
BDIR="$(dirname "$(readlink -f "$0")")"
FDIR=$BDIR/functions
RECDIR="$FDIR"/recommendations
GDIR="$FDIR"/general
LDIR=$BDIR/logs
RDIR=$BDIR/backup
DTG=$(date +%m_%d_%Y_%H%M)
mkdir $LDIR/$DTG
mkdir $RDIR/$DTG
LOGDIR=$LDIR/$DTG
BKDIR=$RDIR/$DTG
LOG=$LOGDIR/CIS-LBK_verbose.log
SLOG=$LOGDIR/CIS-LBK.log
ELOG=$LOGDIR/CIS-LBK_error.log
FRLOG=$LOGDIR/CIS-LBK_failed.log
MANLOG=$LOGDIR/CIS-LBK_manual.log
passed_recommendations="0"
failed_recommendations="0"
remediated_recommendations="0"
not_applicable_recommendations="0"
excluded_recommendations="0"
manual_recommendations="0"
skipped_recommendations="0"
total_recommendations="0"

# Load functions (Order matters)
for func in "$GDIR"/*.sh; do
	[ -e "$func" ] || break
	. "$func"
done
for func in "$RECDIR"/*.sh; do
	[ -e "$func" ] || break
	. "$func"
done

# Clear the screen for output
clear

# Display the build kit banner
BANR

# Ensure script is being run as root
ROOTUSRCK

# Display CIS Linux Build Kit warning banner
WARBNR

#run_profile=L2S # Uncomment this line to provide profile to be run manually
# Profile Options:
# L1S - For Level 1 Server
# L1W - For Level 1 Workstation
# L2S - For Level 2 Server
# L2W - For Level 2 Workstation
# Have user select profile to run
SELECT_PROFILE
# Recommediations This is where a BM specific script begins.

# Generated for specific Benchmark

# 1 - Initial Setup
# 1.1 - Filesystem Configuration
# 1.1.1 - Disable unused filesystems
RN="1.1.1.1"
RNA="Ensure mounting of cramfs filesystems is disabled"
profile="L1S L1W"
REC=""
total_recommendations=$((total_recommendations+1))
runrec