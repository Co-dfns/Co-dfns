/*************************************************************************
 *                                                                       * 
 *       N  A  S     P A R A L L E L     B E N C H M A R K S  3.3        *
 *                                                                       *
 *                       S E R I A L    V E R S I O N                    * 
 *                                                                       * 
 *                                  I S                                  * 
 *                                                                       * 
 ************************************************************************* 
 *                                                                       * 
 *   This benchmark is a serial version of the NPB IS code.              *
 *   Refer to NAS Technical Reports 95-020 for details.                  *
 *                                                                       *
 *   Permission to use, copy, distribute and modify this software        *
 *   for any purpose with or without fee is hereby granted.  We          *
 *   request, however, that all derived work reference the NAS           *
 *   Parallel Benchmarks 3.3. This software is provided "as is"          *
 *   without express or implied warranty.                                *
 *                                                                       *
 *   Information on NPB 3.3, including the technical report, the         *
 *   original specifications, source code, results and information       *
 *   on how to submit new results, is available at:                      *
 *                                                                       *
 *          http://www.nas.nasa.gov/Software/NPB/                        *
 *                                                                       *
 *   Send comments or suggestions to  npb@nas.nasa.gov                   *
 *                                                                       *
 *         NAS Parallel Benchmarks Group                                 *
 *         NASA Ames Research Center                                     *
 *         Mail Stop: T27A-1                                             *
 *         Moffett Field, CA   94035-1000                                *
 *                                                                       *
 *         E-mail:  npb@nas.nasa.gov                                     *
 *         Fax:     (650) 604-3957                                       *
 *                                                                       *
 ************************************************************************* 
 *                                                                       * 
 *   Author: M. Yarrow                                                   * 
 *           H. Jin                                                      * 
 *                                                                       * 
 *************************************************************************/

#include "npbparams.h"
#include <stdlib.h>
#include <stdio.h>


/*****************************************************************/
/* For serial IS, buckets are not really req'd to solve NPB1 IS  */
/* spec, but their use on some machines improves performance, on */
/* other machines the use of buckets compromises performance,    */
/* probably because it is extra computation which is not req'd.  */
/* (Note: Mechanism not understood, probably cache related)      */
/* Example:  SP2-66MhzWN:  50% speedup with buckets              */
/* Example:  SGI Indy5000: 50% slowdown with buckets             */
/* Example:  SGI O2000:   400% slowdown with buckets (Wow!)      */
/*****************************************************************/
/* To disable the use of buckets, comment out the following line */
#define USE_BUCKETS


/******************/
/* default values */
/******************/
#ifndef CLASS
#define CLASS 'S'
#endif


/*************/
/*  CLASS S  */
/*************/
#if CLASS == 'S'
#define  TOTAL_KEYS_LOG_2    16
#define  MAX_KEY_LOG_2       11
#define  NUM_BUCKETS_LOG_2   9
#endif


/*************/
/*  CLASS W  */
/*************/
#if CLASS == 'W'
#define  TOTAL_KEYS_LOG_2    20
#define  MAX_KEY_LOG_2       16
#define  NUM_BUCKETS_LOG_2   10
#endif

/*************/
/*  CLASS A  */
/*************/
#if CLASS == 'A'
#define  TOTAL_KEYS_LOG_2    23
#define  MAX_KEY_LOG_2       19
#define  NUM_BUCKETS_LOG_2   10
#endif


/*************/
/*  CLASS B  */
/*************/
#if CLASS == 'B'
#define  TOTAL_KEYS_LOG_2    25
#define  MAX_KEY_LOG_2       21
#define  NUM_BUCKETS_LOG_2   10
#endif


/*************/
/*  CLASS C  */
/*************/
#if CLASS == 'C'
#define  TOTAL_KEYS_LOG_2    27
#define  MAX_KEY_LOG_2       23
#define  NUM_BUCKETS_LOG_2   10
#endif


/*************/
/*  CLASS D  */
/*************/
#if CLASS == 'D'
#define  TOTAL_KEYS_LOG_2    31
#define  MAX_KEY_LOG_2       27
#define  NUM_BUCKETS_LOG_2   10
#endif


#if CLASS == 'D'
#define  TOTAL_KEYS          (1L << TOTAL_KEYS_LOG_2)
#else
#define  TOTAL_KEYS          (1 << TOTAL_KEYS_LOG_2)
#endif
#define  MAX_KEY             (1 << MAX_KEY_LOG_2)
#define  NUM_BUCKETS         (1 << NUM_BUCKETS_LOG_2)
#define  NUM_KEYS            TOTAL_KEYS
#define  SIZE_OF_BUFFERS     NUM_KEYS  
                                           

#define  MAX_ITERATIONS      10
#define  TEST_ARRAY_SIZE     5


/*************************************/
/* Typedef: if necessary, change the */
/* size of int here by changing the  */
/* int type to, say, long            */
/*************************************/
#if CLASS == 'D'
typedef  long INT_TYPE;
#else
typedef  int  INT_TYPE;
#endif


/********************/
/* Some global info */
/********************/
INT_TYPE *key_buff_ptr_global;         /* used by full_verify to get */
                                       /* copies of rank info        */

int      passed_verification;
                                 

/************************************/
/* These are the three main arrays. */
/* See SIZE_OF_BUFFERS def above    */
/************************************/
INT_TYPE key_array[SIZE_OF_BUFFERS],    
         key_buff1[MAX_KEY],    
         key_buff2[SIZE_OF_BUFFERS],
         partial_verify_vals[TEST_ARRAY_SIZE];

#ifdef USE_BUCKETS
INT_TYPE bucket_size[NUM_BUCKETS],                    
         bucket_ptrs[NUM_BUCKETS];
#endif


/**********************/
/* Partial verif info */
/**********************/
INT_TYPE test_index_array[TEST_ARRAY_SIZE],
         test_rank_array[TEST_ARRAY_SIZE],

         S_test_index_array[TEST_ARRAY_SIZE] = 
                             {48427,17148,23627,62548,4431},
         S_test_rank_array[TEST_ARRAY_SIZE] = 
                             {0,18,346,64917,65463},

         W_test_index_array[TEST_ARRAY_SIZE] = 
                             {357773,934767,875723,898999,404505},
         W_test_rank_array[TEST_ARRAY_SIZE] = 
                             {1249,11698,1039987,1043896,1048018},

         A_test_index_array[TEST_ARRAY_SIZE] = 
                             {2112377,662041,5336171,3642833,4250760},
         A_test_rank_array[TEST_ARRAY_SIZE] = 
                             {104,17523,123928,8288932,8388264},

         B_test_index_array[TEST_ARRAY_SIZE] = 
                             {41869,812306,5102857,18232239,26860214},
         B_test_rank_array[TEST_ARRAY_SIZE] = 
                             {33422937,10244,59149,33135281,99}, 

         C_test_index_array[TEST_ARRAY_SIZE] = 
                             {44172927,72999161,74326391,129606274,21736814},
         C_test_rank_array[TEST_ARRAY_SIZE] = 
                             {61147,882988,266290,133997595,133525895},

         D_test_index_array[TEST_ARRAY_SIZE] = 
                             {1317351170,995930646,1157283250,1503301535,1453734525},
         D_test_rank_array[TEST_ARRAY_SIZE] = 
                             {1,36538729,1978098519,2145192618,2147425337};



/***********************/
/* function prototypes */
/***********************/
double	randlc( double *X, double *A );

void full_verify( void );

void c_print_results( char   *name,
                      char   class,
                      int    n1, 
                      int    n2,
                      int    n3,
                      int    niter,
                      double t,
                      double mops,
		      char   *optype,
                      int    passed_verification,
                      char   *npbversion,
                      char   *compiletime,
                      char   *cc,
                      char   *clink,
                      char   *c_lib,
                      char   *c_inc,
                      char   *cflags,
                      char   *clinkflags );


void    timer_clear( int n );
void    timer_start( int n );
void    timer_stop( int n );
double  timer_read( int n );


/*
 *    FUNCTION RANDLC (X, A)
 *
 *  This routine returns a uniform pseudorandom double precision number in the
 *  range (0, 1) by using the linear congruential generator
 *
 *  x_{k+1} = a x_k  (mod 2^46)
 *
 *  where 0 < x_k < 2^46 and 0 < a < 2^46.  This scheme generates 2^44 numbers
 *  before repeating.  The argument A is the same as 'a' in the above formula,
 *  and X is the same as x_0.  A and X must be odd double precision integers
 *  in the range (1, 2^46).  The returned value RANDLC is normalized to be
 *  between 0 and 1, i.e. RANDLC = 2^(-46) * x_1.  X is updated to contain
 *  the new seed x_1, so that subsequent calls to RANDLC using the same
 *  arguments will generate a continuous sequence.
 *
 *  This routine should produce the same results on any computer with at least
 *  48 mantissa bits in double precision floating point data.  On Cray systems,
 *  double precision should be disabled.
 *
 *  David H. Bailey     October 26, 1990
 *
 *     IMPLICIT DOUBLE PRECISION (A-H, O-Z)
 *     SAVE KS, R23, R46, T23, T46
 *     DATA KS/0/
 *
 *  If this is the first call to RANDLC, compute R23 = 2 ^ -23, R46 = 2 ^ -46,
 *  T23 = 2 ^ 23, and T46 = 2 ^ 46.  These are computed in loops, rather than
 *  by merely using the ** operator, in order to insure that the results are
 *  exact on all systems.  This code assumes that 0.5D0 is represented exactly.
 */


/*****************************************************************/
/*************           R  A  N  D  L  C             ************/
/*************                                        ************/
/*************    portable random number generator    ************/
/*****************************************************************/

double	randlc( double *X, double *A )
{
      static int        KS=0;
      static double	R23, R46, T23, T46;
      double		T1, T2, T3, T4;
      double		A1;
      double		A2;
      double		X1;
      double		X2;
      double		Z;
      int     		i, j;

      if (KS == 0) 
      {
        R23 = 1.0;
        R46 = 1.0;
        T23 = 1.0;
        T46 = 1.0;
    
        for (i=1; i<=23; i++)
        {
          R23 = 0.50 * R23;
          T23 = 2.0 * T23;
        }
        for (i=1; i<=46; i++)
        {
          R46 = 0.50 * R46;
          T46 = 2.0 * T46;
        }
        KS = 1;
      }

/*  Break A into two parts such that A = 2^23 * A1 + A2 and set X = N.  */

      T1 = R23 * *A;
      j  = T1;
      A1 = j;
      A2 = *A - T23 * A1;

/*  Break X into two parts such that X = 2^23 * X1 + X2, compute
    Z = A1 * X2 + A2 * X1  (mod 2^23), and then
    X = 2^23 * Z + A2 * X2  (mod 2^46).                            */

      T1 = R23 * *X;
      j  = T1;
      X1 = j;
      X2 = *X - T23 * X1;
      T1 = A1 * X2 + A2 * X1;
      
      j  = R23 * T1;
      T2 = j;
      Z = T1 - T23 * T2;
      T3 = T23 * Z + A2 * X2;
      j  = R46 * T3;
      T4 = j;
      *X = T3 - T46 * T4;
      return(R46 * *X);
} 




/*****************************************************************/
/*************      C  R  E  A  T  E  _  S  E  Q      ************/
/*****************************************************************/

void	create_seq( double seed, double a )
{
	double x;
	int    i, k;

        k = MAX_KEY/4;

	for (i=0; i<NUM_KEYS; i++)
	{
	    x = randlc(&seed, &a);
	    x += randlc(&seed, &a);
    	    x += randlc(&seed, &a);
	    x += randlc(&seed, &a);  

            key_array[i] = k*x;
	}
}




/*****************************************************************/
/*************    F  U  L  L  _  V  E  R  I  F  Y     ************/
/*****************************************************************/


void full_verify( void )
{
    INT_TYPE    i, j;


    
/*  Now, finally, sort the keys:  */

#ifdef USE_BUCKETS

    /* key_buff2[] already has the proper information, so do nothing */

#else

/*  Copy keys into work array; keys in key_array will be reassigned. */
    for( i=0; i<NUM_KEYS; i++ )
        key_buff2[i] = key_array[i];

#endif

    for( i=0; i<NUM_KEYS; i++ )
        key_array[--key_buff_ptr_global[key_buff2[i]]] = key_buff2[i];


/*  Confirm keys correctly sorted: count incorrectly sorted keys, if any */

    j = 0;
    for( i=1; i<NUM_KEYS; i++ )
        if( key_array[i-1] > key_array[i] )
            j++;


    if( j != 0 )
    {
        printf( "Full_verify: number of keys out of sort: %ld\n",
                (long)j );
    }
    else
        passed_verification++;
           

}




/*****************************************************************/
/*************             R  A  N  K             ****************/
/*****************************************************************/


void rank( int iteration )
{

    INT_TYPE    i, k;

    INT_TYPE    *key_buff_ptr, *key_buff_ptr2;

#ifdef USE_BUCKETS
    int shift = MAX_KEY_LOG_2 - NUM_BUCKETS_LOG_2;
    INT_TYPE    key;
#endif


    key_array[iteration] = iteration;
    key_array[iteration+MAX_ITERATIONS] = MAX_KEY - iteration;


/*  Determine where the partial verify test keys are, load into  */
/*  top of array bucket_size                                     */
    for( i=0; i<TEST_ARRAY_SIZE; i++ )
        partial_verify_vals[i] = key_array[test_index_array[i]];

#ifdef USE_BUCKETS

/*  Initialize */
    for( i=0; i<NUM_BUCKETS; i++ )  
        bucket_size[i] = 0;

/*  Determine the number of keys in each bucket */
    for( i=0; i<NUM_KEYS; i++ )
        bucket_size[key_array[i] >> shift]++;


/*  Accumulative bucket sizes are the bucket pointers */
    bucket_ptrs[0] = 0;
    for( i=1; i< NUM_BUCKETS; i++ )  
        bucket_ptrs[i] = bucket_ptrs[i-1] + bucket_size[i-1];


/*  Sort into appropriate bucket */
    for( i=0; i<NUM_KEYS; i++ )  
    {
        key = key_array[i];
        key_buff2[bucket_ptrs[key >> shift]++] = key;
    }

    key_buff_ptr2 = key_buff2;

#else

    key_buff_ptr2 = key_array;

#endif

/*  Clear the work array */
    for( i=0; i<MAX_KEY; i++ )
        key_buff1[i] = 0;


/*  Ranking of all keys occurs in this section:                 */

    key_buff_ptr = key_buff1;

/*  In this section, the keys themselves are used as their 
    own indexes to determine how many of each there are: their
    individual population                                       */

    for( i=0; i<NUM_KEYS; i++ )
        key_buff_ptr[key_buff_ptr2[i]]++;  /* Now they have individual key   */
                                       /* population                     */

/*  To obtain ranks of each key, successively add the individual key
    population                                                  */


    for( i=0; i<MAX_KEY-1; i++ )   
        key_buff_ptr[i+1] += key_buff_ptr[i];  


/* This is the partial verify test section */
/* Observe that test_rank_array vals are   */
/* shifted differently for different cases */
    for( i=0; i<TEST_ARRAY_SIZE; i++ )
    {                                             
        k = partial_verify_vals[i];          /* test vals were put here */
        if( 0 < k  &&  k <= NUM_KEYS-1 )
        {
            INT_TYPE key_rank = key_buff_ptr[k-1];
            int failed = 0;

            switch( CLASS )
            {
                case 'S':
                    if( i <= 2 )
                    {
                        if( key_rank != test_rank_array[i]+iteration )
                            failed = 1;
                        else
                            passed_verification++;
                    }
                    else
                    {
                        if( key_rank != test_rank_array[i]-iteration )
                            failed = 1;
                        else
                            passed_verification++;
                    }
                    break;
                case 'W':
                    if( i < 2 )
                    {
                        if( key_rank != test_rank_array[i]+(iteration-2) )
                            failed = 1;
                        else
                            passed_verification++;
                    }
                    else
                    {
                        if( key_rank != test_rank_array[i]-iteration )
                            failed = 1;
                        else
                            passed_verification++;
                    }
                    break;
                case 'A':
                    if( i <= 2 )
        	    {
                        if( key_rank != test_rank_array[i]+(iteration-1) )
                            failed = 1;
                        else
                            passed_verification++;
        	    }
                    else
                    {
                        if( key_rank != test_rank_array[i]-(iteration-1) )
                            failed = 1;
                        else
                            passed_verification++;
                    }
                    break;
                case 'B':
                    if( i == 1 || i == 2 || i == 4 )
        	    {
                        if( key_rank != test_rank_array[i]+iteration )
                            failed = 1;
                        else
                            passed_verification++;
        	    }
                    else
                    {
                        if( key_rank != test_rank_array[i]-iteration )
                            failed = 1;
                        else
                            passed_verification++;
                    }
                    break;
                case 'C':
                    if( i <= 2 )
        	    {
                        if( key_rank != test_rank_array[i]+iteration )
                            failed = 1;
                        else
                            passed_verification++;
        	    }
                    else
                    {
                        if( key_rank != test_rank_array[i]-iteration )
                            failed = 1;
                        else
                            passed_verification++;
                    }
                    break;
                case 'D':
                    if( i < 2 )
        	    {
                        if( key_rank != test_rank_array[i]+iteration )
                            failed = 1;
                        else
                            passed_verification++;
        	    }
                    else
                    {
                        if( key_rank != test_rank_array[i]-iteration )
                            failed = 1;
                        else
                            passed_verification++;
                    }
                    break;
            }
            if( failed == 1 )
                printf( "Failed partial verification: "
                        "iteration %d, test key %d\n", 
                         iteration, (int)i );
        }
    }




/*  Make copies of rank info for use by full_verify: these variables
    in rank are local; making them global slows down the code, probably
    since they cannot be made register by compiler                        */

    if( iteration == MAX_ITERATIONS ) 
        key_buff_ptr_global = key_buff_ptr;

}      


/*****************************************************************/
/*************             M  A  I  N             ****************/
/*****************************************************************/

int main( int argc, char **argv )
{

    int             i, iteration, timer_on;

    double          timecounter;

    FILE            *fp;


/*  Initialize timers  */
    timer_on = 0;            
    if ((fp = fopen("timer.flag", "r")) != NULL) {
        fclose(fp);
        timer_on = 1;
    }
    timer_clear( 0 );
    if (timer_on) {
        timer_clear( 1 );
        timer_clear( 2 );
        timer_clear( 3 );
    }

    if (timer_on) timer_start( 3 );


/*  Initialize the verification arrays if a valid class */
    for( i=0; i<TEST_ARRAY_SIZE; i++ )
        switch( CLASS )
        {
            case 'S':
                test_index_array[i] = S_test_index_array[i];
                test_rank_array[i]  = S_test_rank_array[i];
                break;
            case 'A':
                test_index_array[i] = A_test_index_array[i];
                test_rank_array[i]  = A_test_rank_array[i];
                break;
            case 'W':
                test_index_array[i] = W_test_index_array[i];
                test_rank_array[i]  = W_test_rank_array[i];
                break;
            case 'B':
                test_index_array[i] = B_test_index_array[i];
                test_rank_array[i]  = B_test_rank_array[i];
                break;
            case 'C':
                test_index_array[i] = C_test_index_array[i];
                test_rank_array[i]  = C_test_rank_array[i];
                break;
            case 'D':
                test_index_array[i] = D_test_index_array[i];
                test_rank_array[i]  = D_test_rank_array[i];
                break;
        };

        

/*  Printout initial NPB info */
    printf
      ( "\n\n NAS Parallel Benchmarks (NPB3.3-SER) - IS Benchmark\n\n" );
    printf( " Size:  %ld  (class %c)\n", (long)TOTAL_KEYS, CLASS );
    printf( " Iterations:   %d\n", MAX_ITERATIONS );

    if (timer_on) timer_start( 1 );

/*  Generate random number sequence and subsequent keys on all procs */
    create_seq( 314159265.00,                    /* Random number gen seed */
                1220703125.00 );                 /* Random number gen mult */
    if (timer_on) timer_stop( 1 );


/*  Do one interation for free (i.e., untimed) to guarantee initialization of  
    all data and code pages and respective tables */
    rank( 1 );  

/*  Start verification counter */
    passed_verification = 0;

    if( CLASS != 'S' ) printf( "\n   iteration\n" );

/*  Start timer  */             
    timer_start( 0 );


/*  This is the main iteration */
    for( iteration=1; iteration<=MAX_ITERATIONS; iteration++ )
    {
        if( CLASS != 'S' ) printf( "        %d\n", iteration );
        rank( iteration );
    }


/*  End of timing, obtain maximum time of all processors */
    timer_stop( 0 );
    timecounter = timer_read( 0 );


/*  This tests that keys are in sequence: sorting of last ranked key seq
    occurs here, but is an untimed operation                             */
    if (timer_on) timer_start( 2 );
    full_verify();
    if (timer_on) timer_stop( 2 );

    if (timer_on) timer_stop( 3 );


/*  The final printout  */
    if( passed_verification != 5*MAX_ITERATIONS + 1 )
        passed_verification = 0;
    c_print_results( "IS",
                     CLASS,
                     (int)(TOTAL_KEYS/64),
                     64,
                     0,
                     MAX_ITERATIONS,
                     timecounter,
                     ((double) (MAX_ITERATIONS*TOTAL_KEYS))
                                                  /timecounter/1000000.,
                     "keys ranked", 
                     passed_verification,
                     NPBVERSION,
                     COMPILETIME,
                     CC,
                     CLINK,
                     C_LIB,
                     C_INC,
                     CFLAGS,
                     CLINKFLAGS );


/*  Print additional timers  */
    if (timer_on) {
       double t_total, t_percent;

       t_total = timer_read( 3 );
       printf("\nAdditional timers -\n");
       printf(" Total execution: %8.3f\n", t_total);
       if (t_total == 0.0) t_total = 1.0;
       timecounter = timer_read(1);
       t_percent = timecounter/t_total * 100.;
       printf(" Initialization : %8.3f (%5.2f%%)\n", timecounter, t_percent);
       timecounter = timer_read(0);
       t_percent = timecounter/t_total * 100.;
       printf(" Benchmarking   : %8.3f (%5.2f%%)\n", timecounter, t_percent);
       timecounter = timer_read(2);
       t_percent = timecounter/t_total * 100.;
       printf(" Sorting        : %8.3f (%5.2f%%)\n", timecounter, t_percent);
    }


    return 0;
         /**************************/
}        /*  E N D  P R O G R A M  */
         /**************************/




