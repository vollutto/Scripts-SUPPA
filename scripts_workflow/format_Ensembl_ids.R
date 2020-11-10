#!/usr/bin/Rscript
# With this script, running from bash, we want to format the ids for the Ensembl transcripts for running SUPPA

# Parse command line arguments
CHARACTER_command_args <- commandArgs(trailingOnly=TRUE)
CHARACTER_command_args[1] <- "/gpfs/scratch/bsc08/bsc08381/PSI/Expression/casos_tpm.txt"
#CHARACTER_command_args[1] <- "/gpfs/scratch/bsc08/bsc08381/PSI/Expression/controles_tpm.txt"

if (length(CHARACTER_command_args)== 1){
  file <- read.table(file=CHARACTER_command_args[1])
  ids <- unlist(lapply(rownames(file),function(x)strsplit(x,"\\|")[[1]][2]))
  rownames(file) <- ids
  write.table(file,file=paste0(substr(CHARACTER_command_args[1],1,nchar(CHARACTER_command_args[1])-4),"_formatted.txt"),
              quote=FALSE, row.names=TRUE,col.names=TRUE,sep="\t")
}
