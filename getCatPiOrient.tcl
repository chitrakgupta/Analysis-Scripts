# This script calculates the orientation of the aromatic ring with respect to the vertical axis.

# Takes residue name, residue number and frame number as input. Returns the angle

# This file is sourced in getCationPi.tcl


proc CatPiOrient {res resno i} {
# First step is to determine the 3 atoms that define the plane of the aromatic ring. The atom names are different for the 3 aromatic residues.

	if {$res == "TRP"} {
# 	Tryptophan. Select CE3, CZ2, and CH2 to define aromatic plane
		set sel1 [atomselect top "resname $res and resid $resno and name CE3"]
		set sel2 [atomselect top "resname $res and resid $resno and name CZ2"]
		set sel3 [atomselect top "resname $res and resid $resno and name CH2"]
	} elseif {$res == "TYR" || $res == "PHE"} {
#	Tyrosine or Phenylalanine. Select CG,CD2, and CE1 to define aromatic plane
		set sel1 [atomselect top "resname $res and resid $resno and name CG"]
		set sel2 [atomselect top "resname $res and resid $resno and name CD2"]
		set sel3 [atomselect top "resname $res and resid $resno and name CE1"]
	} else {
#	Something wrong with the selection. Because if it isn't one of the above, it isn't aromatic.
		puts "Residue $res $resno does not look to be aromatic. Exiting"
		break
	}

	$sel1 frame $i
	$sel1 update
	$sel2 frame $i
	$sel2 update
	$sel3 frame $i
	$sel3 update

	# vector 1, between atoms 2 and 3.
	set vec1 [vecsub [measure center $sel2] [measure center $sel3]]
	# vector 2, between atoms 1 and 2.
	set vec2 [vecsub [measure center $sel1] [measure center $sel2]]
	# cross product of these two vectors. This one is perpendicular to the plane of the aromatic ring.
	set aroVec [veccross $vec1 $vec2]
	# unit vector along this direction.
	set unitAroVec [vecscale $aroVec [expr 1.0/[veclength $aroVec]]]
	# this is the vertical axis as per our convention.
	set z {0 0 1}
	set angleRadian [expr acos([vecdot $unitAroVec $z])]
	set angleDegree [expr $angleRadian * 180 / 3.14]

	# important to prevent memory leak in VMD.
	$sel1 delete
	$sel2 delete
	$sel3 delete

	return $angleDegree
}
