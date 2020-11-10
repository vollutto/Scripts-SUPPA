#Runing quantification
salmon quant -i /gpfs/scratch/bsc08/bsc08381/PSI/Ensembl_hg19_salmon_index -l ISF --validateMappings --gcBias \
-1 /gpfs/projects/bsc82/shared_projects/iPC/IGTP/data/RNA-seq/HB/RNA_11_GGCTAC_L000_R1_001.C34BYACXX.fastq.gz \
-2 /gpfs/projects/bsc82/shared_projects/iPC/IGTP/data/RNA-seq/HB/RNA_11_GGCTAC_L000_R2_001.C34BYACXX.fastq.gz \
-p 4 -o /gpfs/scratch/bsc08/bsc08381/PSI/Salmon_output/controles/RNA11


