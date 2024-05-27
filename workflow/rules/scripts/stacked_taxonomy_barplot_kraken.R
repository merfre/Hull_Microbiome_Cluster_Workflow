### Script to create side by side stacked barplots of taxonomy ###

library(ggplot2)
# for creating plots
library(tibble)
# for `rownames_to_column` and `column_to_rownames`
library(RColorBrewer)
# for plot colors
library(dplyr)
# various commands to manipulate data frames

## Load files

kraken2_results <- read.table(file = snakemake@input[[1]], sep = '\t', header = TRUE, row.names = 1)

# Select tax level

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

# Order the species by least to most abundant

tax_sums <- data.frame(rowSums(kraken2_tax_level))

kraken2_tax_level_sums <- cbind(kraken2_tax_level, tax_sums)

kraken2_tax_level_sums <- kraken2_tax_level_sums[order(kraken2_tax_level_sums$rowSums.kraken2_tax_level.),]

sum_col <- c(which(colnames(kraken2_tax_level_sums)=="rowSums.kraken2_tax_level."))

kraken2_tax_level_sums <- kraken2_tax_level_sums[-sum_col]

kraken2_plot_table <- data.frame(t(kraken2_tax_level_sums))

## Plot Creation

sample_size <- nrow(kraken2_plot_table)
species_color <- ncol(kraken2_plot_table)
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))

if(species_color > 74)
{
  color=sample(col_vector, species_color, replace=TRUE)
} else
{
  color=sample(col_vector, species_color)
}

all_plot <- data.frame(
  Sample_ID=rep(c(rownames(kraken2_plot_table)), each = ncol(kraken2_plot_table)),
  Taxonomies=rep(c(colnames(kraken2_plot_table)), sample_size),
  Abundance=unlist(list(as.numeric(t(kraken2_plot_table))))
)

# To keep order of taxonomies to abundance (how the dataframe is organized) and 
# not based on name (because ggplot2 automatically reorders data)
# make the fill option the factor: fill=factor(Taxonomies, unique(Taxonomies))

pdf(snakemake@output[[1]], width=25,height=20)

print(ggplot(all_plot, aes(fill=factor(Taxonomies, unique(Taxonomies)), y=Abundance, x=Sample_ID)) +
        geom_bar(position="fill", stat="identity", colour="black")+
        scale_fill_manual(values = color)+
        theme(axis.text.x = element_text(angle = 45, vjust = 1,
                                         size = 15, hjust = 1),
              title = element_text(size = 20),
              axis.title.x = element_text(size = 20),
              axis.title.y = element_text(size = 20))+
        labs(title=paste("Taxonomy plot of", tax_level, "level Kraken2 results", sep=" ")))
#print(ggplot()) is required to prevent corrupted pdf in a loop/function
dev.off()
