### Rule to run MetaBAT2 and create bins of reads ###

configfile: "config/config.yaml"

### Run MetaBAT2 to perform binning of assembled contigs

rule metabat2:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    "results/preprocessing/flye_results/{PATHS}/assembly.fasta"
  output:
    "results/preprocessing/metabat2_binning/{PATHS}_bins/bin.1.fa"
  params:
    MetaBAT2_min_size = config['MetaBAT2_min_size'],
    MetaBAT2_max_perc = config['MetaBAT2_max_perc'],
    MetaBAT2_min_edge = config['MetaBAT2_min_edge'],
    MetaBAT2_max_edge = config['MetaBAT2_max_edge'],
    MetaBAT2_tnf_prob = config['MetaBAT2_tnf_prob'],
    MetaBAT2_min_coverage = config['MetaBAT2_min_coverage'],
    MetaBAT2_min_coverage_sum = config['MetaBAT2_min_coverage_sum'],
    MetaBAT2_min_bin_size = config['MetaBAT2_min_bin_size'],
    output_prefix = "results/preprocessing/metabat2_binning/{PATHS}_bins/bin"
  shell:
    """
    metabat2 -i {input} --minContig {params.MetaBAT2_min_size} \
    --maxP {params.MetaBAT2_max_perc} --minS {params.MetaBAT2_min_edge} \
    --maxEdges {params.MetaBAT2_max_edge} --pTNF {params.MetaBAT2_tnf_prob} \
    --minCV {params.MetaBAT2_min_coverage} \
    --minCVSum {params.MetaBAT2_min_coverage_sum} \
    --minClsSize {params.MetaBAT2_min_bin_size} -o {params.output_prefix}
    """
    # Descriptions for all parameters are in the configuration file next to the parameters
    # input is the fasta format of filered and trimmed samples
    # output is a base file name and path for each bin. The default output is fasta format.
    # Use -l option to output only contig names.
    # Set --noAdd when added small or leftover contigs cause too much contamination.
    # if the optional summary file is being used the flag is -a depth.txt