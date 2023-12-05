### Script for alpha diversity analyses of CAT and Kraken2 results ###

library(vegan)
# package required for calculating alpha and beta diversities
library(dplyr)
# various commands to manipulate data frames
library(tibble)
# for `rownames_to_column` and `column_to_rownames`

## Load and transform data

kraken2_results <- read.table(file = snakemake@input[[1]], sep = '\t', header = TRUE, row.names = 1)

tax_level = snakemake@params[[1]]

kraken2_tax_level <- select(kraken2_results, ends_with("kraken_report"), all_of(tax_level))
# Separate samples and genus and species levels

tax_level_pos <- ncol(kraken2_tax_level)
# Determine the column number of the taxonomy level

kraken2_tax_level <- kraken2_tax_level[!(is.na(kraken2_tax_level[tax_level_pos]) | kraken2_tax_level[tax_level_pos]==" "),]

row.names(kraken2_tax_level) <- make.names(kraken2_tax_level[,tax_level], unique=TRUE)

columns_remove <- c(which(colnames(kraken2_tax_level)==tax_level))

kraken2_tax_level <- kraken2_tax_level[-columns_remove]

if(ncol(kraken2_tax_level) > 1)
{
  kraken2_tax_level <- kraken2_tax_level[,order(colnames(kraken2_tax_level))]
  # order the columns by sample names for colors on plot
} else
{
  kraken2_tax_level <- kraken2_tax_level
}

## Alpha diversity table

invsimpson <- diversity(t(kraken2_tax_level),index = "invsimpson")
invsimpson <- data.frame(t(invsimpson))
row.names(invsimpson) <- "invsimpson"

evenness <- eventstar(t(kraken2_tax_level))
evenness <- data.frame(t(evenness))
evenness <- evenness[rownames(evenness) == "Estar",]
row.names(evenness) <- "evenness"

shannon <- diversity(t(kraken2_tax_level), index="shannon")
shannon <- data.frame(t(shannon))
row.names(shannon) <- "shannon"

alpha_div_table <- rbind(invsimpson,evenness,shannon)

## Save alpha diversity table

write.table(alpha_div_table, file = snakemake@output[[1]], row.names=TRUE, sep="\t")