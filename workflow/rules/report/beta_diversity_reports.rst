PCA plot of beta diversity based on {{ snakemake.config["taxonomy_level"] }} level assignment from Kraken2 results.


Each point is labelled with the sample ID and each sample has a corresponding color for comparison across tools.



Assigner parameters:



Kraken2 was run with a confidence level of {{ snakemake.config["kraken_confidence"] }} and using the Kraken2 database "{{ snakemake.config["kraken_db"] }}"