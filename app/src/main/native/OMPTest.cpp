//
// Created by CHIH WEI LIN on 5/27/18.
//

#include <omp.h>
#include <jni.h>
#include "Log.h"
#include <string.h>
#define NCORES 4

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT jstring JNICALL
Java_com_paramsen_torchtemple_MainActivity_stringFromJNI(JNIEnv *env, jobject jThis)
{
    lD("Hello OPENMP");
    omp_set_num_threads(4);
    #pragma omp parallel
    {
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