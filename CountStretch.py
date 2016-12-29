#!/usr/bin/python

# Reads input file name and output file name from user.

# The input file is numerical, has ~20000 lines. Each line is a sequence of 0 and 1. Every line has the exact same number of elements.

# The objective is to calculate 3 quantities: Number of 1's in a line (N), Number of continuous stretches of 1 in a line (Ns), and the length of the longest continuous stretch of 1 (Nc).


import numpy as np

# The following function returns two arrays. First is an array of the lengths of stretches. Second is an array of whether the stretch was for 0 or 1. For example, if input is

# 0,1,0,0,0,1,1,1,0,0,1,1,0,0,1,1,0,0,0,1,0

# Output arrays are: 1, 1, 3, 3, 2, 2, 2, 2, 3, 1, 1   AND
# 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0

def rle(inarray):
	ia = np.array(inarray)
	n = len(ia)
	if n == 0:
		return (None, None)
	else:
		y = np.array(ia[1:] != ia[:-1])
		i = np.append(np.where(y), n - 1)
		z = np.diff(np.append(-1, i))
#		p = np.cumsum(np.append(0,z))[:-1]
		return(z, ia[i])

from sys import argv
filename=argv[1]
outfilename=argv[2]
data = np.loadtxt(filename)

f=open(outfilename, "w")
f.write("#index  Ns	N	Nc\n")
nFrames = len(data)
nRes = len(data[0])

for j in range(0,nFrames):
	z, ia1 = rle(data[j])
	t = []
	for i in range(0,len(z)):
		if (ia1[i] == 1):
			t.append(z[i])
	if (len(t) > 0):
		longestStretch = sorted(t, reverse=True)[0]
	else:
		longestStretch = 0

	f.write(str(j)+"\t"+str(len(t))+"\t"+str(int(sum(data[j])))+"\t"+str(longestStretch)+"\n")

f.close()
