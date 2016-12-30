# Analysis-Scripts
This is a repository for the analysis scripts I commonly use for my PhD research.

In all-atom molecular dynamics simulation, our starting point is the (X,Y,Z) coordinates of every single atom in our system (which we call "conformation" of the molecule). During the simulation, we calculate the (X,Y,Z) coordinate of every atom as a function of time. The resulting simulation trajectory is a collection of "frames", where each frame contains the conformation at a given time point.

Most of the analysis scripts work on this collection of frames. For example, in the cation pi orientation script(s), we are looking for aromatic groups and choline atoms within 7 angstrom of it. If found, we are measuring the orientation of the aromatic ring with respect to the vertical axis (defined to be along the Z-axis).

In the find closest script(s), we are looking for 3 nearest neighbors of a given atom, and measuring its distances from these 3 nearest neighbors.

In the helices/count stretch script(s) we are first looking for helical residues. A peptide is a sequence of residues, each of which has two "dihedral angles" that can be measured for a given conformation. These dihedral angles (called "Phi" and "Psi") needs to be within a specific range for the residue to be termed "helical".

The "FindHelices.tcl" script goes over the entire trajectory and creates a numerical data file. The data file is a n X m matrix of 0 and 1 where n is the number of frames in the trajectory and m is the number of residues in the peptide. A 1 represents a helical residue and 0 represents a non-helical residue. The "CountStretch.py" analyzes this data file.
