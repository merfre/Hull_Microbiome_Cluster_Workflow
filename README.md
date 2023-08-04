# Snakemake workflow: Microbiome Cluster Workflow for University of Hull

A Snakemake workflow to analyse long read human microbiome data with steps for general quality control and taxonomy assignment using Kraken2.

## Authors

* Merideth Freiheit (@merfre)

## Usage

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository and, if available, its DOI (see above).

## Installation:

If this is the first time you are using this workflow you must build the environment that it will be running in.

While in the parent directory "~/Microbiome_Cluster_Workflow/" run this code to build the conda environment (this will take some time):

    conda env create -f workflow/envs/environment.yaml

Once this environment is built you can activate it easily whenever you wish to run this workflow

### Step 1: Activate environment

First, always ensure when running workflows on Viper to either submit a batch job or have an interactive job activated by running (you will have to navigate back to this directory):

    interactive

When you are logged onto the high performance computer activate the environment:

    conda activate HMCW

### Step 2: Prepare metadata

To direct the workflow to your samples a metadata file is required. Likely your current method for tracking metadata will suffice; however, the metadata provided to this workflow must be a tab delimited table with each row as a sample and at least 2 specific columns.

One column must be labelled "Run", which contains the name of the run that must be the same as the name of the directory or library containing your samples, and the other must be labelled "Sample_ID", which contains the names of samples you would like to analyze and must be the same as the file name (excluding the file extension). Multiple runs can be analyzed at once my simply listing all the runs and corresponding samples in the same metadata file.

An example of the minimum metadata requirement and type of file necessary can be found here:

    ./config/metadata_example.txt

An example of metadata best practice with a fully detailed file can be found here:

    ./config/seq_test_metadata.tsv

Finally, please place your metadata file in the config directory:

    ./config/

### Step 3: Configure workflow

Once your metadata file is prepared, you must point the workflow to it by editing the configuration file, found here:

    ./config/config.yaml

In this file you will find a line beginning with "metadata_file", please edit the file name in the path listed to the name of your desired metadata file.

    "config/metadata_example.txt" -> "config/seq_test_metadata.txt"

Next, in this same configuration file, edit the parameters for the software to your desired thresholds. Each parameter option includes an explanation of the parameter, default options, and options for adjustment.

Full instructions for configuring this workflow can be found here:

    ./config/README.md

*If you wish to change the Kraken2 database used:*

Be sure to follow instructions in the Kraken2 manual to create your database and then place it (the whole database directory) into this directory:

    ./resources/databases/

Then change the database name in the configuration file by editing this line:

    kraken_db: "resources/databases/kraken2_std_database"

### Step 4:

Once you have configured the workflow, be sure to move your data into the resources directory:

    ./resources

This must be the data you wish analyze with .fastq files, which are named by their sample IDs in the metadata file, contained in folder(s) with the same name as the corresponding run(s) in the metadata file. An example data directory for "metadata_example.txt" can be found here:

    ./resources/s_test_data

Full instructions to set up the required resources for this workflow can be found here:

    ./resources/README.md

### Step 5: Execute workflow

Finally, be sure to navigate back to the main workflow directory:

    ~/Microbiome_Cluster_Workflow/

Execute the workflow locally via

    snakemake --printshellcmds --use-conda --cores 10

If the workflow encounters any errors it will stop running and exit. Be sure to look through the output produced for messages on what cause the error and either make the necessary adjustments or copy the text into a file for @merfre (Merideth Freiheit).

### Step 6: Investigate results

After successful execution, you can create a self-contained interactive HTML report with all results via:

    snakemake --report hmcw_final_report.html

This report can, e.g., be forwarded to your collaborators.
An example (using some trivial test data) can be seen [here](https://cdn.rawgit.com/snakemake-workflows/rna-seq-kallisto-sleuth/master/.test/report.html).

###Add git instructions!!!
