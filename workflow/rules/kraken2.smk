### Rules to assign taxonomy using Kraken2 ###

configfile: "config/config.yaml"

### Run Kraken2 to assign taxonomy

rule kraken2:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    "results/preprocessing/trimmed_filtered/{PATHS}_trimmed_filtered.fastq"
  output:
    report = "results/kraken2/{PATHS}_kraken_report.txt",
    kraken = "results/kraken2/{PATHS}_kraken.krk"
  params:
    kraken_db = config['kraken_db'],
    confidence = config['kraken_confidence'],
    rcf_input_directory = directory("results/kraken2")
  shell:
    """
    kraken2 --db {params.kraken_db} {input} --confidence {params.confidence} \
    --report {output.report} --output {output.kraken};
    cp {output.kraken} {params.rcf_input_directory};
    """
    # use taxonomy names, use threads from config file, path to database is in the config file too
    # Needs to be .krk output for recentrifuge

