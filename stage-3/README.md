# Drug Discovery Project

The Stage 3 project of the [HackBio](https://thehackbio.com) February 2025 internship involves the analysis of a [chemical descriptor matrix](https://github.com/HackBio-Internship/2025_project_collection/raw/refs/heads/main/Python/Dataset/drug_class_struct.txt) with over 10000 compounds docked against adenosine deaminase (ADA2), an enzyme involved in purine metabolism and is essential for the development and maintenance of the immune system in humans. Increased levels of ADA2 are associated with many diseases such as rheumatoid arthritis, psoriasis and sarcoidosis.

Using the information given in the dataset, we attempted to answer the questions below:

- How similar are these molecules to each other?
- Can we differentiate decoys from the active molecules?
- Can we effectively predict the docking score using the chemical features of ligands alone?
- Which chemical features can be used to determine if a ligand binds to a target protein?

## PCA and K-means Clustering 

For the evaluation of the similarity of ligands within a chemical space representation, principal component analysis (PCA) and k-means clustering were performed using the information of docking scores for each ligand. After the identification of missing values, columns with non-numeric values and numeric columns with no variance or constant data were removed from the dataset. The remaining columns and the "score" column were scaled using the Z-score normalization to reduce the impact of extreme values on the PCA results. Next, the **"prcomp"** function was applied on the scaled numeric features to determine the optimum number of principal components. The output was then validated by reviewing the explained variance and cumulative variance of all optimal principal components. Principal components with high eigenvalues accounting for more than 90% of the variance were selected for downstream analyses.

The elbow method was employed to determine the optimum number of clusters for k-means clustering by selecting different k values ranging from 1 to 10 and calculating their within cluster sum of squares (WCSS). Once the optimum number of clusters was determined, the **"kmeans"** function was applied on the PCA-reduced data, wherein each datapoint was assigned to the clusters that contained the centroid closest to them.

Based on the findings from the examination of the docking score densities across all clusters, Cluster 9 exhibited the highest amount of low docking scores, indicating its dominant composition of compounds with high binding affinity.

## Linear Regression and Random Forest Regression

To answer the last two questions, both a linear regression and a random forest regression model were applied by first downsizing the data to 10000 rows only for efficiency and then separating the reduced dataset into training and test datasets following the 80-20 rule. Next, for comparison, each model was trained with 5-times cross-validation using the **“lm”** and **"rf"** methods of the **“train”** function in the **caret** package of R. 

After summarizing and calculating the RMSE, MAE and R<sup>2</sup> values for the test data, the most important 10 chemical features were identified by running recursive feature elimination (RFE) on each regression model. For time and efficiency purposes, both models were trained with the RFE control used for the linear regression. Finally, each regression model was then trained with the feature selected data to determine the robustness of each model.  

The results showed that although the final R<sup>2</sup> values, MAE and RMSE for both models were low, chemical features alone could be used for the prediction of docking scores to some extent. Furthermore, the order and content of the most important 10 chemical features differed slightly between the models. Using parallelization on large datasets such as our chemical descriptor matrix of interest for recursive feature elimination, along with more descriptors could help us better detect the most important structural features. 
