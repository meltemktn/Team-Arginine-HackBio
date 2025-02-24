# HackBio Internship Program - February, 2025
# Team-arginine on the stage-2 task
# The group consists of four people, namely:
# Meltem (GitHub: @meltemktn)
# BenAkande (GitHub: @BenAkande123)
# Manav Vaish (GitHub: @manavvaish)
# Favour_Imoniye (GitHub: @Favour-Imoniye)
# GitHub link to the team-arginine repository for stage-2:
# https://github.com/meltemktn/Team-Arginine-HackBio/tree/main/stage-2

## Task Code 2.6:
# Transcriptomics
# This is a processed RNAseq dataset involving reading in quantitated gene expression data from an RNA-seq experiment, 
#exploring the data using base R functions and then interpretation. 
# The dataset contains an experiment between a diseased cell line and diseased cell lines treated with compound X. 
#The difference in expression change between the two health status is computed as Fold change to log 2 (Log2FC) 
# and the significance of each is computed in p-value.

#Task:
# (1) Generate a volcano plot. (Hint search for volcano plot online)
# Determine the upregulated genes (Genes with Log2FC > 1 and pvalue < 0.01)
# Determine the downregulated genes (Genes with Log2FC < -1 and pvalue < 0.01)
# What are the functions of the top 5 upregulated genes and top 5 downregulated genes. (Use genecards)

# Load the appropriate libraries
library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)

#Data Import
url <- "https://gist.githubusercontent.com/stephenturner/806e31fce55a8b7175af/raw/1a507c4c3f9f1baaa3a69187223ff3d3050628d4/results.txt"
rna_seq <- read_delim(url, delim=" ", col_names = T)
head(rna_seq, n=5)

# Add significance categories for plotting
rna_seq <- rna_seq %>%
  mutate(
    significance = case_when(
      pvalue < 0.01 & log2FoldChange > 1 ~ "Upregulated",
      pvalue < 0.01 & log2FoldChange < -1 ~ "Downregulated",
      TRUE ~ "Not Significant"
    )
  )

# (1) Generate volcano plot
# Create volcano plot
volcano_plot <- ggplot(rna_seq, aes(x = log2FoldChange, y = -log10(pvalue))) +
  geom_point(aes(color = significance)) +
  scale_color_manual(values = c("Upregulated" = "red", 
                                "Downregulated" = "blue", 
                                "Not Significant" = "grey")) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "grey") +
  geom_hline(yintercept = -log10(0.01), linetype = "dashed", color = "grey") +
  theme_minimal() +
  labs(
    title = "Volcano Plot of Differential Gene Expression",
    subtitle = "Effect of Compound X on diseased cell line vs diseased cell line",
    x = "Log2 Fold Change",
    y = "-log10(p-value)",
    color = "Regulation Status"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 10),
    legend.position = "right"
  )

# Add gene labels for significant genes
significant_genes <- rna_seq %>%
  filter(significance != "Not Significant")

volcano_plot <- volcano_plot +
  geom_text(data = significant_genes,
            aes(label = Gene),
            vjust = -0.5,
            size = 3)
print(volcano_plot)


# Determine the upregulated genes
up_genes <- significant_genes[significant_genes$significance == "Upregulated",] |>
  arrange(desc(log2FoldChange))
print(up_genes)

# Determine the downregulated genes
down_genes <- significant_genes[significant_genes$significance == "Downregulated",] |>
  arrange(desc(log2FoldChange))
print(down_genes)

# Function of the top 5 genes
print(up_genes, n=5)
print(down_genes, n=5)

# Using the gene names as input in genecards, retrieve their function
# create a data frame of the gene, level of regulation and function.
gene_functions <- data.frame(
  Gene = c(
    #Up-regulated genes
    "DTHD1", "EMILIN2", "PI16", "C4orf45", "FAM180B",
    #Down-regulated genes
    "FAM46B", "HS3ST3A1", "PMEL", "TNFAIP6", "COL4A2"
  ),
  Regulation = c(rep("Upregulated", 5), rep("Downregulated", 5)),
  Functions =c(
    #Upregulated genes
   "Death Domain Containing 1: Involved in programmed cell death signaling and inflammatory responses",
   "Elastin Microfibril Interface Located Protein 2: Extracellular matrix glycoprotein involved in angiogenesis, vessel patterning, and vascular cell development",
   "Peptidase Inhibitor 16: Serine protease inhibitor involved in cardiac remodeling and cellular proteolysis",
   "Chromosome 4 Open Reading Frame 45: Not well characterized, may be involved in cellular signaling",
   "Family With Sequence Similarity 180 Member B: Located in the extracellular region",
    #Downregulated genes
   "Terminal Nucleotidyltransferase 5B: Negative regulation of apoptotic process, negative regulation of cell population proliferation and positive regulation of translation",
   "Heparan Sulfate-Glucosamine 3-Sulfotransferase 3A1: Sulfotransferase that utilizes 3'-phospho-5'-adenylyl sulfate (PAPS) to catalyze the transfer of a sulfo group to an N-unsubstituted glucosamine linked to a 2-O-sulfo iduronic acid unit on heparan sulfate",
   "Premelanosome Protein: Forms physiological amyloids that play a central role in melanosome morphogenesis and pigmentation",
   "TNF Alpha Induced Protein 6: Major regulator of extracellular matrix organization during tissue remodeling, Inhibits BMP2-dependent differentiation of mesenchymal stem cell to osteoblasts",
   "Collagen Type IV Alpha 2 Chain: It inhibits proliferation and migration of endothelial cells, reduces mitochondrial membrane potential, and induces apoptosis"
   )
)
print(gene_functions)
