# This script takes in residue name and residue number ("orient" represents which molecule we are dealing with). Then looks for cation pi interaction, which is defined when distance between aromatic ring center and choline atom is <= 7.0 (in angstrom).

# For all such cation pi interactions, it measures the orientation of the aromatic ring with respect to the vertical axis. This is done in the getCatPiOrient.tcl script.

proc CationPi {res resno orient} {
	# Source the getCatPiOrient.tcl file
	source getCatPiOrient.tcl
	set nf [molinfo top get numframes]
	set filename "$orient-$res$resno-CationPi.dat"
	if [ file exist $filename ] {
		# Check if this is already done
		puts "File already exists"
		break
	}
	set outFile [open $filename w]

	# Select aromatic ring
	set aromaticRing [atomselect top "resid $resno and resname $res and not backbone and (carbon or nitrogen)"]

	# Select choline atoms near the given aromatic ring
	set cholInVic [atomselect top "(resname POPC and name N) and within 7 of (resid $resno and resname $res and not backbone and (carbon or nitrogen))"]

	# Loop over every frame in simulation trajectory
	for {set i 0} {$i < $nf} {incr i 1} {
		$aromaticRing frame $i
		$aromaticRing update
		$cholInVic frame $i
		$cholInVic update

		if { [$cholInVic num] > 0} {
			foreach indi [$cholInVic get index] {
				set thisLipid [atomselect top "index $indi"]
				set lipIndex [$thisLipid get resid]
				set dist [veclength [vecdist [measure center $thisLipid] [measure center $aromaticRing]]]

		# If this distance is > 7.0, we need not worry about orientation.
				if {$dist <= 7.0} {
					# Now measure the orientation
					set angleWithZ [CatPiOrient $res $resno $i]
					set out "$i $lipIndex $dist $angleWithZ"
					puts $outFile $out
					flush $outFile
				}

				$thisLipid delete
			}
		}

	}
	close $outFile
}
