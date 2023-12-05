### Script to perform some downstream analyses of microbiome data for unassembled reads ###

configfile: "config/config.yaml"

### Perform alpha diversity calculations in R for unassembled reads

rule alpha_diversity_unassem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_unassem_allsamples.tsv"
  output:
    "results/downstream/alpha_div_table_unassem.tsv"
  params:
    tax_level = "genus_species"
  script:
    "scripts/alpha_diversity.R"

### Perform beta diversity calculations in R for unassembled reads

rule beta_diversity_unassem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_unassem_allsamples.tsv"
  output:
    "results/downstream/beta_pca_unassem.pdf"
  params:
    tax_level = "genus_species"
  script:
    "scripts/beta_div_pca.R"