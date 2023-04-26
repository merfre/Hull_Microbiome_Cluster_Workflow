### Rules to convert Kraken2 report results to R-friendly tabular format with biom ###

configfile: "config/config.yaml"

### Convert kraken reports to biom format

rule kraken_to_biom:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/kraken2/{PATHS}_kraken_report.txt"
  output:
    "results/biom/{PATHS}.biom"
  shell:
    "kraken-biom {input} --fmt hdf5 -o {output}"
    # --fmt indicates the output format desired, --max is assigned reads will be recorded only if they are at or below max rank, Default: O
    # and the ranks are D,P,C,O,F,G,S

### Convert kraken2 biom files to tsv and modify for analysis in R

rule biom_to_tsv:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/{PATHS}.biom"
  output:
    "results/kraken2/converted/{PATHS}_kraken_table.tsv"
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
