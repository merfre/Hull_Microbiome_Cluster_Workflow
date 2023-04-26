Interactive report for all samples created by Recentrifuge based on taxonomy assignment performed by Kraken2.
Parameters for Recentrifuge to create this report were using the {{ snakemake.config["scoring_scheme"] }} scoring scheme and a minimum score of {{ snakemake.config["minscore"] }}.


Taxonomy assignment was performed by Kraken2 with a confidence level of {{ snakemake.config["kraken_confidence"] }} and using the Kraken2 database "{{ snakemake.config["kraken_db"] }}"
