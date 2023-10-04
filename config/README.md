# Hull Microbiome Cluster Workflow Configuration

In this directory 'config' is the main configuration file 'config.yaml' which is used for specifying the samples to analyse and what parameters to use throughout the workflow.


## Reading the configuration file

This file is split into four sections:


1. The first is at the top of the file and contains general information for the workflow, including the location of the desired libraries, the metadata file for the samples, and the software environment to use for analysis.


2. The second section is titled 'Analysis options' and allows certain steps in analysis to be toggled on or off. Each analysis option is described below its title and includes which software is used for that step. When the word 'True' is next to the analysis option it will be included in the next workflow run. When 'False' is next to the option it will be excluded and the software described in that step will not be used for the next run.


3. The next section is below the second and labeled 'Database locations'. In this section the location of the reference databases for analysis is specified. For this workflow, there is one reference required, a  Kraken2 database for taxonomy assignment.


4. The final section, located below the third, is titled 'Parameters'. This section contains the list of adjustable parameters used in this workflow. Each parameter has a title, a value assigned to it, and a description. The parameters are organized by the software that uses them. For instance, fastp is used for initial quality control and has six adjustable parameters for its performance.


## Setting up the configuration file

Prior to using this workflow there is only one entry that must be specified before use and that is the path to the "metadata_file" for the samples you wish to analyze.

### Metadata file requirements

The metadata file supplied for this workflow should be placed into this config directory and in a table format that is tab delimited. Ideally this is a file you already have written to track your experiments and likely only requires changes to the column names for compatibility with this workflow. At a minimum this table needs to contain rows for each sample you wish to analyze and columns that specify:

1. The run it was sequenced in a column titled "Run", which should also be the name of the directory or library this sample is located in in the "resources" folder of this workflow.

2. The nanopore barcode of the sample in a column titled "Barcode", which is the barcode number assigned to this sample prior to sequencing and demultiplexed by Guppy.

3. The sample's ID in a column labeled "Sample_ID", which is a unique identifier that will be assigned to this sample's concatenated fastq file and all future results.
