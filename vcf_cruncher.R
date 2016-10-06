# desparation vcf method


system("sed -e 's/#CHROM/CHROM/g' data/vcf/groupXVIII.vcf.recode.vcf")

vcf_file <- file("data/vcf/groupXVIII.vcf.recode.vcf", "r")

outfile <- file('data/snps/groupXVIII.snps', 'w') 

while (length(input <- readLines(vcf_file, n = 5000) > 0)){ 
	
	#filter metadata lines for ##'s
	keep_lines <- input[grep("#", input, invert = TRUE)]
	
	# get the header, if it exists
	if(length(grep("#", input)) > 1){
		
		header_names <- input[max(grep("#", input))] %>%
			strsplit(split = "\t") %>% unlist
		
		header_names[1] <- "CHROM"
		
	}
	
	# format keep lines
	keep_lines <- keep_lines %>%
		strsplit(split = "\t") %>% 
		do.call("rbind", .) %>%
		data.frame
	
	# format genotype fields
	names(keep_lines) <- header_names
	geno_col <- which(header_names == "FORMAT")+1
	keep_lines[geno_col:ncol(keep_lines)]
	
	keep_lines[geno_col:ncol(keep_lines)] <- keep_lines[geno_col:ncol(keep_lines)] %>%
		lapply(geno_convert_list) %>%
		data.frame()
	
	# select columns for output
	
	keep_lines <- keep_lines %>%
		select(-ID, -REF, -ALT, -QUAL, -FILTER, -INFO, - FORMAT) %>% head
	
	print(paste0(min(keep_lines$POS), "...", max(keep_lines$POS)))
	
	writeLines(keep_lines, con = outfile) 
	
} 

close.connection(outfile)
close.connection(vcf_file)


geno_convert <- function(x){
	
	if(str_detect(x, pattern = "\\./\\.")){
		NA
	} else if (str_detect(x, pattern = "0/0")){
		0
	} else if (str_detect(x, pattern = "0/1") | str_detect(x, pattern = "1/0")){
		0.5
	} else{
		1
	}
	
}

geno_convert_list <- function(x){
	as.numeric(sapply(x, geno_convert))
}

readLines(vcf_file, n = 1000)
readLines(vcf_file, n = 5)

