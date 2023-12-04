### Rules to convert Kraken2 report results to R-friendly tabular format with biom of unassembled reads ###

configfile: "config/config.yaml"

### Convert kraken reports to biom format of unassembled reads

rule kraken_to_biom_unassem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    expand("results/kraken2/{path}_unassem_kraken_report.txt", path=PATHS)
  output:
    "results/biom/kraken2_unassem_allsamples.biom"
  shell:
    "kraken-biom {input} --fmt hdf5 -o {output}"
    # --fmt indicates the output format desired, --max is assigned reads will be recorded only if they are at or below max rank, Default: O
    # and the ranks are D,P,C,O,F,G,S

### Convert kraken2 biom files to tsv and modify for analysis in R of unassembled reads

rule biom_to_tsv_unassem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_unassem_allsamples.biom"
  output:
    report("results/biom/kraken2_unassem_allsamples.tsv", caption="report/kraken2_allsamples.rst", category="Kraken2")
  shell:
    """
    biom convert -i {input} -o {output} --to-tsv --header-key taxonomy;
    # --header-key taxonomy is required to include the taxonomy and not just OTU ID
    sed -i -e "1d" {output} # to remove first line
    sed -i 's/\#//g' {output}; # to make column names not commented out
    sed -i 's/; s__/ /g' {output}; # to form the entire species name
    sed -i 's/; /\t/g' {output}; # to separate each taxonomy level into its own column
    sed -i 's/[kpcofg]__//g' {output} # to remove the taxonomy level indicators
    sed -i 's/taxonomy/kingdom\tphyla\tclass\torder\tfamily\tgenus_species/g' {output} # add column names for all tax levels
    """
