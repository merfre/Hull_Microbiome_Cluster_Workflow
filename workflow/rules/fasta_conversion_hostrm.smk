### Rule to convert sample files from fastq to fasta for next analyses with host filtered out ###

configfile: "config/config.yaml"

### Convert samples from fastq to fasta with seqkit

rule fasta_conversion_hostrm:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    "results/preprocessing/trimmed_filtered_hostrm/{PATHS}_trimmed_filtered_hostrm.fastq"
  output:
    "results/preprocessing/fasta_converted/{PATHS}_cleaned.fasta"
  shell:
    "seqkit fq2fa {input} -o {output}"