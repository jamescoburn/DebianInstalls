BANR()
{
	echo ""
	echo ""
	echo "     ######################################################## "
	echo "     #  CIS Linux Build Kit for Debian Linux 11             # "
	echo "     #  This Linux Build Kit works in conjunction with the  # "
	echo "     #  CIS Debian Linux 11 Benchmark v1.0.0                # "
#	echo "     #  This script is the property of:                     # "
#	echo "     #  Center for Internet Security (CIS)                  # "
	echo "     ######################################################## "
	echo ""
	echo ""
}
# End of print bannor to Screen

WARBNR()
{
	echo ""
	echo ""
	echo "  *************************************************************** "
	echo "  *******WARNING*******WARNING*******WARNING*******WARNING******* "
	echo "  *************************************************************** "
	echo "  * *                                                         * * "
	echo "  * *    This Linux Build Kit makes changes to your system    * * "
	echo "  *W*    These changes could cause loss of functionality!     *W* "
	echo "  *A*                                                         *A* "
	echo "  *R*    Please ensure that this Linux Build Kit is tested    *R* "
	echo "  *N*    in your testing environment before running it on a   *N* "
	echo "  *I*    production system.                                   *I* "
	echo "  *N*                                                         *N* "
	echo "  *G*    Failure to employ proper testing may lead to         *G* "
	echo "  * *    service interruption!                                * * "
	echo "  * *                                                         * * "
	echo "  *************************************************************** "
	echo "  *******WARNING*******WARNING*******WARNING*******WARNING******* "
	echo "  *************************************************************** "
	echo ""
	echo ""
	CONFIRM
}
# End of Warning Banner