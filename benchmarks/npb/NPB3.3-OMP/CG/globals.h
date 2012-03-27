      include 'npbparams.h'

c---------------------------------------------------------------------
c  Note: please observe that in the routine conj_grad three 
c  implementations of the sparse matrix-vector multiply have
c  been supplied.  The default matrix-vector multiply is not
c  loop unrolled.  The alternate implementations are unrolled
c  to a depth of 2 and unrolled to a depth of 8.  Please
c  experiment with these to find the fastest for your particular
c  architecture.  If reporting timing results, any of these three may
c  be used without penalty.
c---------------------------------------------------------------------


c---------------------------------------------------------------------
c  Class specific parameters: 
c  It appears here for reference only.
c  These are their values, however, this info is imported in the npbparams.h
c  include file, which is written by the sys/setparams.c program.
c---------------------------------------------------------------------

C----------
C  Class S:
C----------
CC       parameter( na=1400, 
CC      >           nonzer=7, 
CC      >           shift=10., 
CC      >           niter=15,
CC      >           rcond=1.0d-1 )
C----------
C  Class W:
C----------
CC       parameter( na=7000,
CC      >           nonzer=8, 
CC      >           shift=12., 
CC      >           niter=15,
CC      >           rcond=1.0d-1 )
C----------
C  Class A:
C----------
CC       parameter( na=14000,
CC      >           nonzer=11, 
CC      >           shift=20., 
CC      >           niter=15,
CC      >           rcond=1.0d-1 )
C----------
C  Class B:
C----------
CC       parameter( na=75000, 
CC      >           nonzer=13, 
CC      >           shift=60., 
CC      >           niter=75,
CC      >           rcond=1.0d-1 )
C----------
C  Class C:
C----------
CC       parameter( na=150000, 
CC      >           nonzer=15, 
CC      >           shift=110., 
CC      >           niter=75,
CC      >           rcond=1.0d-1 )
C----------
C  Class D:
C----------
CC       parameter( na=1500000, 
CC      >           nonzer=21, 
CC      >           shift=500., 
CC      >           niter=100,
CC      >           rcond=1.0d-1 )
C----------
C  Class E:
C----------
CC       parameter( na=9000000, 
CC      >           nonzer=26, 
CC      >           shift=1500., 
CC      >           niter=100,
CC      >           rcond=1.0d-1 )


      integer    nz, naz
      parameter( nz = na*(nonzer+1)*(nonzer+1) )
      parameter( naz = na*(nonzer+1) )


      common / partit_size  /  naa, nzz, 
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol
      integer                  naa, nzz, 
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol

      common /urando/          amult, tran
      double precision         amult, tran
!$omp threadprivate (/urando/)

      external         timer_read
      double precision timer_read

      integer T_init, T_bench, T_conj_grad, T_last
      parameter (T_init=1, T_bench=2, T_conj_grad=3, T_last=3)
      logical timeron
      common /timers/ timeron
