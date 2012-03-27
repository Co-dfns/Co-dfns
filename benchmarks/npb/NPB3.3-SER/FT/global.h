      include 'npbparams.h'

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

      integer fftblock_default, fftblockpad_default, 
     &        CacheSize,BlockMax
      parameter (fftblock_default=16, 
     &           fftblockpad_default=18,
     &           CacheSize=8192,
     &           BlockMax=32)
      
      integer fftblock, fftblockpad
      common /blockinfo/ fftblock, fftblockpad

      external timer_read
      double precision timer_read
      external ilog2
      integer ilog2

      external randlc
      double precision randlc
      
      double complex  plane((BlockMax+1)*maxdim),pad(128),
     &                scr(BlockMax+1,maxdim)
      common /workarr/ plane,pad,scr

      double precision seed, a, pi, alpha
      parameter (seed = 314159265.d0, a = 1220703125.d0, 
     .  pi = 3.141592653589793238d0, alpha=1.0d-6)

c for checksum data
      double complex sums(0:niter_default)
      common /sumcomm/ sums

      logical timers_enabled
      common /timerscomm/ timers_enabled
