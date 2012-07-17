c---------------------------------------------------------------------
c compute the roots-of-unity array that will be used for subsequent FFTs. 
c---------------------------------------------------------------------
      subroutine CompExp (n, exponent)

      implicit none
      integer n
      double complex exponent(n) 
      integer ilog2
      external ilog2      
     
      integer m,nu,ku,i,j,ln
      double precision t, ti, pi 
      data pi /3.141592653589793238d0/

      nu = n
      m = ilog2(n)
      exponent(1) = m
      ku = 2
      ln = 1
      do j = 1, m
         t = pi / ln
         do i = 0, ln - 1
            ti = i * t
            exponent(i+ku) = dcmplx(cos(ti),sin(ti))
         enddo        
         ku = ku + ln
         ln = 2 * ln
      enddo
            
      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------
c---------------------------------------------------------------------
      integer function ilog2(n)
      implicit none
      integer n
c---------------------------------------------------------------------
c---------------------------------------------------------------------  
      integer nn, lg
      if (n .eq. 1) then
         ilog2=0
         return
      endif
      lg = 1
      nn = 2
      do while (nn .lt. n)
         nn = nn*2
         lg = lg+1
      end do
      ilog2 = lg
      return
      end
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine ipow46(a, exponent, result)
c---------------------------------------------------------------------
c compute a^exponent mod 2^46
c---------------------------------------------------------------------

      implicit none
      double precision a, result, dummy, q, r
      integer exponent, n, n2
      external randlc
      double precision randlc
c---------------------------------------------------------------------
c Use
c   a^n = a^(n/2)*a^(n/2) if n even else
c   a^n = a*a^(n-1)       if n odd
c---------------------------------------------------------------------
      result = 1
      if (exponent .eq. 0) return
      q = a
      r = 1
      n = exponent

      do while (n .gt. 1)
         n2 = n/2
         if (n2 * 2 .eq. n) then
            dummy = randlc(q, q) 
            n = n2
         else
            dummy = randlc(r, q)
            n = n-1
         endif
      end do
      dummy = randlc(r, q)
      result = r
      return
      end
c---------------------------------------------------------------------
      subroutine CalculateChecksum(csum,iterN,u,d1,d2,d3)
        implicit none
        integer iterN
        integer d1,d2,d3
        double complex csum
        double complex u(d1+1,d2,d3)
        integer i, i1, ii, ji, ki
        csum = dcmplx (0.0, 0.0)
        do i = 1, 1024
          i1 = i
          ii = mod (i1, d1) + 1
          ji = mod (3 * i1, d2) + 1
          ki = mod (5 * i1, d3) + 1
          csum = csum + u(ii,ji,ki)
        end do
        csum = csum/dble(d1*d2*d3)
        write(*,30) iterN, csum
 30     format (' T =',I5,5X,'Checksum =',1P2D22.12)
      return
      end
c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine compute_initial_conditions(u0,d1,d2,d3)

      implicit none
      include 'npbparams.h'
      integer d1,d2,d3
      double complex u0(d1+1,d2,d3), tmp(maxdim)
      double precision x0, start, an, dummy
      double precision RanStarts(maxdim)

      integer i,j,k
      double precision seed, a
      parameter (seed = 314159265.d0, a = 1220703125.d0)
      external randlc
      double precision randlc
      
      start = seed                                    
c---------------------------------------------------------------------
c Jump to the starting element for our first plane.
c---------------------------------------------------------------------
      call ipow46(a, 0, an)
      dummy = randlc(start, an)
      call ipow46(a, 2*d1*d2, an)
c---------------------------------------------------------------------
c Go through by z planes filling in one square at a time.
c---------------------------------------------------------------------
      RanStarts(1) = start
      do k = 2, d3 
         dummy = randlc(start, an)
         RanStarts(k) = start
      end do
      
      do k = 1, d3 
         x0 = RanStarts(k)
         do j = 1, d2 
           call vranlc(2*d1, x0, a, tmp)
           do i = 1, d1 
             u0(i,j,k)=tmp(i)
           end do
         end do
      end do

      return
      end
c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine evolve(x,y,twiddle,nx,ny,nz)
      implicit none
      integer nx,ny,nz
      double complex x(nx+1,ny,nz),y(nx+1,ny,nz)
      real*8 twiddle(nx+1,ny,nz)
      integer i,j,k
           do i = 1, nz
             do k = 1, ny
               do j = 1, nx
                   y(j,k,i)=y(j,k,i)*twiddle(j,k,i)
                   x(j,k,i)=y(j,k,i)
                 end do
              end do
           end do
      
      return
      end
c---------------------------------------------------------------------
c---------------------------------------------------------------------
