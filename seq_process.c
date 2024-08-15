#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Process FASTA file by encoding sequences to csv
 *
 * fgets(out, length, file) reads up to length and stores in out from file
 * string.h contains strpbrk(string, pattern) -> find pattern in string
 *
 */

FILE *input_file;
FILE *output_file;

void encode_sequence(char*);
int* scan_sequence(char*);


/*
 * parse input file and 'clean' lines
 */
int main(int argc, char *argv[])
{

  // Parse Args for file
  for (int i = 1; i < argc; i++) {
    input_file = fopen(argv[i], "r");
  }
  // File error handling
  output_file = fopen("sequence_data.csv", "w");
  if (input_file == NULL || output_file == NULL) {
    fputs("Error opening files\n", stdout);
    return 1;
  }

  // Add column headers
  fputs("SEQ_ID,A,T,C,G\n", output_file);

  char *line = NULL;
  size_t len = 0;
  ssize_t read;
  int header_flag = 0;
  char *check = "@+:.0123456789/&$%";

  while ((read = getline(&line, &len, input_file)) != -1){
      if ((strpbrk(line, check)) == NULL)         //strpbrk returns NULL if pattern NOT FOUND
          encode_sequence(line);
  }

  fclose(input_file);
  fclose(output_file);
  return EXIT_SUCCESS;
}

int sequence_count = 1;

/*
 * Receives pointer to line that contains sequence.
 *
 * One-hot encode the line and write to data.csv
 */
void encode_sequence(char *sequence){
  int* pos = scan_sequence(sequence);
  // Prefix trail 
  for (int i = 0; i < pos[0]; i++)
    fprintf(output_file, "SEQ_%d,,,,\n", sequence_count);

  // basecalls 
  for (int i = pos[0]; i < pos[1]; i++) {
    switch (sequence[i]) {
      case '-': fprintf(output_file, "SEQ_%d,0,0,0,0\n", sequence_count); break;
      case 'A': fprintf(output_file, "SEQ_%d,1,0,0,0\n", sequence_count); break;
      case 'T': fprintf(output_file, "SEQ_%d,0,1,0,0\n", sequence_count); break;
      case 'C': fprintf(output_file, "SEQ_%d,0,0,1,0\n", sequence_count); break;
      case 'G': fprintf(output_file, "SEQ_%d,0,0,0,1\n", sequence_count); break;
    }
  }

  //post trail
  for (int i = pos[1]; i < strlen(sequence); i++)
    fprintf(output_file, "SEQ_%d,,,,\n", sequence_count);

  sequence_count++;
  free(pos);
}

int* scan_sequence(char *sequence){
  int* positions = (int*)malloc(2 * sizeof(int));  // Allocate memory for the 2-tuple
  if (positions == NULL) { 
    printf("Memory allocation failed!\n");
    exit(1);  // Handle memory allocation failure
  }
  int firstpos = -1; int lastpos = -1;

  for (int i = 0; i < strlen(sequence)-1; i++){
    if (sequence[i] != '-') {
        if (firstpos == -1) {
            firstpos = i;
        }
        lastpos = i;
    }
  }

  positions[0] = firstpos;
  positions[1] = lastpos;

  return positions;
}
