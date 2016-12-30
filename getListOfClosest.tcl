# This script takes the residue number, residue name, and atom name. Then creates a file that lists the distances of the 3 nearest atoms from the given atom, for every frame in the simulation trajectory.

proc listOfClosest {orient num name atom dist} {
	set filename "$orient-$name$num-ListOfNeighbors.dat"
	# check if this is already done
	 if [ file exist $filename ] {
                puts "File already exists"
                break
        }
	set outF [open $filename w]
	set nf [molinfo top get numframes]
	set sel [atomselect top "protein and resid $num and resname $name and name $atom"]
	set temp [atomselect top "resname POPC and name P and within $dist of ([$sel text])"]
	
	# source the findClosest file.
	source findClosest.tcl

	# Loop over every frame in simulation trajectory
	for {set i 0} {$i < $nf} {incr i 1} {
		$sel frame $i
		$sel update
		$temp frame $i
		$temp update
		if { [$temp num] < 3 } {
			# This happens when there were not enough atoms in selection.
			puts "Too low distance cutoff in frame $i. Exiting"
			break
		}
		set outLine [closest $sel $temp $dist $i]
		puts $outF "$i $outLine"
	}
	close $outF
}
