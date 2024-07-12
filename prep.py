import numpy as np 
import pandas as pd
import matplotlib.pyplot as plt 
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import re 
import io
import time
import argparse


parser = argparse.ArgumentParser(description="Enter data file")
parser.add_argument("f", type=str, help="name of file")
args = parser.parse_args()



with open(args.f, 'r') as file:
    lines = file.readlines()
    columns = ['A','T','C','G']
    check = ['A','T','C','G','-']
    df = pd.DataFrame(columns=columns)  # empty dataframe
    rows = []
    pattern = r"pos=(\d+)-(\d+)"
    line_check = r"[;@<:%&+/]+"
    length = 0
    count_line = 0
    start_line_time = time.time()

    lines_cleaned = [x for x in lines if not re.search(line_check, x)]
    for line in lines_cleaned:
        count_line += 1
        print(count_line)
        # how many characters we should read
#        if line[0] == '@':
#            match = re.search(pattern,line)
#            if match:
#                x = int(match.group(1))
#                y = int(match.group(2))
#                length = y-x + 100
                
#        if line[0] != '-': # skip '+'
#            continue

#        charfound = False
#        count = 0
        for i in range(len(line)):
#            if line[i] == '-' and not charfound:  # not in check = - 
#                continue
#            if count > length:
#                break
#            count += 1
            observation = {'A': 0, 'T': 0, 'C': 0, 'G': 0}

            if line[i] == 'A':
                observation['A'] = 1
#                charfound = True
            elif line[i] == 'T':
                observation['T'] = 1
#                charfound = True
            elif line[i] == 'C':
                observation['C'] = 1
#                charfound = True
            elif line[i] == 'G':
                observation['G'] = 1
#                charfound = True

            rows.append(observation)

    end_line_time = time.time()

    print(f"Elapsed time for parsing file: {end_line_time - start_line_time}")

    new_rows = pd.DataFrame(rows)
    df = pd.concat([df, new_rows], ignore_index=True)
    print(df)

    df.to_csv('data.csv', index=False)

    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(df)

# Perform PCA
    pca = PCA(n_components=2)
    principal_components = pca.fit_transform(scaled_data)

# Create a DataFrame with the principal components
    principal_df = pd.DataFrame(data=principal_components, columns=['PC1', 'PC2'])
    print(principal_df)

# Plot the principal components
    plt.figure(figsize=(8, 6))
    plt.scatter(principal_df['PC1'], principal_df['PC2'], c='blue', edgecolor='k', s=50)
    plt.title('PCA of Dataset')
    plt.xlabel('Principal Component 1')
    plt.ylabel('Principal Component 2')
    plt.grid()
    plt.savefig('graph.png')

