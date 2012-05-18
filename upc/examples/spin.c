#include <upc_relaxed.h>
#include <stdio.h>
    
int main() {
  printf("Hello from thread %i/%i\n", MYTHREAD, THREADS);
  
  for (int i = 0; i < 2^32; i++);

  upc_barrier;
  return 0;
}