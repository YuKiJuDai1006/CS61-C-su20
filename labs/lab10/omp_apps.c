#include "omp_apps.h"

/* -------------------------------Dot Product------------------------------*/
double* gen_array(int n) {
  double* array = (double*)malloc(n * sizeof(double));
  for (int i = 0; i < n; i++) array[i] = rand();
  return array;
}

double dotp_naive(double* x, double* y, int arr_size) {
  double global_sum = 0.0;
#pragma omp parallel
  {
#pragma omp for
    for (int i = 0; i < arr_size; i++)
#pragma omp critical
      global_sum += x[i] * y[i];
  }
  return global_sum;
}

// EDIT THIS FUNCTION PART 1
double dotp_manual_optimized(double* x, double* y, int arr_size) {
  double global_sum = 0.0;
  int total;
  int signal;
  int start;
  int end;
#pragma omp parallel private(signal, start, end)
  {
    total = omp_get_num_threads();
    signal = omp_get_thread_num();
    start = arr_size / total * signal;
		end = arr_size / total * (signal + 1);
#pragma omp critical
		for(int i=start; i<end; i++)
		    global_sum += x[i] * y[i];
		if (signal == total - 1) {
			for (int i = arr_size / total * total; i < arr_size; i++)
				global_sum += x[i] * y[i];
		}
  }
  return global_sum;
}

// EDIT THIS FUNCTION PART 2
double dotp_reduction_optimized(double* x, double* y, int arr_size) {
  double global_sum = 0.0;
#pragma omp parallel for reduction(+ : global_sum)
    for (int i = 0; i < arr_size; i++)
      global_sum += x[i] * y[i];
  return global_sum;
}

char* compute_dotp(int arr_size) {
  // Generate input vectors
  char* report_buf = (char*)malloc(BUF_SIZE), *pos = report_buf;
  double start_time, run_time;

  double *x = gen_array(arr_size), *y = gen_array(arr_size);
  double serial_result = 0.0, result = 0.0;

  // calculate result serially
  for (int i = 0; i < arr_size; i++) {
    serial_result += x[i] * y[i];
  }

  int num_threads = omp_get_max_threads();
  for (int i = 1; i <= num_threads; i++) {
    omp_set_num_threads(i);
    start_time = omp_get_wtime();
    for (int j = 0; j < REPEAT; j++) result = dotp_manual_optimized(x, y, arr_size);
    run_time = omp_get_wtime() - start_time;
    pos += sprintf(pos, "Manual Optimized: %d thread(s) took %f seconds\n", i, run_time);

    // verify result is correct (within some threshold)
    if (fabs(serial_result - result) > 0.001) {
      pos += sprintf(pos, "Incorrect result!\n");
      *pos = '\0';
      return report_buf;
    }
  }

  for (int i = 1; i <= num_threads; i++) {
    omp_set_num_threads(i);
    start_time = omp_get_wtime();

    for (int j = 0; j < REPEAT; j++) {
      result = dotp_reduction_optimized(x, y, arr_size);
    }

    run_time = omp_get_wtime() - start_time;
    pos += sprintf(pos, "Reduction Optimized: %d thread(s) took %f seconds\n",
                   i, run_time);

    // verify result is correct (within some threshold)
    if (fabs(serial_result - result) > 0.001) {
      pos += sprintf(pos, "Incorrect result!\n");
      *pos = '\0';
      return report_buf;
    }
  }

  // Only run this once because it's too slow..
  omp_set_num_threads(1);
  start_time = omp_get_wtime();
  for (int j = 0; j < REPEAT; j++) result = dotp_naive(x, y, arr_size);
  run_time = omp_get_wtime() - start_time;

  pos += sprintf(pos, "Naive: %d thread(s) took %f seconds\n", 1, run_time);
  *pos = '\0';
  return report_buf;
}


/* ---------------------Image Processing: Sobel Edge Detector----------------------*/
int sobel[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
void sobel_filter(bmp_pixel **src, bmp_pixel **dst, int row, int col) {
   int res = 0;
   for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
         bmp_pixel pxl = src[row - 1 + i][col - 1 + j];
         res += ((int)pxl.blue + (int)pxl.green + (int)pxl.red) * sobel[i][j];
      }
   }
   res *= 2;    // scale a little bit so the result image is brighter.
   res = res < 0? 0 : (res > 255? 255 : res);
   bmp_pixel_init(&dst[row][col], res, res, res);
}

char *image_proc(const char* filename) {
   bmp_img img, img_copy;
   if (bmp_img_read(&img, filename) != 0)
      return 0;

   char *res= (char*)calloc(32, sizeof(char));
   strncat(res, filename, strlen(filename) - 4);
   strcat(res, "_sobel.bmp");

   bmp_img_read(&img_copy, filename);

   unsigned int wid = img.img_header.biWidth;
   unsigned int hgt = img.img_header.biHeight;
   bmp_img_init_df(&img_copy, wid, hgt);

   // To parallelize this for loops, check out scheduling policy: http://jakascorner.com/blog/2016/06/omp-for-scheduling.html
   // and omp collapse directive https://software.intel.com/en-us/articles/openmp-loop-collapse-directive
   for (int i = 1; i < hgt-1; i++) {
      for (int j = 1; j < wid-1; j++) {
         sobel_filter(img.img_pixels, img_copy.img_pixels, i, j);
      }
   }
   bmp_img_write(&img_copy, res);
   bmp_img_free(&img_copy);
   bmp_img_free(&img);
   return res;
}

/**
 * @brief Manual Optimized: 1 thread(s) took 2.424000 seconds
Manual Optimized: 2 thread(s) took 2.449000 seconds
Manual Optimized: 3 thread(s) took 2.436000 seconds
Manual Optimized: 4 thread(s) took 2.510000 seconds
Manual Optimized: 5 thread(s) took 2.520000 seconds
Manual Optimized: 6 thread(s) took 2.609000 seconds
Manual Optimized: 7 thread(s) took 2.611000 seconds
Manual Optimized: 8 thread(s) took 2.485000 seconds
Manual Optimized: 9 thread(s) took 2.472000 seconds
Manual Optimized: 10 thread(s) took 2.463000 seconds
Manual Optimized: 11 thread(s) took 2.474000 seconds
Manual Optimized: 12 thread(s) took 2.529000 seconds
Reduction Optimized: 1 thread(s) took 2.321000 seconds
Reduction Optimized: 2 thread(s) took 1.212000 seconds
Reduction Optimized: 3 thread(s) took 1.256000 seconds
Reduction Optimized: 4 thread(s) took 1.181000 seconds
Reduction Optimized: 5 thread(s) took 1.086000 seconds
Reduction Optimized: 6 thread(s) took 1.274000 seconds
Reduction Optimized: 7 thread(s) took 1.153000 seconds
Reduction Optimized: 8 thread(s) took 1.221000 seconds
Reduction Optimized: 9 thread(s) took 1.070000 seconds
Reduction Optimized: 10 thread(s) took 1.050000 seconds
Reduction Optimized: 11 thread(s) took 1.055000 seconds
Reduction Optimized: 12 thread(s) took 1.051000 seconds
Naive: 1 thread(s) took 21.446000 seconds

 * 
 */