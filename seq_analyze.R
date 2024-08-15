# Mon Jul 15 23:20:07 2024 ------------------------------
library(pcaMethods)
library(ggplot2)
library(data.table)



# Perform PPCA on DataFrame
  # Center data 
  # data.ppca()
  # graph 
analyze_sequences <- function(data_list){

}

get_all_sequences <- function() {
  unique_seq_ids <- unique(dt$SEQ_ID)
  sequences <- list()
  
  for (seq_id in unique_seq_ids) {
    sequences[[seq_id]] <- dt[SEQ_ID == seq_id]
  }
  
  return(sequences)
}

# main
filepath <- "sequence_data.csv"
data <- fread(filepath)

# Subset the data by sequence
seq_1_data <- data[SEQ_ID == "SEQ_1"]

# Remove the SEQ_ID column 
seq_1_data <- seq_1_data[, -1, with = FALSE]

result <- ppca(as.matrix(seq_1_data), nPcs=2)
result
print(completeObs(result))