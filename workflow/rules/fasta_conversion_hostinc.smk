### Rule to convert sample files from fastq to fasta for next analyses with host sequences included ###

configfile: "config/config.yaml"

### Convert samples from fastq to fasta with seqkit

rule fasta_conversion:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    "results/preprocessing/trimmed_filtered/{PATHS}_trimmed_filtered.fastq"
  output:
    "results/preprocessing/fasta_converted/{PATHS}_cleaned.fasta"
  shell:
    "seqkit fq2fa {input} -o {output}"