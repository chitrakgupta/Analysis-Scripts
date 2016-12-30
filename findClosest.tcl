# Get two groups of atoms. For each atom in group 2, measure distance from center of group 1. Then return the 3 least distances.

# This is sourced in getListOfClosest.tcl

proc closest {sel1 sel2 dist frame} {
	set distList [list]
# Create list of distances
	foreach ind [$sel2 get index] {
		set thisInd [atomselect top "index $ind"]
		$thisInd frame $frame
		$thisInd update
		set thisDist [veclength [vecdist [measure center $thisInd] [measure center $sel1]]]
		lappend distList $thisDist
	}

	set sortedList [lsort -real -increasing $distList]
	set out "[lindex $sortedList 0] [lindex $sortedList 1] [lindex $sortedList 2]"
	return $out
}
