#${} = controles o casos se cambia el nombre 

#Running the suppa quantification
python /gpfs/scratch/bsc08/bsc08381/PSI/SUPPA/multipleFieldSelection.py -i /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/${}/*/quant.sf \
-k 1 -f 4 -o /gpfs/scratch/bsc08/bsc08381/PSI/Expression/${}_tpm.txt

#Running the events
python /gpfs/scratch/bsc08/bsc08381/PSI/SUPPA/suppa.py generateEvents -i Homo_sapiens.GRCh37.75.formatted.gtf -o Events/ensembl_hg19.events -e SE SS MX RI FL -f ioe -p

#Put all the events in the same file
bash awk.sh 

#Running R : changing the ids of the expression file
Rscript /gpfs/scratch/bsc08/bsc08381/PSI/SUPPA/scripts/format_Ensembl_ids.R Expression/${}_tpm.txt

#Creating all the events in the same file
python /gpfs/scratch/bsc08/bsc08381/PSI/SUPPA/suppa.py psiPerEvent -i Events/ensembls_hg19.events.ioe -e Expression/${}_tpm_formatted.txt -o Expression/${}_events
