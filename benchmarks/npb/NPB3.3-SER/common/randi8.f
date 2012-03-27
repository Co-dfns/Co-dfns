      double precision function randlc(x, a)

c---------------------------------------------------------------------
c
c   This routine returns a uniform pseudorandom double precision number in the
c   range (0, 1) by using the linear congruential generator
c
c   x_{k+1} = a x_k  (mod 2^46)
c
c   where 0 < x_k < 2^46 and 0 < a < 2^46.  This scheme generates 2^44 numbers
c   before repeating.  The argument A is the same as 'a' in the above formula,
c   and X is the same as x_0.  A and X must be odd double precision integers
c   in the range (1, 2^46).  The returned value RANDLC is normalized to be
c   between 0 and 1, i.e. RANDLC = 2^(-46) * x_1.  X is updated to contain
c   the new seed x_1, so that subsequent calls to RANDLC using the same
c   arguments will generate a continuous sequence.

      implicit none
      double precision x, a
      integer*8 i246m1, Lx, La
      double precision d2m46

      parameter(d2m46=0.5d0**46)

      save i246m1
      data i246m1/X'00003FFFFFFFFFFF'/

      Lx = X
      La = A

      Lx   = iand(Lx*La,i246m1)
      randlc = d2m46*dble(Lx)
      x    = dble(Lx)
      return
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------


      SUBROUTINE VRANLC (N, X, A, Y)
      implicit none
      integer n, i
      double precision x, a, y(*)
      integer*8 i246m1, Lx, La
      double precision d2m46

c This doesn't work, because the compiler does the calculation in 32
c bits and overflows. No standard way (without f90 stuff) to specify
c that the rhs should be done in 64 bit arithmetic. 
c      parameter(i246m1=2**46-1)

      parameter(d2m46=0.5d0**46)

      save i246m1
      data i246m1/X'00003FFFFFFFFFFF'/

c Note that the v6 compiler on an R8000 does something stupid with
c the above. Using the following instead (or various other things)
c makes the calculation run almost 10 times as fast. 
c 
c      save d2m46
c      data d2m46/0.0d0/
c      if (d2m46 .eq. 0.0d0) then
c         d2m46 = 0.5d0**46
c      endif

      Lx = X
      La = A
      do i = 1, N
         Lx   = iand(Lx*La,i246m1)
         y(i) = d2m46*dble(Lx)
      end do
      x    = dble(Lx)

      return
      end

