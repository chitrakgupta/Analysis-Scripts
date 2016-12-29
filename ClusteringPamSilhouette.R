#!/usr/bin/R

# The objective is to cluster a series of 4-dimensional vectors where the optimal number of clusters is unknown.

# A series of clustering is performed, each time with a different number of clusters. Average silhouette function is calculated and dumped into a data file. The optimal number of clusters should give the highest average silhouette function.

library(cluster)

dat <- readLines("dataToClustr.dat")
dataToClust <- data.frame(dat[2:length(dat)])

# Define the start, end and step size of loop for number of clusters. Note that this is not being done in a for-loop, but "lapply" command of R.
start <- 2
stop <- 16
step <- 2

t <- proc.time()
silList <- lapply(seq(start,stop,step),
function(i) {
   index <- ((i-start)/step)+1
   summary(silhouette(pam(dataToClust,i)))$avg.width
})
print(proc.time()-t)

silDat <- cbind(seq(start,stop,step), silList)
colnames(silDat) <- c("nClust","Silhouette")
write.table(silDat, file = "SilhouetteResults.dat")

#plot(seq(2,10,2), sapply(seq(2,16,2), function(i) summary(silhouette(pam(dataToClust,i)))$avg.width))

