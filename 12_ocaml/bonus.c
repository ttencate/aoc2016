#include <stdio.h>

#define cpy(value, reg) reg = (value)
#define jnz(condition, label) if ((condition) != 0) goto label
#define inc(reg) reg++
#define dec(reg) reg--;

int main() {
  int a = 0;
  int b = 0;
  int c = 0;
  int d = 0;
  l0: cpy(1, a);
  l1: cpy(1, b);
  l2: cpy(26, d);
  l3: jnz(c, l5);
  l4: jnz(1, l9);
  l5: cpy(7, c);
  l6: inc(d);
  l7: dec(c);
  l8: jnz(c, l6);
  l9: cpy(a, c);
  l10: inc(a);
  l11: dec(b);
  l12: jnz(b, l10);
  l13: cpy(c, b);
  l14: dec(d);
  l15: jnz(d, l9);
  l16: cpy(14, c);
  l17: cpy(14, d);
  l18: inc(a);
  l19: dec(d);
  l20: jnz(d, l18);
  l21: dec(c);
  l22: jnz(c, l17);
  printf("%d\n", a);
}
