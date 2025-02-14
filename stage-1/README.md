# Functions Galore! 
The Stage 1 task of the HackBio February 2025 internship involves writing four different functions for specific purposes, two of them being related to each other:


**Function 1 : Translation of DNA into protein**
  
This function takes a DNA sequence as input. It slices the sequence into sub-strings of 3 (codons) and appends them to an empty character vector defined within the function. A dataframe of all the codons and their corresponding amino acids (see [codon bias](https://en.wikipedia.org/wiki/Codon_usage_bias)) is also defined within the same function, where synonymous codons encoding the same amino acid are given as vectors within a list. Next, each codon within the DNA sequence is replaced with its corresponding amino acid by traversing the column of list of codon vectors in the dataframe. Once a stop codon is reached, the function stops and returns the final amino acid sequence.

**Function 2: Generation and simulation of a logistic growth curve**

**Function 3: Determining the time to reach 80% of the maximum growth - based on Function 2**






**Function 4: Calculating the Hamming distance between a Slack username and a Twitter/X username**

Hamming distance is the number of substitutions required for two strings of equal length to be the same. It can also be described as the number of positions at which the corresponding symbols are different. For more information see [Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance). 






