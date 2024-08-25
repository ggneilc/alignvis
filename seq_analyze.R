# Mon Jul 15 23:20:07 2024 ------------------------------
library(pcaMethods)
library(ggplot2)
library(data.table)

# Perform PPCA on DataFrame
  # ToDo: Center data 
analyze_sequences <- function(data_list){
  result <- ppca(data_list, nPcs=2)         # perform ppca
  df <- as.data.frame(result@scores)        # turn PCAresponse object into df to graph

  ggplot(df, aes(x = V1, y = V2)) +
   geom_point() +
   labs(x = "PC1", y = "PC2", title = "test") +
  scale_x_continuous(limits = c(-60, 60), breaks = seq(-60, 60, by = 10)) +  # Set x-axis limits and breaks
   scale_y_continuous(limits = c(-60, 60), breaks = seq(-60, 60, by = 10)) +  # Set y-axis limits and breaks
   theme_minimal()
}

# Turn the matrix of basecalls into a matrix of sequences
get_sequences <- function(data){
  ids <- data$SEQ_ID                                # Extract the SEQ_ID column
  nids <- length(unique(ids))                       # Count the number of unique IDs
  tmp <- data[, -1, with = FALSE]                   # remove id column
  mdata <- as.matrix(tmp)                           # turn datatable into matrix
  seq_data <- matrix(t(mdata), nrow=nids, byrow=T)  # turn each sequence into a row 
  return(seq_data)
}

# Stratified random sampling : group sequences into clusters of `size` and take one sequence from cluster
subsample <- function(data, size){
  n_rows <- nrow(data)
  n_clusters <- ceiling(n_rows / size)
  clusters <- rep(1:n_clusters, each = size)[1:n_rows]
  sampled_indices <- tapply(1:n_rows, clusters, function(cluster_rows){
                              sample(cluster_rows, size=1)
  })
  return(data[sampled_indices, ])
}

start_time <- proc.time()
# main
filepath <- "sequence_data.csv"
data <- fread(filepath)
seq_data <- get_sequences(data)
sampled_data <- subsample(seq_data, size = 10)
gc()
analyze_sequences(sampled_data)
end_time <- proc.time()

print(end_time - start_time)
