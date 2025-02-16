# Functions Galore! 
The Stage 1 task of the HackBio February 2025 internship involves writing four different functions for specific purposes, two of them being related to each other:


**Function 1 : Translation of DNA into protein**
  
This function takes a DNA sequence as input. It slices the sequence into sub-strings of 3 (codons) and appends them to an empty character vector defined within the function. A dataframe of all the codons and their corresponding amino acids (see [codon bias](https://en.wikipedia.org/wiki/Codon_usage_bias)) is also defined within the same function, where synonymous codons encoding the same amino acid are given as vectors within a list. Next, each codon within the DNA sequence is replaced with its corresponding amino acid by traversing the column of list of codon vectors in the dataframe. Once a stop codon is reached, the function stops and returns the final amino acid sequence.



**Function 2: Generation and simulation of a logistic growth curve**

Logistic growth refers to the type of population growth where unlike the exponential growth, the resources are limited and the growth rate is influenced by population size, leading to a sustainable maximum point known as **carrying capacity (K)**. The logistic growth curve is characterized by an S-shaped curve, whose function is

$P(t) = \frac{K}{1 + \left(\frac{K - P_0}{P_0}\right)*e^{-rt}}$

Where 

* $P(t)$ is the population size/concentration/OD at timepoint $t$,
* $K$ is the maximum carrying capacity,
* $t$ is time,
* $P_0$ is the initial population size/OD at $t=0$,
* $r$ is the growth rate.

If the population size is smaller than the carrying capacity ($K$), the growth is nearly exponential. As it reaches to $K$, growth slows down as        $\left(\frac{K - P_0}{P_0}\right)$ approaches 0. When the population size is equal to $K$, the population stabilizes.

The function we constructed takes three parameters for the initial population size (n for $P_0$), growth rate (r for $r$) and time. It assumes the maximum carrying capacity $K$ to be 1, therefore the expression above changes as: 

$P(t) = \frac{1}{1 + \left(\frac{1 - P_0}{P_0}\right) * e^{-rt}}$

After running the function, a plot is set up. To simulate changes in the concentrations for 100 times, a for loop with random initial concentration values and random growth rates is created. Next, these random values are given as inputs for the logistic growth curve function, along with the defined time range. The function is run for 100 times within the loop, while lines for each output are generated with randomly selected colors from the RGB scale.

**Function 3: Determining the time to reach 80% of the maximum growth - based on Function 2**

Based on the function above, we attempt to calculate the time it takes for a population to reach 80% of its carrying capacity (or an OD<sub>600</sub> of 0.8 for a microbial culture, for instance). The above expression therefore turns into:

$P(t) = \frac{0.8}{1 + \left(\frac{0.8 - P_0}{P_0}\right)*e^{-rt}}$

where $K = 0.8$.

To do so, we utilize the growth rate, initial concentration and final concentration as parameters within the function. We insert them in a formula described within the function and return a print statement. We apply the formula below as such: 

$t= -((ln((0.8/P_t)-1)-ln((0.8-P_0)/P_0))/r)$


**Function 4: Calculating the Hamming distance between a Slack username and a Twitter/X username**

Hamming distance is the number of substitutions required for two strings of equal length to be the same. It can also be described as the number of positions at which the corresponding symbols are different. For more information see [Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance). 

The function takes a Slack username and a Twitter/X username as parameters. It splits the usernames into their individual characters simultaneously appended to their corresponding vectors with the **strsplit** function. After comparing the username vectors with each other for their lengths, the function compares each character within these vectors based on their positions. In the meantime, a variable for the Hamming distance between two usernames is initialized. If a character within the first username/vector is different from that within the second username/vector, the Hamming distance is increased by 1. Finally, it returns a statement that describes the Hamming distance between the two strings. 






