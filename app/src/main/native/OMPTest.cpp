//
// Created by CHIH WEI LIN on 5/27/18.
//

#include <omp.h>
#include <jni.h>
#include "Log.h"
#include <string>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#define N       100000
#define THREADS 4

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT jstring JNICALL
Java_com_paramsen_torchtemple_MainActivity_stringFromOMPTest(JNIEnv *env, jobject jThis)
{
    lD("Hello OPENMP");
    #pragma omp parallel
    {
        auto res = omp_get_proc_bind();
        lD("bind %d\n", res);
       int cores = omp_get_num_procs(); /* total number of cores available */
       int tid = omp_get_thread_num(); /* the current thread ID */
       int total_threads = omp_get_num_threads(); /* total number of threads */
       int max_threads = omp_get_max_threads(); /* maximal number of threads can be requested in this Processor */
         if (tid == 0) {
             lD("%i : You have %d cores Processor.\n",tid, cores);
             lD("%i : OpenMP generated %d threads.[max = %d].\n",tid, total_threads, max_threads);
         }
         //printf("%i : This is print by thread[%i]\n",tid,tid);
        lD("%i : This is print by thread[%i]\n",tid,tid);
    }

    return env->NewStringUTF(" Hello From JNI !!!!!!!!");
}

#ifdef __cplusplus
}
#endif