### Script for beta diversity analyses of CAT and Kraken2 results ###

library(vegan)
# package required for calculating alpha and beta diversities
library(stringi)
# required for ggfortify and ggplot2
library(RColorBrewer)
# package for colors for plots
library(ggplot2)
# package for making plots
library(ggfortify)
# package that ggplot2 requires for making PCA plot
library(gdata)
# To combine the taxonomy assigner results for distance matrices
library(ggrepel)
library(dplyr)

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

kraken2_tax_level <- kraken2_tax_level[,order(colnames(kraken2_tax_level))]
# order the columns by sample names for colors on plot

## Beta diversity PCA plot

kraken_vegd <- vegdist(t(na.omit(kraken2_tax_level)), method="bray", na.rm = TRUE)

kraken_vegpca <- prcomp(kraken_vegd, center=TRUE, scale=TRUE)

# Making plots

pdf(snakemake@output[[1]], width=15,height=10)

autoplot(kraken_vegpca, label=TRUE, label.repel=TRUE,
         main ="PCA of species Beta diversity from results of all taxonomic assigners")

dev.off()
