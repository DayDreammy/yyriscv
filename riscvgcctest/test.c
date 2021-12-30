int main() {
  volatile int * p1;
  volatile int * p2;
  volatile int * p3;

  int a = 1;
  int b = 2;
  int c = 3;
  int d = 4;

  int add_res;
  int sub_res;
  int sll_res;

  add_res = a + b;
  sub_res = d - c;
  sll_res = a << b;

  p1 = 0x0000;
  p2 = 0x0400;
  p3 = 0x0800;

  *p1 = add_res;
  *p2 = sub_res;
  *p3 = sll_res;

  return 0;
}

  

