import numpy as np 
import pandas as pd
import matplotlib.pyplot as plt 
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import re 
import io


with open('bc08.trim.sort.afq', 'r') as file:
    lines = file.readlines()
    columns = ['A','T','C','G']
    df = pd.DataFrame(columns=columns)  # empty dataframe
    rows = []
    pattern = r"pos=(\d+)-(\d+)"
    length = 0
    
    print(len(lines))
    line_count = 0
    for line in lines:
        line_count += 1 
        print(line_count)
        # how many characters we should read
        if line[0] == '@':
            match = re.search(pattern,line)
            if match:
                x = int(match.group(1))
                y = int(match.group(2))
                length = y-x
                
        if line[0] != '-': # skip '+'
            continue

        charfound = False
        count = 0
        for i in range(len(line)):
            if line[i] not in columns:# and not charfound:  # not in check = - 
                continue
            if count > length:
                break
            count += 1
            observation = {'A': 0, 'T': 0, 'C': 0, 'G': 0}

            if line[i] == 'A':
                observation['A'] = 1
                charfound = True
            elif line[i] == 'T':
                observation['T'] = 1
                charfound = True
            elif line[i] == 'C':
                observation['C'] = 1
                charfound = True
            elif line[i] == 'G':
                observation['G'] = 1
                charfound = True

            rows.append(observation)


        #print(df)

    new_rows = pd.DataFrame(rows)
    df = pd.concat([df, new_rows], ignore_index=True)
    print(df)
    #df.to_csv('data.csv', index=False)

    scaler = StandardScaler()
    scaled_data = scaler.fit_transform(df)

# Perform PCA
    pca = PCA(n_components=2)  
    principal_components = pca.fit_transform(scaled_data)

# Create a DataFrame with the principal components
    principal_df = pd.DataFrame(data=principal_components, columns=['PC1', 'PC2'])

# Optionally, combine with original data (excluding original features)
    final_df = pd.concat([principal_df, df.reset_index(drop=True)], axis=1)

# Output the results
    print("Principal components:\n", principal_df)
    print("Explained variance ratio:\n", pca.explained_variance_ratio_)
    plt.figure(figsize=(8, 6))
    plt.scatter(principal_df['PC1'], principal_df['PC2'], c='blue', edgecolor='k', s=50)
    plt.title('PCA of Dataset')
    plt.xlabel('Principal Component 1')
    plt.ylabel('Principal Component 2')
    plt.grid()
    plt.savefig('bc08-graph.png')

