# HackBio Internship Program - February, 2025
# Team-arginine on the stage-3 task
# The group consists of four people, namely:
# Meltem (GitHub: @meltemktn)
# BenAkande (GitHub: @BenAkande123)
# Manav Vaish (GitHub: @manavvaish)
# Favour_Imoniye (GitHub: @Favour-Imoniye)
# GitHub link to the team-arginine repository for stage-3:

#Install packages
install.packages("DescTools",dependencies = c("Depends","Imports"),lib= .libPaths()[1])
install.packages("irlba")
install.packages("ClusterR")
install.packages ("viridis")
install.packages("uwot")

#Load the libraries
library (dplyr)
library (ggplot2)
library(DescTools)
library(irlba)
library(ClusterR)
library(viridis)
library(tidyr)
library(uwot)

#Load the data set
Chem_descriptor <- read.csv("C:\\Users\\Favour Imoniye\\Downloads\\Genomac Hub\\drug_desc_to_wale.txt", sep = "\t", header = TRUE)

#Assess the dimensions and datatypes of the data and the distribution of missing values in the data set
dim (Chem_descriptor)
colSums(is.na(Chem_descriptor))

#Remove non_numeric columns and columns with constant data or 0 variance for the principal component analysis (PCA)
Chemdescript_num <- Chem_descriptor %>% select (-c(ID,score, SMILES, target, ComponentCount))

#Extract the score column from the data and store separately
docking_scores <- data.frame(Chem_descriptor$score)
dim(docking_scores)

#Remove positive outliers from the docking score data
Docking_filtered <- docking_scores %>% filter(docking_scores$Chem_descriptor.score<0)

#Ensure consistency with the features data set
kept_indices <- as.numeric(rownames(Docking_filtered))
Chemdescript_filtered <-Chemdescript_num[kept_indices, ]

#Check for the variance of each column
apply(Chem_descriptor, 2, var)

#Scale the data to improve comparability between the values
Chemdescript_scaled <- scale(Chemdescript_filtered)

#Scale the docking scores
Scaled_dockingscore <- scale(Docking_filtered)
ScaledDS<- data.frame(Scaled_dockingscore)
head(ScaledDS)

#Visualize the distribution of outliers in the data sets
boxplot(Chemdescript_scaled, las = 2, col = "lightgray", pch = 16, cex = 0.6,
        main = "Boxplot of Molecular Properties")
boxplot(ScaledDS, main= "Box Plot of Docking Scores",
        ylab= "Docking Score",
        col = "lightblue",
        border="black")

# Compute the PCA
Chem_pca <- prcomp(Chemdescript_scaled, center = TRUE, scale. = TRUE, rank. = 25)  # Keep only first 25 PCs

# Check the explained variance
summary(Chem_pca)

# Select the first N PCs that explain about 85% variance of the overall data
cumulative_variance <- cumsum(Chem_pca$sdev^2) / sum(Chem_pca$sdev^2)
num_components <- which(cumulative_variance >= 0.85)[1]
Chempca_data <- Chem_pca$x[, 1:num_components]  # Keep relevant PCs

#Apply the elbow method to the PCA-reduced data
set.seed(123)

# Create a function to compute the total within-cluster sum of squares (WCSS)
wcss <- function(k) {
  kmeans(Chempca_data, centers = k, nstart = 10, iter.max=500)$tot.withinss
}

# Try different values of K (1 to 15)
k_values <- 1:15
wcss_values <- sapply(k_values, wcss)

# Plot Elbow Curve
plot(k_values, wcss_values, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters K", ylab = "Total Within-Cluster Sum of Squares",
     main = "Elbow Method on PCA-Reduced Data")

# Run  K-Means function to achieve clustering
chem_matrix <- as.matrix(data.frame(Chempca_data))
k <- 10 #Select a suitable amount of clusters
kmeans_result <- kmeans(chem_matrix, centers = k, nstart =25 )

clusters_assigned <- kmeans_result$cluster
print(table(clusters_assigned))

#Create a data frame containing the PCA, clusters and docking scores for visualization
Final_Data<- data.frame(chem_matrix,
                         Cluster = as.factor(clusters_assigned),
                         DockingScores = ScaledDS)
colnames(Final_Data) [colnames(Final_Data) == "Chem_descriptor.score"] <- "DockingScores"

# Visualize the docking scores across the chemical space using PCA
ggplot(Final_Data, aes(x = PC1, y = PC2, color = DockingScores)) +
  geom_point(alpha = 0.7, size = 1) +
  scale_color_viridis(option = "plasma", direction = -1) +
  theme_minimal()+
  labs(title = "PCA's Representation of the Docking Scores across the Chemical Space", color ="Docking Score")+
  theme(plot.title=element_text(size= 25, hjust=0.5),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 12)
  )

#Visualize the chemical space by clusters using PCA
ggplot(Final_Data, aes(x = PC1, y = PC2, color = Cluster)) +
  geom_point(alpha = 0.6) +
  theme_minimal()+
  labs(title = "PCA's Representation of the Clusters present in the Chemical Space",
       color= "Cluster") +
  theme(plot.title=element_text(size= 25, hjust=0.5),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 12)
  )

#Compute UMAP on the PCA reduced data
set.seed(123)
umap_result <- umap(Chempca_data,
                    n_neighbors = 15,
                    min_dist = 0.1,
                    metric = "euclidean")

# Create a data frame containing the UMAP results, clusters and the docking scores
umap_df <- data.frame(UMAP1 = umap_result[,1],
                      UMAP2 = umap_result[,2],
                      Cluster = as.factor(clusters_assigned),
                      DockingScores = ScaledDS
                      )
colnames(umap_df) [colnames(umap_df) == "Chem_descriptor.score"] <- "DockingScores"


#Visualize the docking scores across the chemical space using UMAP
ggplot(umap_df, aes(x = UMAP1, y = UMAP2, color = DockingScores)) +
  geom_point(alpha = 0.8, size = 1.5) +
  scale_color_gradientn(colors = c("blue", "green", "yellow", "red")) +
  theme_minimal() +
  labs(title = "UMAP's Representation of the Docking Scores across the Chemical Space ",
       x = "UMAP 1", y = "UMAP 2", color = "Docking Score")+
theme(plot.title=element_text(size= 25, hjust=0.5),
      axis.title.x = element_text(size = 12),
      axis.title.y = element_text(size = 12),
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12),
      legend.title = element_text(size = 12, face = "bold"),
      legend.text = element_text(size = 12)
)

#Visualize the chemical space by clusters using UMAP
ggplot(umap_df, aes(x = UMAP1, y = UMAP2, color = Cluster)) +
  geom_point(alpha = 0.8, size = 1.5) +
  theme_minimal() +
  labs(title = "UMAP's Representation of the Clusters across the Chemical Space ",
       x = "UMAP 1", y = "UMAP 2", color = "Sub Cluster")+
theme(plot.title=element_text(size= 25, hjust=0.5),
      axis.title.x = element_text(size = 12),
      axis.title.y = element_text(size = 12),
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12),
      legend.title = element_text(size = 12, face = "bold"),
      legend.text = element_text(size = 12)
)
