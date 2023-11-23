### Rules to remove host sequences from the nanopore data ###

configfile: "config/config.yaml"

### Align reads to reference sequences with minimap2

rule minimap2_align_host:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    "results/preprocessing/trimmed_filtered/{PATHS}_trimmed_filtered.fastq"
  output:
    "results/preprocessing/minimap2/{PATHS}_host_alignment.sam"
  params:
    filtering_reference = config['filtering_reference']
  shell:
    "minimap2 -ax map-ont {params.filtering_reference} {input} > {output}"
    # the options -ax map-ont instruct minimap2 to align the remove_host_sequences
    # and specifies that it is nanopore data (rather than pacbio)

### Use samtools to remove the reads that matched the reference

rule remove_host_sequences:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    "results/preprocessing/minimap2/{PATHS}_host_alignment.sam"
  output:
    "results/preprocessing/trimmed_filtered_hostrm/{PATHS}_trimmed_filtered_hostrm.fastq"
  shell:
    "samtools view -buSh -f 4 {input} | samtools fastq - > {output}"
    # -f denotes extracting only reads that match that sam flag (aka un-mapped reads)
    # -b is bam output, -u is uncompressed, -s is sam input, -h is to include the header in the output

### Post host removal QC reports

rule qc_report_hostrm:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    expand("results/preprocessing/trimmed_filtered_hostrm/{path}_trimmed_filtered_hostrm.fastq", path=PATHS)
  output:
    report = report("results/qc_reports/hostrm_qc_report.tsv", caption="report/hostrm_qc_reports.rst", category="QC reports")
  shell:
    "seqkit stats {input} -a -T > {output.report}"
    # flag -a denotes all statistics, including quartiles of seq length, sum_gap, N50
    # -T output in machine-friendly tabular format
