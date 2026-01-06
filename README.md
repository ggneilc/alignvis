# Alignment Visualization
![C](https://img.shields.io/badge/c-%2300599C.svg?style=for-the-badge&logo=c&logoColor=white)
![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Matplotlib](https://img.shields.io/badge/Matplotlib-%23ffffff.svg?style=for-the-badge&logo=Matplotlib&logoColor=black)



`alignvis` is a project to help the speed of quality checking FASTA reads from an Oxford Nanopore.

Instead of having to run through the entire data pipeline and see the results to conclude that their might have been contamination or barcode hopping, `alignvis` imputes each sequence from the amplicon reads and clusters the similar sequences to quickly differeniate between errors.  

1. `seq_process` processes a `.fasta` file of dna reads and transforms to a one-hot encoded `.csv` file.
2. `seq_analyze` performs a **probabilistic principal component analysis** to fill in any missing reads for each sequence.
3. `test.py` reads in the csv and saves a matplotlib graph.
