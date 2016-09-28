################################################## 
# libraries
##################################################  

source("https://bioconductor.org/biocLite.R")
biocLite("SRAdb")

library("SRAdb")
browseVignettes("SRAdb")
library(SRAdb)

################################################## 
# initializing SRAdb
##################################################  

# source custom sraDB function

sqlfile <- "data/SRAmetadb.sqlite.gz"

# download sql file (this is a weird hack getSRAdbfile() doesn't work...)
if(!file.exists(sqlfile)){
	
	download.file("https://dl.dropboxusercontent.com/u/51653511/SRAmetadb.sqlite.gz", destfile = sqlfile)
	
}

sra_con <- dbConnect(SQLite(),sqlfile)
