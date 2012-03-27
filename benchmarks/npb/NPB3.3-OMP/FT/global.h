      include 'npbparams.h'


c If processor array is 1x1 -> 0D grid decomposition


c Cache blocking params. These values are good for most
c RISC processors.  
c FFT parameters:
c  fftblock controls how many ffts are done at a time. 
c  The default is appropriate for most cache-based machines
c  On vector machines, the FFT can be vectorized with vector
c  length equal to the block size, so the block size should
c  be as large as possible. This is the size of the smallest
c  dimension of the problem: 128 for class A, 256 for class B and
c  512 for class C.

      integer fftblock_default, fftblockpad_default
c      parameter (fftblock_default=16, fftblockpad_default=18)
      parameter (fftblock_default=32, fftblockpad_default=33)
      
      integer fftblock, fftblockpad
      common /blockinfo/ fftblock, fftblockpad

c we need a bunch of logic to keep track of how
c arrays are laid out. 


c Note: this serial version is the derived from the parallel 0D case
c of the ft NPB.
c The computation proceeds logically as

c set up initial conditions
c fftx(1)
c transpose (1->2)
c ffty(2)
c transpose (2->3)
c fftz(3)
c time evolution
c fftz(3)
c transpose (3->2)
c ffty(2)
c transpose (2->1)
c fftx(1)
c compute residual(1)

c for the 0D, 1D, 2D strategies, the layouts look like xxx
c        
c            0D        1D        2D
c 1:        xyz       xyz       xyz

c the array dimensions are stored in dims(coord, phase)
      integer dims(3)
      common /layout/ dims

      integer T_total, T_setup, T_fft, T_evolve, T_checksum, 
     >        T_fftx, T_ffty,
     >        T_fftz, T_max
      parameter (T_total = 1, T_setup = 2, T_fft = 3, 
     >           T_evolve = 4, T_checksum = 5, 
     >           T_fftx = 6,
     >           T_ffty = 7,
     >           T_fftz = 8, T_max = 8)



      logical timers_enabled


      external timer_read
      double precision timer_read
      external ilog2
      integer ilog2

      external randlc
      double precision randlc


c other stuff
      logical debug, debugsynch
      common /dbg/ debug, debugsynch, timers_enabled

      double precision seed, a, pi, alpha
      parameter (seed = 314159265.d0, a = 1220703125.d0, 
     >  pi = 3.141592653589793238d0, alpha=1.0d-6)


c roots of unity array
c relies on x being largest dimension?
      double complex u(nxp)
      common /ucomm/ u


c for checksum data
      double complex sums(0:niter_default)
      common /sumcomm/ sums

c number of iterations
      integer niter
      common /iter/ niter
