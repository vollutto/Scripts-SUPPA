#!/bin/bash
#SBATCH --job-name="greasy"
#SBATCH --workdir=.
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --tasks-per-node=8
#SBATCH --ntasks=96
#SBATCH --time=12:00:00

module load SALMON 

/apps/GREASY/latest/INTEL/IMPI/bin/greasy my_runs.txt

