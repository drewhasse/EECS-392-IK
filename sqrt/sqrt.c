#include "sqrt.h"

float sqrt2(float num, int iter) {
  float res = -1.0;
  float temp;
  float n1 = 0;
  float n2 = num;
  for (int i = 0; i < iter; i++) {
    temp = (n1+n2)/2.0;
    res = num/temp;
    if (res == temp) return res;
    else {
      n1 = temp;
      n2 = res;
    }
  }
  return res;
}
