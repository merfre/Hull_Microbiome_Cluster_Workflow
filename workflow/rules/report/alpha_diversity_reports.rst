Table of various alpha diversity measurements based on {{ snakemake.config["taxonomy_level"] }} level assignment from Kraken2 results.



Assigner parameters:



Kraken2 was run with a confidence level of {{ snakemake.config["kraken_confidence"] }} and using the Kraken2 database "{{ snakemake.config["kraken_db"] }}"