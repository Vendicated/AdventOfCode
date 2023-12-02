#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int, char** argv) {
  FILE* fp = fopen(argv[1], "r");
  
  char* line = NULL;
  size_t len;
  size_t read;

  int curr = 0;
  int highest[3] = {0, 0, 0}; 

  while (1) {
    read = getline(&line, &len, fp);

    int length = read > 0 ? strlen(line) : 1;
    // goofy aah newline
    if (length == 1) {
      for (int i = 0; i < 3; i++) {
        if (curr > highest[i]) {
          if (i < 2) highest[2] = highest[1];
          if (i < 1) highest[1] = highest[0];
          highest[i] = curr;
          break;
        }
      }
      curr = 0;
    } else {
      curr += atoi(line);
    }

    if (read == -1) break;
  }

  printf("Part1: %d\n", highest[0]);
  printf("Part2: %d\n", highest[0] + highest[1] + highest[2]);
  free(line);
  fclose(fp);
}
