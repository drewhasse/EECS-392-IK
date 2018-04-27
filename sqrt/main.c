#include <stdio.h>
#include "sqrt.h"

int main(int argc, char const *argv[]) {
  float num = 1;
  int iter = 1;
  printf("Enter a number: ");
  scanf("%f %d", &num, &iter);
  printf("%f\n",sqrt2(num,8));
  return 0;
}
