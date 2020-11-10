#Creating all the events in the same file
python /gpfs/scratch/bsc08/bsc08381/PSI/SUPPA/suppa.py diffSplice -m empirical \
-i Events/ensembls_hg19.events.ioe -p Expression/casos_events.psi Expression/controles_events.psi \
-e Expression/casos_tpm_formatted.txt Expression/controles_tpm_formatted.txt \
-a 1000 -l 0.05 -gc -o Expression/diff_empirical

