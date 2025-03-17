# Drug Discovery Project

The Stage 3 project of the [HackBio](https://thehackbio.com) February 2025 internship involves the analysis of a [chemical descriptor matrix](https://github.com/HackBio-Internship/2025_project_collection/raw/refs/heads/main/Python/Dataset/drug_class_struct.txt) with over 10000 compounds docked against adenosine deaminase (ADA2), an enzyme involved in purine metabolism and is essential for the development and maintenance of the immune system in humans. Increased levels of ADA2 are associated with many diseases such as rheumatoid arthritis, psoriasis and sarcoidosis.

Using the information given in the dataset, we attempted to answer the questions below:

- How similar are these molecules to each other?
- Can we differentiate decoys from the active molecules?
- Can we effectively predict the docking score using the chemical features of ligands alone?
- Which chemical features can be used to determine if a ligand binds to a target protein?


To answer the last two questions, both a linear regression and a random forest regression model were applied by first separating the dataset into training and test datasets following the 80-20 rule. The choice of the regression model depended on time and computational constraints. Next, for comparison, the model was trained with 5-times cross-validation using the **“lm”** and **"rf"** methods of the **“train”** function in the **caret** package of R. After summarizing and calculating the RMSE for the test data, the most important 10 chemical features were identified by running random feature selection on each regression model. The results showed that although the final R<sup>2</sup> values and RMSE for both models were low, chemical features alone could be used for the prediction of docking scores to some extent. The unusual increase in mean absolute error (MAE) after recursive feature selection in random forest regression can be attributed to the lack of descriptive features in the dataset. Furthermore, the order and content of the most important 10 chemical features differed slightly between the models, wherein 7 features, namely "MW_EXACT", "TPSA_NOPS","HBD","FSP3","RotBondCount", "BondCount" and "XLogP" were commonly identified. 
