## Statistical Analyses and Data Visualization 

The Stage 2 task of the HackBio February 2025 internship involves the statistical analysis and visualization of four individual datasets, performed by all of us individually.

**Task 2.1: Microbiology**

The [dataset](https://github.com/HackBio-Internship/2025_project_collection/blob/main/Python/Dataset/mcgc_METADATA.txt) for the first task consists of 3 strains with two replicates each: Strain 1, Strain 2 and Strain 3. The biological replicates are as follows:

* Strain_1_Rep_1
* Strain_1_Rep_2
* Strain_2_Rep_1
* Strain_2_Rep_2
* Strain_3_Rep_1
* Strain_3_Rep_2

For each strain, there are 3 technical replicates for wild-type and mutants. A brief description of the dataset can be found [here](https://raw.githubusercontent.com/HackBio-Internship/2025_project_collection/refs/heads/main/Python/Dataset/mcgc.tsv).

The first part of the task involves the creation of plotting growth curves (OD<sub>600</sub> vs Time) for all different strains by overlaying the knock-out and wild-type strains on top of each other. To do so, the means of technical replicates of wild-type and mutant strains were calculated for each biological replicate. Then, a plot layout with 3 rows and 2 columns wherein the rows representing each strain (Strains 1, 2, and 3) and the columns representing their biological replicates (_Rep_1 and _Rep_2) was generated. Using the base R functions **plot**,**lines** and **legend**, growth curves are created for each biological replicate. The second part of the task includes determining the time it takes for each replicate to reach their carrying capacities. For this, the previous function from Stage 1 is modified, wherein the maximum OD<sub>600</sub> value of each sample is identified. Since the carrying capacity usually refers to 80% of a population, maximum OD<sub>600</sub> is multiplied by 0.8, followed by detecting the timepoints at which OD<sub>600</sub> value reaches or exceeds the target OD<sub>600</sub>. By applying this modified function, a new dataframe of carrying capacities for each sample is created. 
Finally, a scatterplot and a boxplot are generated. Using the carrying capacity dataframe mentioned earlier, a t-test between wild-type and knock-out means is conducted to see whether there is any statistical difference between the time it takes them to reach their carrying capacities. 


**Task 2.6: Transcriptomics**

The dataset can be found [here](https://gist.githubusercontent.com/stephenturner/806e31fce55a8b7175af/raw/1a507c4c3f9f1baaa3a69187223ff3d3050628d4/results.txt).

The goal of this task is to visualize differential gene expression data via volcano plot, categorize the various gene expressions, and determine the function of the top 5 genes using [genecards](https://www.genecards.org/). 
To provide some perspective, the dataset contains an experiment between a diseased cell line and diseased cell lines treated with compound X. The difference in expression change between the two health statuses is computed as log2FoldChange and p-value.

The solutions to the task can be found [here](https://github.com/meltemktn/Team-Arginine-HackBio/blob/main/stage-2/Transcriptomics_task.R) and all the codes are written in R. 


**Task 2.7: Public Health**

This task explores the NHANES [dataset](https://raw.githubusercontent.com/HackBio-Internship/public_datasets/main/R/nhanes.csv) to provide useful insights into the health status and health risk factors of 5000 US citizens. The first step of the analyses involves the processing of the missing values to ensure data accuracy and eradicate the chances of skewed results. This was achieved by converting all NAs (missing data) into 0 as required by the task instructions.

The second part of the task involves visualizing the distribution of BMI, Weight, Weight in Pounds and Age using Histograms. For this, the ggplot2 visualization package was installed to enhance the flexibility and complexity of the generated charts. The subset function was used to exclude any outliers in the data and the **aes()** function was used to map the axes.

The histogram for Weight in Pounds employed a similar formula, with the only difference being the introduction of a variable which calculated the new weight column by multiplying the old weight column by 2.2.

The mean 60-second pulse rate was derived by applying the **mean ()** function on the Pulse column of the dataset. The range of values for the diastolic blood pressure in all participants was determined by establishing the bounds of the values using the **min()** and **max ()** functions.
Likewise, the variance and standard deviation of the incomes of all participants were derived using the **var()** and **sd()** functions.
Scatterplots were also used to visualize the relationships between the Weight and Height columns across other relevant variables such as Gender, Diabetes (status), and Smoking status.

Lastly, t-tests were performed to evaluate the relationships between variables such as Age and Gender, BMI and Diabetes and Alcohol year and relationships. The resultant p-values were then used to examine statistical differences and draw conclusions about the status of the null hypothesis.

