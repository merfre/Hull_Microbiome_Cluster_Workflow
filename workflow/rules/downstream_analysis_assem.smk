### Script to perform some downstream analyses of microbiome data for assembled contigs ###

configfile: "config/config.yaml"

### Perform alpha diversity calculations in R for assembled contigs

rule alpha_diversity_assem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_assem_allsamples.tsv"
  output:
    "results/downstream/alpha_div_table_assem.tsv"
  params:
    tax_level = "genus_species"
  script:
    "scripts/alpha_diversity.R"

### Perform beta diversity calculations in R for assembled contigs

rule beta_diversity_assem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_assem_allsamples.tsv"
  output:
    "results/downstream/beta_pca_assem.pdf"
  params:
    tax_level = "genus_species"
  script:
    "scripts/beta_div_pca.R"