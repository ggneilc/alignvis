# Mon Jul 15 23:20:07 2024 ------------------------------
library(pcaMethods)
library(ggplot2)

# Load in Sequence from csv file to DataFrame
# csv format:
  # 1: 4000 (length of each sequence table)
  # 2: SEQUENCE_1 
  # 3: A,T,C,G
  # 4: 0,0,0,0 
  # .. . . . . 
  # 4002: 0,0,0,0 # end of table 1
  # 4003: 
  # 4004: SEQUENCE_2
  # 4005: A,T,C,G
  # 4006: 0,0,0,0
#
process_sequences <- function(filepath){
# Read the file lines
  lines <- readLines(filepath)
  
  # Initialize variables
  sequence_name <- NULL
  sequence_data <- list()
  current_data <- NULL
  
  # Iterate through the lines
  for (line in lines) {
    if (grepl("^SEQUENCE_", line)) {
      # If it's a sequence name, store the previous data if any
      if (!is.null(sequence_name)) {
        sequence_data[[sequence_name]] <- current_data
      }
      # Set the new sequence name
      sequence_name <- line
      # Initialize an empty data frame for the new sequence
      current_data <- data.frame(A = numeric(), T = numeric(), C = numeric(), G = numeric(), stringsAsFactors = FALSE)
    } else if (grepl("^[0-9,]+$", line)) {
      # If it's a data line, append it to the current data frame
      values <- as.numeric(strsplit(line, ",")[[1]])
      current_data <- rbind(current_data, data.frame(A = values[1], T = values[2], C = values[3], G = values[4]))
    }
  }
  # Store the last sequence data
  if (!is.null(sequence_name)) {
    sequence_data[[sequence_name]] <- current_data
  }
  
  return(sequence_data)
}
# Perform PPCA on DataFrame
  # Center data 
  # data.ppca()
  # graph ? 
analyze_sequences <- function(data_list){
  results <- list()
  
  for (name in names(data_list)) {
    if (nrow(data_list[[name]]) > 0){
      # Apply PPCA
      pca_result <- pca(t(data_list[[name]]), method="ppca", nPcs = 2, seed = 1234)
      
      # Extract scores
      scores <- scores(pca_result)
      
      # Create a dataframe for plotting
      df <- data.frame(PC1 = scores[, 1], PC2 = scores[, 2], Sequence = name)
      
      # Append to results
      results[[name]] <- df
    }
  }
  
  # Combine all results into a single dataframe
  combined_df <- do.call(rbind, results)
  
  # Plot using ggplot2
  ggplot(combined_df, aes(x = PC1, y = PC2, color = Sequence)) +
    geom_point() +
    theme_minimal() +
    labs(title = "PPCA of Sequence Data", x = "Principal Component 1", y = "Principal Component 2")
}

# main
filepath <- "sequence_data.csv"
sequence_tables <- process_sequences(filepath)
print(sequence_tables[[1]])
analyze_sequences(sequence_tables)
