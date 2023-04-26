### Rules to assign taxonomy using kraken2 and create report of kraken2 results ###

configfile: "config/config.yaml"

### Run kraken2 to assign taxonomy

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

### Create recentrifuge report of kraken2 results

rule recentrifuge_kraken:
  #conda:
    #"../workflow/envs/environment.yaml"
  input:
    kraken = expand("results/kraken2/{path}_kraken.krk", path=PATHS),
    nodes = "resources/databases/taxdump/nodes.dmp"
  output:
    report("results/recentrifuge/all_samples_kraken.html", caption="report/kraken2_recentrifuge.rst", category="Recentrifuge")
  params:
    taxdump = directory("resources/databases/taxdump"),
    scoring_scheme = config['scoring_scheme'],
    minscore = config['minscore'],
    rcf_input_directory = directory("results/kraken2")
  shell:
    "rcf -a -n {params.taxdump} -k {params.rcf_input_directory} -o {output} \
    -s {params.scoring_scheme} -y {params.minscore}"
    # rentrifuge command then the 2 inputs and specified output
    # first input is the taxonomy from kraken database, second is kraken2 output
    # this is the taxdump required and will make the taxdump rule run first
