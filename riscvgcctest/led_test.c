int main() {
  int a = 1;
  int * p;

  p = 0x00001000;

  *p = a;

  return 0;
}
