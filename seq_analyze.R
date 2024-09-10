# Mon Jul 15 23:20:07 2024 ------------------------------
library(pcaMethods)
library(ggplot2)
library(data.table)
library(scales)

# Center the data
center_data <- function(data_matrix) {
  # Calculate column means
  col_means <- colMeans(data_matrix, na.rm = TRUE)
  
  # Subtract mean from each column
  centered_data <- sweep(data_matrix, 2, col_means, "-")
  
  return(centered_data)
}

# Perform PPCA on DataFrame
analyze_sequences <- function(data_list){
  centered_data <- center_data(data_list)
  result <- ppca(centered_data, nPcs=2)         # perform ppca
  df <- as.data.frame(result@scores)        # turn PCAresponse object into df to graph

  # Add a column for sequence number
  df$sequence <- factor(1:nrow(df))
  
  # Generate a color palette with as many colors as there are sequences
  num_colors <- nrow(df)
  color_palette <- hue_pal()(num_colors)

  ggplot(df, aes(x = V1, y = V2, color = sequence)) +
   geom_point() +
   labs(x = "PC1", y = "PC2", title = "Sequence Analysis") +
   scale_x_continuous(limits = c(-60, 60), breaks = seq(-60, 60, by = 10)) +  # Set x-axis limits and breaks
   scale_y_continuous(limits = c(-60, 60), breaks = seq(-60, 60, by = 10)) +  # Set y-axis limits and breaks
   scale_color_manual(values = color_palette) +
   theme_minimal() +
   theme(legend.position = "none")  # Remove the legend as it might be too large
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
