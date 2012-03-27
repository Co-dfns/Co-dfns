c---------------------------------------------------------------------
      double precision function randlc (x, a)
c---------------------------------------------------------------------

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
c
c   This routine should produce the same results on any computer with at least
c   48 mantissa bits in double precision floating point data.  On 64 bit
c   systems, double precision should be disabled.
c
c   David H. Bailey     October 26, 1990
c
c---------------------------------------------------------------------

      implicit none

      double precision r23,r46,t23,t46,a,x,t1,t2,t3,t4,a1,a2,x1,x2,z
      parameter (r23 = 0.5d0 ** 23, r46 = r23 ** 2, t23 = 2.d0 ** 23,
     >  t46 = t23 ** 2)

c---------------------------------------------------------------------
c   Break A into two parts such that A = 2^23 * A1 + A2.
c---------------------------------------------------------------------
      t1 = r23 * a
      a1 = int (t1)
      a2 = a - t23 * a1

c---------------------------------------------------------------------
c   Break X into two parts such that X = 2^23 * X1 + X2, compute
c   Z = A1 * X2 + A2 * X1  (mod 2^23), and then
c   X = 2^23 * Z + A2 * X2  (mod 2^46).
c---------------------------------------------------------------------
      t1 = r23 * x
      x1 = int (t1)
      x2 = x - t23 * x1


      t1 = a1 * x2 + a2 * x1
      t2 = int (r23 * t1)
      z = t1 - t23 * t2
      t3 = t23 * z + a2 * x2
      t4 = int (r46 * t3)
      x = t3 - t46 * t4
      randlc = r46 * x
      return
      end



c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine vranlc (n, x, a, y)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c   This routine generates N uniform pseudorandom double precision numbers in
c   the range (0, 1) by using the linear congruential generator
c   
c   x_{k+1} = a x_k  (mod 2^46)
c   
c   where 0 < x_k < 2^46 and 0 < a < 2^46.  This scheme generates 2^44 numbers
c   before repeating.  The argument A is the same as 'a' in the above formula,
c   and X is the same as x_0.  A and X must be odd double precision integers
c   in the range (1, 2^46).  The N results are placed in Y and are normalized
c   to be between 0 and 1.  X is updated to contain the new seed, so that
c   subsequent calls to RANDLC using the same arguments will generate a
c   continuous sequence.
c   
c   This routine generates the output sequence in batches of length NV, for
c   convenience on vector computers.  This routine should produce the same
c   results on any computer with at least 48 mantissa bits in double precision
c   floating point data.  On Cray systems, double precision should be disabled.
c   
c   David H. Bailey    August 30, 1990
c---------------------------------------------------------------------

      integer n
      double precision x, a, y(*)
      
      double precision r23, r46, t23, t46
      integer nv
      parameter (r23 = 2.d0 ** (-23), r46 = r23 * r23, t23 = 2.d0 ** 23,
     >     t46 = t23 * t23, nv = 64)
      double precision  xv(nv), t1, t2, t3, t4, an, a1, a2, x1, x2, yy
      integer n1, i, j
      external randlc
      double precision randlc

c---------------------------------------------------------------------
c     Compute the first NV elements of the sequence using RANDLC.
c---------------------------------------------------------------------
      t1 = x
      n1 = min (n, nv)

      do  i = 1, n1
         xv(i) = t46 * randlc (t1, a)
      enddo

c---------------------------------------------------------------------
c     It is not necessary to compute AN, A1 or A2 unless N is greater than NV.
c---------------------------------------------------------------------
      if (n .gt. nv) then

c---------------------------------------------------------------------
c     Compute AN = AA ^ NV (mod 2^46) using successive calls to RANDLC.
c---------------------------------------------------------------------
         t1 = a
         t2 = r46 * a

         do  i = 1, nv - 1
            t2 = randlc (t1, a)
         enddo

         an = t46 * t2

c---------------------------------------------------------------------
c     Break AN into two parts such that AN = 2^23 * A1 + A2.
c---------------------------------------------------------------------
         t1 = r23 * an
         a1 = aint (t1)
         a2 = an - t23 * a1
      endif

c---------------------------------------------------------------------
c     Compute N pseudorandom results in batches of size NV.
c---------------------------------------------------------------------
      do  j = 0, n - 1, nv
         n1 = min (nv, n - j)

c---------------------------------------------------------------------
c     Compute up to NV results based on the current seed vector XV.
c---------------------------------------------------------------------
         do  i = 1, n1
            y(i+j) = r46 * xv(i)
         enddo

c---------------------------------------------------------------------
c     If this is the last pass through the 140 loop, it is not necessary to
c     update the XV vector.
c---------------------------------------------------------------------
         if (j + n1 .eq. n) goto 150

c---------------------------------------------------------------------
c     Update the XV vector by multiplying each element by AN (mod 2^46).
c---------------------------------------------------------------------
         do  i = 1, nv
            t1 = r23 * xv(i)
            x1 = aint (t1)
            x2 = xv(i) - t23 * x1
            t1 = a1 * x2 + a2 * x1
            t2 = aint (r23 * t1)
            yy = t1 - t23 * t2
            t3 = t23 * yy + a2 * x2
            t4 = aint (r46 * t3)
            xv(i) = t3 - t46 * t4
         enddo

      enddo

c---------------------------------------------------------------------
c     Save the last seed in X so that subsequent calls to VRANLC will generate
c     a continuous sequence.
c---------------------------------------------------------------------
 150  x = xv(n1)

      return
      end

c----- end of program ------------------------------------------------

