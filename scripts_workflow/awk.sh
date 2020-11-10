touch Events/ensembls_hg19.events.ioe
for i in $(ls Events/*strict.ioe); do
	awk '
    		FNR==1 && NR!=1 { while (/^<header>/) getline; }
    		1 {print}
	' $i >> Events/ensembls_hg19.events.ioe
done
