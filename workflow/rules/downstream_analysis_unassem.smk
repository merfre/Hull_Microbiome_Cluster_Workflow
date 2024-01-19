### Script to perform some downstream analyses of microbiome data for unassembled reads ###

configfile: "config/config.yaml"

### Perform alpha diversity calculations in R for unassembled reads

rule alpha_diversity_unassem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_unassem_allsamples.tsv"
  output:
    report("results/downstream/alpha_div_table_unassem.tsv", caption="report/alpha_diversity_reports.rst", category="Downstream Analyses")
  params:
    tax_level = config['taxonomy_level']
  script:
    "scripts/alpha_diversity.R"

### Perform beta diversity calculations in R for unassembled reads

rule beta_diversity_unassem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_unassem_allsamples.tsv"
  output:
    report("results/downstream/beta_pca_unassem.pdf", caption="report/beta_diversity_reports.rst", category="Downstream Analyses")
  params:
    tax_level = config['taxonomy_level']
  script:
    "scripts/beta_div_pca.R"

### Create heatmap of taxonomies for unassembled reads

rule tax_heatmap_unassem:
  #conda:
  #"../workflow/envs/environment.yaml"
  input:
    "results/biom/kraken2_unassem_allsamples.tsv"
  output:
    report("results/downstream/tax_heatmap_unassem.pdf", caption="report/tax_heatmap_reports.rst", category="Downstream Analyses")
  params:
    tax_level = config['taxonomy_level']
  script:
    "scripts/taxonomy_heatmaps_kraken.R"

### Taxonomy barplots

rule tax_barplot_unassem:
  #conda:
  #"../workflow/envs/environment.yaml"
input:
  "results/biom/kraken2_unassem_allsamples.tsv"
output:
  "results/downstream/tax_barplot_unassem.pdf"
params:
  tax_level = config['taxonomy_level']
script:
  "scripts/stacked_taxonomy_barplot_kraken.R"