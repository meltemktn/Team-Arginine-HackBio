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

The first part of the task involves the creation of plotting growth curves (OD<sub>600</sub> vs Time) for all different strains by overlaying the knock-out and wild-type strains on top of each other. To do so, the means of technical replicates of wild-type and mutant strains were calculated for each biological replicate. Then, a plot layout with 3 rows and 2 columns wherein the rows representing each strain (Strains 1, 2, and 3) and the columns representing their biological replicates (_Rep_1 and _Rep_2) was generated. Using the 
