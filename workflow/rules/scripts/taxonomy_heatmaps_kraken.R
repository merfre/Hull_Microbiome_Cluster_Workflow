### Script for creating species heatmap ###

library(ggplot2)
# for creating plots
library("RColorBrewer")
# for plot colors
library("gplots")
# for creating plots
library(tibble)
# for `rownames_to_column` and `column_to_rownames`
library(dplyr)
# various commands to manipulate data frames

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

### Heatmap

lwid = c(1,4)
lhei = c(1,5,1)
lmat = rbind(c(0,3),c(2,1),c(0,4))
# Moves the key to the bottom of the figure and ensures the whole title and heatmap are included

pdf(snakemake@output[[1]], width=25,height=20)

par(mar=c(5.1, 1, 1, 15))

heatmap.2(t(data.matrix(kraken2_tax_level)), col = brewer.pal(n = 9, name = "Blues"),
          main = paste("Species heatmap from Kraken2 results"),
          margins = c(10,13),lmat = lmat, lwid = lwid, lhei = lhei, labCol = rownames(kraken2_tax_level),
          key=T, key.title = "",key.ylab = "", key.xlab = "Read counts", xlab=tax_level,
          trace="none", Rowv=FALSE, Colv=FALSE,
          cexCol = 1.25, cexRow = 1.5, srtCol = 45)

dev.off()
