import numpy as np 
import matplotlib.pyplot as plt 
from sklearn.decomposition import FactorAnalysis
import re 
import io
import time
import argparse


parser = argparse.ArgumentParser(description="Enter data file")
parser.add_argument("f", type=str, help="name of file")
args = parser.parse_args()


plt.figure(figsize=(8, 6))
plt.title('PPCA of Barcode x')
plt.xlabel('Principal Component 1')
plt.ylabel('Principal Component 2')
plt.grid()

with open(args.f, 'r') as file:
    lines = file.readlines()
    line_check = r"[;@<:%&+/]+"
    count_line = 0

    lines_cleaned = [x for x in lines if not re.search(line_check, x)]

    print(len(lines_cleaned))
    for line in lines_cleaned:
        basecalls = []
        count_line += 1
        print(count_line)

        # Go through each base call read
        for i in range(len(line)):

            observation = {'A': 0, 'T': 0, 'C': 0, 'G': 0}
            if line[i] == '-':
                basecalls.append(observation)
                continue
            elif line[i] == 'A':
                observation['A'] = 1
            elif line[i] == 'T':
                observation['T'] = 1
            elif line[i] == 'C':
                observation['C'] = 1
            elif line[i] == 'G':
                observation['G'] = 1

            basecalls.append(observation)
        
        # turn the base reads into the data
        # new_rows = pd.DataFrame(rows)
        values_list = [list(observation.values()) for observation in basecalls]
        data = np.array(values_list)
        # Maintain origianl columns
        # df = pd.concat([df,new_rows], ignore_index=True)
        # print(df)

        # center the data
        #df_centered = df - np.mean(df, axis=0)
        centered = data - np.mean(data, axis=0) 

        # apply ppca
        fa = FactorAnalysis(n_components=2)
        trans = fa.fit_transform(centered)

#        new_df = pd.DataFrame(trans)
#        print(new_df)


        x = trans[:, 0]
        y = trans[:, 1]
        #plt.scatter(new_df[0], new_df[1], c='blue', edgecolor='k', s=50)
        plt.scatter(x, y, c='blue', edgecolor='k', s=50)
    plt.savefig('bc03.png')

    file.close()

