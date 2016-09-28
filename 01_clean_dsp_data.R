# clean the drosophila speciation project data file
# KMS Sept 2016

################################################## 
# libraries
##################################################  

library("tidyverse")
library("readxl")

################################################## 
# get the data
################################################## 

# download the data
download.file("http://www.drosophila-speciation-patterns.com/data/RAW_dataset_Jan_06_2012.xlsx", 
							destfile = "data/dsp/RAW_dataset_Jan_06_2012.xlsx")

# read in raw excel file
dsp_xl <- read_excel("data/dsp/RAW_dataset_Jan_06_2012.xlsx")

################################################## 
# basic cleaning
################################################## 

# remove blank "NA" columns
dsp_xl <- dsp_xl[,!is.na(names(dsp_xl) == "NA")] 

# remove weird first line
dsp_xl <- dsp_xl[-1, ]

# fix rownames
rownames(dsp_xl) <- NULL

# fixing hard to work with names
names(dsp_xl)[1:4] <- c("sp1", "sp2", "complete", "sympatric") 

# enforcing dataframe 
dsp_xl <- data.frame(dsp_xl)

# remove rows containing grouping data
# tbd: convert to column instead
dsp_xl <- dsp_xl %>%
	filter(!is.na(sp2))

# counting "-" as NA
dsp_xl <- dsp_xl %>%
	lapply(function(x) gsub("-", NA, x)) %>%
	data.frame

# remove columns that are completely blank (e.g. "coming soon!")
# or have fewer than 5 obs
keep_columns <- dsp_xl %>%
	lapply(function(x)!is.na(x)) %>% data.frame %>%
	.[, colSums(. != 0) > 5] %>%
	names

dsp_xl <- dsp_xl %>%
	select(which(names(.) %in% keep_columns))

# write out
write.table(dsp_xl, "data/dsp/dsp_clean.txt", row.names = FALSE)


