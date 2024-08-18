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
gc()

# Subset the data by sequence
#seq_12_data <- data[SEQ_ID == "SEQ_1" | SEQ_ID == "SEQ_2"]

# Remove the SEQ_ID column 
#seq_12_data <- seq_12_data[, -1, with = FALSE]
#seq_12_data <- as.matrix(seq_12_data)
ids <- data$SEQ_ID  # Extract the SEQ_ID column
nids <- length(unique(ids))  # Count the number of unique IDs
print(nids)  # Print the result


tmp <- data[, -1, with = FALSE]
mdata <- as.matrix(tmp)

mdata <- matrix(t(mdata), nrow=nids, byrow=T)
gc()

# Perform PPCA
result <- ppca(mdata, nPcs=2)

print(result@scores)
# Attempt to retrieve the completed data
#pdf("Rplots.pdf")
#plotPcs(result, type="scores")
#dev.off()