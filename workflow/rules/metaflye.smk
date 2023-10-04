### Rule to assemble nanopore reads with metaflye ###

configfile: "config/config.yaml"

### Convert samples from fastq to fasta with seqkit

rule fasta_conversion:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    "results/preprocessing/trimmed_filtered/{PATHS}_trimmed_filtered.fastq"
  output:
    "results/preprocessing/fasta_converted/{PATHS}_trimmed_filtered.fasta"
  shell:
    "seqkit fq2fa {input} -o {output}"

### Assemble reads into contigs using metaflye

rule metaflye:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    "results/preprocessing/fasta_converted/{PATHS}_trimmed_filtered.fasta"
  output:
    directory = directory("results/preprocessing/flye_results/{PATHS}"),
    fasta = "results/preprocessing/flye_results/{PATHS}/assembly.fasta"
    # requires fasta in output to be input for next rules
  params:
    read_type = config['read_type'],
    min_overlap = config['minimum_overlap']
  shell:
    """
    flye {params.read_type} {input} --out-dir {output.directory} --meta \
    --min-overlap {params.min_overlap}
    """
    # output is assembly.fasta and assembly information in txt in directory

# add info to report and stats report

### Post assembly reports

rule assembly_stat_report:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    expand("results/preprocessing/flye_results/{path}/assembly.fasta", path=PATHS)
  output:
    report = report("results/qc_reports/assembly_stat_report.tsv", caption="report/assembly_stat_reports.rst", category="QC reports")
  shell:
    "seqkit stats {input} -a -T > {output.report}"
    # flag -a denotes all statistics, including quartiles of seq length, sum_gap, N50
    # -T output in machine-friendly tabular format
