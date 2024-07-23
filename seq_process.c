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


/*
 * parse input file and 'clean' lines
 */
int main(int argc, char *argv[])
{
  for (int i = 1; i < argc; i++) {
    input_file = fopen(argv[i], "r");
  }
  output_file = fopen("sequence_data.csv", "w");
  if (input_file == NULL || output_file == NULL) {
    fputs("Error opening files\n", stdout);
    return 1;
  }

  char *line = NULL;
  size_t len = 0;
  ssize_t read;
  int header_flag = 0;

  char *check = "@+:.0123456789/&$%";

  while ((read = getline(&line, &len, input_file)) != -1){
      if ((strpbrk(line, check)) == NULL){         //strpbrk returns NULL if pattern NOT FOUND
          if (header_flag == 0){
            fprintf(output_file,"%d", strlen(line));
            header_flag = 1;
          }
          encode_sequence(line);
      }
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
  fprintf(output_file, "\nSEQUENCE_%d\n", sequence_count);
  fputs("A,T,C,G\n", output_file);       // A,T,C,G\n

  for (int i = 0; i < strlen(sequence); i++) {
    switch (sequence[i]) {
      case '-': fputs("0,0,0,0\n", output_file); break;
      case 'A': fputs("1,0,0,0\n", output_file); break;
      case 'T': fputs("0,1,0,0\n", output_file); break;
      case 'C': fputs("0,0,1,0\n", output_file); break;
      case 'G': fputs("0,0,0,1\n", output_file); break;
    }
  }
  sequence_count++;
}

