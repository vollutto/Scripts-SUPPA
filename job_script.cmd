#!/bin/bash
#SBATCH --job-name="salom_index"
#SBATCH --workdir=.
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00
#SBATCH --qos=debug

module load SALMON

export LD_LIBRARY_PATH=~/SUPPA/salmon/lib:$LD_LIBRARY_PATH
salmon index -t ~/SUPPA/hg19_EnsenmblGenes_sequence_ensenmbl.fasta -i ~/SUPPA/Ensembl_hg19_salmon_index
