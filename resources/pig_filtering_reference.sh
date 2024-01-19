### Script to retrieve, unzip, and combine refrence genomes for host filtering ###

## Retrieve pig reference genome

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/003/025/GCF_000003025.6_Sscrofa11.1/GCF_000003025.6_Sscrofa11.1_genomic.fna.gz

gzip -d GCF_000003025.6_Sscrofa11.1_genomic.fna.gz

## Retrieve human reference genome

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.fna.gz

gzip -d GCF_000001405.40_GRCh38.p14_genomic.fna.gz

## Combine references into fasta file

cat GCF_000003025.6_Sscrofa11.1_genomic.fna GCF_000001405.40_GRCh38.p14_genomic.fna > databases/host_references/pig_host_reference.fasta
