### Script to perform some downstream analyses of microbiome data for assembled contigs ###

configfile: "config/config.yaml"

### Perform alpha diversity calculations in R for assembled contigs

rule alpha_diversity_assem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_assem_allsamples.tsv"
  output:
    report("results/downstream/alpha_div_table_assem.tsv", caption="report/alpha_diversity_reports.rst", category="Downstream Analyses")
  params:
    tax_level = config['taxonomy_level']
  script:
    "scripts/alpha_diversity.R"

### Perform beta diversity PCA in R for assembled contigs

rule beta_diversity_assem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_assem_allsamples.tsv"
  output:
    report("results/downstream/beta_pca_assem.pdf", caption="report/beta_diversity_reports.rst", category="Downstream Analyses")
  params:
    tax_level = config['taxonomy_level']
  script:
    "scripts/beta_div_pca.R"

### Create heatmap of taxonomies for assembled contigs

rule tax_heatmap_assem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_assem_allsamples.tsv"
  output:
    report("results/downstream/tax_heatmap_assem.pdf", caption="report/tax_heatmap_reports.rst", category="Downstream Analyses")
  params:
    tax_level = config['taxonomy_level']
  script:
    "scripts/taxonomy_heatmaps_kraken.R"

### Taxonomy barplots

rule tax_barplot_assem:
  #conda:
  #"../workflow/envs/environment.yaml"
input:
  "results/biom/kraken2_assem_allsamples.tsv"
output:
  report("results/downstream/tax_barplot_assem.pdf", caption="report/tax_barplot_reports.rst", category="Downstream Analyses")
params:
  tax_level = config['taxonomy_level']
script:
  "scripts/stacked_taxonomy_barplot_kraken.R"