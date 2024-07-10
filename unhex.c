#include <stdio.h>
#include <stdlib.h>

extern unsigned char hello_c[];
extern unsigned int hello_c_len;

int main(int argc, char *argv[])
{
  FILE *handle;

  if (!(handle = fopen("hello.unhex.c", "wb")))
    exit(1);
  for (unsigned int i=0; i < hello_c_len; i++)
    fputc(hello_c[i], handle);
  (void)fclose(handle);
  return 0;
}
