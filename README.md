# ThinkNeuro Bibliometric Analysis

Bibliometric analysis and dual-axis data visualization project.

## Repository Contents
* **`script.R`** : Clean R script for author tokenization, fractional counting calculations, and figure generation.
* **`Author_Citations_DualAxis_1000dpi.png`** : Final high-resolution figure (1000 DPI) using the requested blue palette and Helvetica typography.

## Mathematical Methodology
For each article, the publication value ($w$) is divided equally among its $n$ authors:
$$w = \frac{1}{n}$$

Citations from Web of Science and Scopus are merged to calculate the total impact per author.
