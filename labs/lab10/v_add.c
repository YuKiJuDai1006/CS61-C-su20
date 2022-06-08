#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define ARRAY_SIZE 10000000
#define REPEAT     100


void v_add_naive(double* x, double* y, double* z) {
	#pragma omp parallel
	{
		for(int i=0; i<ARRAY_SIZE; i++)
			z[i] = x[i] + y[i];
	}
}

// Edit this function (Method 1) 
void v_add_optimized_adjacent(double* x, double* y, double* z) {
     #pragma omp parallel
	{
		int total = omp_get_num_threads();
		int signal = omp_get_thread_num();
		for(int i=signal; i<ARRAY_SIZE; i+=total)
				z[i] = x[i] + y[i];
	}
}

// Edit this function (Method 2) 
void v_add_optimized_chunks(double* x, double* y, double* z) {
          #pragma omp parallel
	{
		int total = omp_get_num_threads();
		int signal = omp_get_thread_num();
		int start = ARRAY_SIZE / total * signal;
		int end = ARRAY_SIZE / total * (signal + 1);
		for(int i=start; i<end; i++)
			z[i] = x[i] + y[i];
		
		if (signal == total - 1) {
			for (int i = ARRAY_SIZE / total * total; i < ARRAY_SIZE; i++)
				z[i] = x[i] + y[i];
		}
	}
}

double* gen_array(int n) {
	double* array = (double*) malloc(n*sizeof(double));
	for(int i=0; i<n; i++)
		array[i] = rand();
	return array;
}

// Double check if it is correct
int verify(double* x, double* y, void(*funct)(double *x, double *y, double *z)) {
	double *z_v_add = (double*) malloc(ARRAY_SIZE*sizeof(double));
	double *z_oracle = (double*) malloc(ARRAY_SIZE*sizeof(double));
	(*funct)(x, y, z_v_add);
	for(int i=0; i<ARRAY_SIZE; i++)
		z_oracle[i] = x[i] + y[i];
	for(int i=0; i<ARRAY_SIZE; i++)
		if(z_oracle[i] != z_v_add[i])
			return 0;	
	return 1;
}


int main() {
	// Generate input vectors and destination vector
	double *x = gen_array(ARRAY_SIZE);
	double *y = gen_array(ARRAY_SIZE);
	double *z = (double*) malloc(ARRAY_SIZE*sizeof(double));

	// Test framework that sweeps the number of threads and times each run
	double start_time, run_time;
	int num_threads = omp_get_max_threads();	


	for(int i=1; i<=num_threads; i++) {
		omp_set_num_threads(i);		
	  start_time = omp_get_wtime();
		for(int j=0; j<REPEAT; j++)
			v_add_optimized_adjacent(x,y,z);
		run_time = omp_get_wtime() - start_time;
    if(!verify(x,y, v_add_optimized_adjacent)){
      printf("v_add optimized adjacent does not match oracle\n");
      return -1; 
    }
    printf("Optimized adjacent: %d thread(s) took %f seconds\n",i,run_time);
  }


	for(int i=1; i<=num_threads; i++) {
		omp_set_num_threads(i);		
	  start_time = omp_get_wtime();
		for(int j=0; j<REPEAT; j++)
			v_add_optimized_chunks(x,y,z);
		run_time = omp_get_wtime() - start_time;
    if(!verify(x,y, v_add_optimized_chunks)){
      printf("v_add optimized chunks does not match oracle\n");
      return -1; 
    }
    printf("Optimized chunks: %d thread(s) took %f seconds\n",i,run_time);
  }

	for(int i=1; i<=num_threads; i++) {
		omp_set_num_threads(i);		
		start_time = omp_get_wtime();
		for(int j=0; j<REPEAT; j++)
			v_add_naive(x,y,z);
		run_time = omp_get_wtime() - start_time;
  	printf("Naive: %d thread(s) took %f seconds\n",i,run_time);
  }
  return 0;
}
 
/**
 * @brief Optimized adjacent: 1 thread(s) took 2.467000 seconds
Optimized adjacent: 2 thread(s) took 2.663000 seconds
Optimized adjacent: 3 thread(s) took 2.516000 seconds
Optimized adjacent: 4 thread(s) took 3.170000 seconds
Optimized adjacent: 5 thread(s) took 5.640000 seconds
Optimized adjacent: 6 thread(s) took 5.568000 seconds
Optimized adjacent: 7 thread(s) took 3.698000 seconds
Optimized adjacent: 8 thread(s) took 3.613000 seconds
Optimized adjacent: 9 thread(s) took 3.997000 seconds
Optimized adjacent: 10 thread(s) took 7.430000 seconds
Optimized adjacent: 11 thread(s) took 5.174000 seconds
Optimized adjacent: 12 thread(s) took 3.382000 seconds
Optimized chunks: 1 thread(s) took 2.431000 seconds
Optimized chunks: 2 thread(s) took 2.071000 seconds
Optimized chunks: 3 thread(s) took 2.015000 seconds
Optimized chunks: 4 thread(s) took 2.080000 seconds
Optimized chunks: 5 thread(s) took 2.260000 seconds
Optimized chunks: 6 thread(s) took 2.369000 seconds
Optimized chunks: 7 thread(s) took 3.019000 seconds
Optimized chunks: 8 thread(s) took 2.697000 seconds
Optimized chunks: 9 thread(s) took 2.459000 seconds
Optimized chunks: 10 thread(s) took 2.392000 seconds
Optimized chunks: 11 thread(s) took 2.641000 seconds
Optimized chunks: 12 thread(s) took 2.309000 seconds
Naive: 1 thread(s) took 2.355000 seconds
Naive: 2 thread(s) took 5.836000 seconds
Naive: 3 thread(s) took 8.686000 seconds
Naive: 4 thread(s) took 4.077000 seconds
Naive: 5 thread(s) took 3.652000 seconds
Naive: 6 thread(s) took 4.235000 seconds
Naive: 7 thread(s) took 12.334000 seconds
Naive: 8 thread(s) took 5.971000 seconds
Naive: 9 thread(s) took 4.812000 seconds
Naive: 10 thread(s) took 15.330000 seconds
Naive: 11 thread(s) took 9.498000 seconds
Naive: 12 thread(s) took 5.564000 seconds

 * 
 */
