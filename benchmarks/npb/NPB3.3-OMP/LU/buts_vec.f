c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine buts( ldmx, ldmy, ldmz,
     >                 nx, ny, nz, k,
     >                 omega,
     >                 v, tv,
     >                 d, udx, udy, udz,
     >                 ist, iend, jst, jend,
     >                 lst, lend )

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c
c   compute the regular-sparse, block upper triangular solution:
c
c                     v <-- ( U-inv ) * v
c
c---------------------------------------------------------------------

      implicit none

c---------------------------------------------------------------------
c  input parameters
c---------------------------------------------------------------------
      integer ldmx, ldmy, ldmz
      integer nx, ny, nz
      integer k
      double precision  omega
c---------------------------------------------------------------------
c   To improve cache performance, second two dimensions padded by 1 
c   for even number sizes only.  Only needed in v.
c---------------------------------------------------------------------
      double precision  v( 5,ldmx/2*2+1, ldmy/2*2+1, ldmz), 
     >        tv( 5, ldmx/2*2+1, ldmy),
     >        d( 5, 5, ldmx/2*2+1, ldmy),
     >        udx( 5, 5, ldmx/2*2+1, ldmy),
     >        udy( 5, 5, ldmx/2*2+1, ldmy),
     >        udz( 5, 5, ldmx/2*2+1, ldmy )
      integer ist, iend
      integer jst, jend
      integer lst, lend

c---------------------------------------------------------------------
c  local variables
c---------------------------------------------------------------------
      integer i, j, m, l, istp, iendp
      double precision  tmp, tmp1
      double precision  tmat(5,5)


!$omp do schedule(static)
      do j = jend, jst, -1
         do i = iend, ist, -1
            do m = 1, 5
                  tv( m, i, j ) = 
     >      omega * (  udz( m, 1, i, j ) * v( 1, i, j, k+1 )
     >               + udz( m, 2, i, j ) * v( 2, i, j, k+1 )
     >               + udz( m, 3, i, j ) * v( 3, i, j, k+1 )
     >               + udz( m, 4, i, j ) * v( 4, i, j, k+1 )
     >               + udz( m, 5, i, j ) * v( 5, i, j, k+1 ) )
            end do
         end do
      end do


      do l = lend, lst, -1
         istp  = max(l - jend, ist)
         iendp = min(l - jst, iend)

!dir$ ivdep
!$omp do schedule(static)
         do i = istp, iendp
            j = l - i

!!dir$ unroll 5
!   manually unroll the loop
!            do m = 1, 5
                  tv( 1, i, j ) = tv( 1, i, j )
     > + omega * ( udy( 1, 1, i, j ) * v( 1, i, j+1, k )
     >           + udx( 1, 1, i, j ) * v( 1, i+1, j, k )
     >           + udy( 1, 2, i, j ) * v( 2, i, j+1, k )
     >           + udx( 1, 2, i, j ) * v( 2, i+1, j, k )
     >           + udy( 1, 3, i, j ) * v( 3, i, j+1, k )
     >           + udx( 1, 3, i, j ) * v( 3, i+1, j, k )
     >           + udy( 1, 4, i, j ) * v( 4, i, j+1, k )
     >           + udx( 1, 4, i, j ) * v( 4, i+1, j, k )
     >           + udy( 1, 5, i, j ) * v( 5, i, j+1, k )
     >           + udx( 1, 5, i, j ) * v( 5, i+1, j, k ) )
                  tv( 2, i, j ) = tv( 2, i, j )
     > + omega * ( udy( 2, 1, i, j ) * v( 1, i, j+1, k )
     >           + udx( 2, 1, i, j ) * v( 1, i+1, j, k )
     >           + udy( 2, 2, i, j ) * v( 2, i, j+1, k )
     >           + udx( 2, 2, i, j ) * v( 2, i+1, j, k )
     >           + udy( 2, 3, i, j ) * v( 3, i, j+1, k )
     >           + udx( 2, 3, i, j ) * v( 3, i+1, j, k )
     >           + udy( 2, 4, i, j ) * v( 4, i, j+1, k )
     >           + udx( 2, 4, i, j ) * v( 4, i+1, j, k )
     >           + udy( 2, 5, i, j ) * v( 5, i, j+1, k )
     >           + udx( 2, 5, i, j ) * v( 5, i+1, j, k ) )
                  tv( 3, i, j ) = tv( 3, i, j )
     > + omega * ( udy( 3, 1, i, j ) * v( 1, i, j+1, k )
     >           + udx( 3, 1, i, j ) * v( 1, i+1, j, k )
     >           + udy( 3, 2, i, j ) * v( 2, i, j+1, k )
     >           + udx( 3, 2, i, j ) * v( 2, i+1, j, k )
     >           + udy( 3, 3, i, j ) * v( 3, i, j+1, k )
     >           + udx( 3, 3, i, j ) * v( 3, i+1, j, k )
     >           + udy( 3, 4, i, j ) * v( 4, i, j+1, k )
     >           + udx( 3, 4, i, j ) * v( 4, i+1, j, k )
     >           + udy( 3, 5, i, j ) * v( 5, i, j+1, k )
     >           + udx( 3, 5, i, j ) * v( 5, i+1, j, k ) )
                  tv( 4, i, j ) = tv( 4, i, j )
     > + omega * ( udy( 4, 1, i, j ) * v( 1, i, j+1, k )
     >           + udx( 4, 1, i, j ) * v( 1, i+1, j, k )
     >           + udy( 4, 2, i, j ) * v( 2, i, j+1, k )
     >           + udx( 4, 2, i, j ) * v( 2, i+1, j, k )
     >           + udy( 4, 3, i, j ) * v( 3, i, j+1, k )
     >           + udx( 4, 3, i, j ) * v( 3, i+1, j, k )
     >           + udy( 4, 4, i, j ) * v( 4, i, j+1, k )
     >           + udx( 4, 4, i, j ) * v( 4, i+1, j, k )
     >           + udy( 4, 5, i, j ) * v( 5, i, j+1, k )
     >           + udx( 4, 5, i, j ) * v( 5, i+1, j, k ) )
                  tv( 5, i, j ) = tv( 5, i, j )
     > + omega * ( udy( 5, 1, i, j ) * v( 1, i, j+1, k )
     >           + udx( 5, 1, i, j ) * v( 1, i+1, j, k )
     >           + udy( 5, 2, i, j ) * v( 2, i, j+1, k )
     >           + udx( 5, 2, i, j ) * v( 2, i+1, j, k )
     >           + udy( 5, 3, i, j ) * v( 3, i, j+1, k )
     >           + udx( 5, 3, i, j ) * v( 3, i+1, j, k )
     >           + udy( 5, 4, i, j ) * v( 4, i, j+1, k )
     >           + udx( 5, 4, i, j ) * v( 4, i+1, j, k )
     >           + udy( 5, 5, i, j ) * v( 5, i, j+1, k )
     >           + udx( 5, 5, i, j ) * v( 5, i+1, j, k ) )
!            end do

c---------------------------------------------------------------------
c   diagonal block inversion
c---------------------------------------------------------------------
!!dir$ unroll 5
!   manually unroll the loop
!            do m = 1, 5
               tmat( 1, 1 ) = d( 1, 1, i, j )
               tmat( 1, 2 ) = d( 1, 2, i, j )
               tmat( 1, 3 ) = d( 1, 3, i, j )
               tmat( 1, 4 ) = d( 1, 4, i, j )
               tmat( 1, 5 ) = d( 1, 5, i, j )
               tmat( 2, 1 ) = d( 2, 1, i, j )
               tmat( 2, 2 ) = d( 2, 2, i, j )
               tmat( 2, 3 ) = d( 2, 3, i, j )
               tmat( 2, 4 ) = d( 2, 4, i, j )
               tmat( 2, 5 ) = d( 2, 5, i, j )
               tmat( 3, 1 ) = d( 3, 1, i, j )
               tmat( 3, 2 ) = d( 3, 2, i, j )
               tmat( 3, 3 ) = d( 3, 3, i, j )
               tmat( 3, 4 ) = d( 3, 4, i, j )
               tmat( 3, 5 ) = d( 3, 5, i, j )
               tmat( 4, 1 ) = d( 4, 1, i, j )
               tmat( 4, 2 ) = d( 4, 2, i, j )
               tmat( 4, 3 ) = d( 4, 3, i, j )
               tmat( 4, 4 ) = d( 4, 4, i, j )
               tmat( 4, 5 ) = d( 4, 5, i, j )
               tmat( 5, 1 ) = d( 5, 1, i, j )
               tmat( 5, 2 ) = d( 5, 2, i, j )
               tmat( 5, 3 ) = d( 5, 3, i, j )
               tmat( 5, 4 ) = d( 5, 4, i, j )
               tmat( 5, 5 ) = d( 5, 5, i, j )
!            end do

            tmp1 = 1.0d+00 / tmat( 1, 1 )
            tmp = tmp1 * tmat( 2, 1 )
            tmat( 2, 2 ) =  tmat( 2, 2 )
     >           - tmp * tmat( 1, 2 )
            tmat( 2, 3 ) =  tmat( 2, 3 )
     >           - tmp * tmat( 1, 3 )
            tmat( 2, 4 ) =  tmat( 2, 4 )
     >           - tmp * tmat( 1, 4 )
            tmat( 2, 5 ) =  tmat( 2, 5 )
     >           - tmp * tmat( 1, 5 )
            tv( 2, i, j ) = tv( 2, i, j )
     >        - tv( 1, i, j ) * tmp

            tmp = tmp1 * tmat( 3, 1 )
            tmat( 3, 2 ) =  tmat( 3, 2 )
     >           - tmp * tmat( 1, 2 )
            tmat( 3, 3 ) =  tmat( 3, 3 )
     >           - tmp * tmat( 1, 3 )
            tmat( 3, 4 ) =  tmat( 3, 4 )
     >           - tmp * tmat( 1, 4 )
            tmat( 3, 5 ) =  tmat( 3, 5 )
     >           - tmp * tmat( 1, 5 )
            tv( 3, i, j ) = tv( 3, i, j )
     >        - tv( 1, i, j ) * tmp

            tmp = tmp1 * tmat( 4, 1 )
            tmat( 4, 2 ) =  tmat( 4, 2 )
     >           - tmp * tmat( 1, 2 )
            tmat( 4, 3 ) =  tmat( 4, 3 )
     >           - tmp * tmat( 1, 3 )
            tmat( 4, 4 ) =  tmat( 4, 4 )
     >           - tmp * tmat( 1, 4 )
            tmat( 4, 5 ) =  tmat( 4, 5 )
     >           - tmp * tmat( 1, 5 )
            tv( 4, i, j ) = tv( 4, i, j )
     >        - tv( 1, i, j ) * tmp

            tmp = tmp1 * tmat( 5, 1 )
            tmat( 5, 2 ) =  tmat( 5, 2 )
     >           - tmp * tmat( 1, 2 )
            tmat( 5, 3 ) =  tmat( 5, 3 )
     >           - tmp * tmat( 1, 3 )
            tmat( 5, 4 ) =  tmat( 5, 4 )
     >           - tmp * tmat( 1, 4 )
            tmat( 5, 5 ) =  tmat( 5, 5 )
     >           - tmp * tmat( 1, 5 )
            tv( 5, i, j ) = tv( 5, i, j )
     >        - tv( 1, i, j ) * tmp



            tmp1 = 1.0d+00 / tmat( 2, 2 )
            tmp = tmp1 * tmat( 3, 2 )
            tmat( 3, 3 ) =  tmat( 3, 3 )
     >           - tmp * tmat( 2, 3 )
            tmat( 3, 4 ) =  tmat( 3, 4 )
     >           - tmp * tmat( 2, 4 )
            tmat( 3, 5 ) =  tmat( 3, 5 )
     >           - tmp * tmat( 2, 5 )
            tv( 3, i, j ) = tv( 3, i, j )
     >        - tv( 2, i, j ) * tmp

            tmp = tmp1 * tmat( 4, 2 )
            tmat( 4, 3 ) =  tmat( 4, 3 )
     >           - tmp * tmat( 2, 3 )
            tmat( 4, 4 ) =  tmat( 4, 4 )
     >           - tmp * tmat( 2, 4 )
            tmat( 4, 5 ) =  tmat( 4, 5 )
     >           - tmp * tmat( 2, 5 )
            tv( 4, i, j ) = tv( 4, i, j )
     >        - tv( 2, i, j ) * tmp

            tmp = tmp1 * tmat( 5, 2 )
            tmat( 5, 3 ) =  tmat( 5, 3 )
     >           - tmp * tmat( 2, 3 )
            tmat( 5, 4 ) =  tmat( 5, 4 )
     >           - tmp * tmat( 2, 4 )
            tmat( 5, 5 ) =  tmat( 5, 5 )
     >           - tmp * tmat( 2, 5 )
            tv( 5, i, j ) = tv( 5, i, j )
     >        - tv( 2, i, j ) * tmp



            tmp1 = 1.0d+00 / tmat( 3, 3 )
            tmp = tmp1 * tmat( 4, 3 )
            tmat( 4, 4 ) =  tmat( 4, 4 )
     >           - tmp * tmat( 3, 4 )
            tmat( 4, 5 ) =  tmat( 4, 5 )
     >           - tmp * tmat( 3, 5 )
            tv( 4, i, j ) = tv( 4, i, j )
     >        - tv( 3, i, j ) * tmp

            tmp = tmp1 * tmat( 5, 3 )
            tmat( 5, 4 ) =  tmat( 5, 4 )
     >           - tmp * tmat( 3, 4 )
            tmat( 5, 5 ) =  tmat( 5, 5 )
     >           - tmp * tmat( 3, 5 )
            tv( 5, i, j ) = tv( 5, i, j )
     >        - tv( 3, i, j ) * tmp



            tmp1 = 1.0d+00 / tmat( 4, 4 )
            tmp = tmp1 * tmat( 5, 4 )
            tmat( 5, 5 ) =  tmat( 5, 5 )
     >           - tmp * tmat( 4, 5 )
            tv( 5, i, j ) = tv( 5, i, j )
     >        - tv( 4, i, j ) * tmp

c---------------------------------------------------------------------
c   back substitution
c---------------------------------------------------------------------
            tv( 5, i, j ) = tv( 5, i, j )
     >                      / tmat( 5, 5 )

            tv( 4, i, j ) = tv( 4, i, j )
     >           - tmat( 4, 5 ) * tv( 5, i, j )
            tv( 4, i, j ) = tv( 4, i, j )
     >                      / tmat( 4, 4 )

            tv( 3, i, j ) = tv( 3, i, j )
     >           - tmat( 3, 4 ) * tv( 4, i, j )
     >           - tmat( 3, 5 ) * tv( 5, i, j )
            tv( 3, i, j ) = tv( 3, i, j )
     >                      / tmat( 3, 3 )

            tv( 2, i, j ) = tv( 2, i, j )
     >           - tmat( 2, 3 ) * tv( 3, i, j )
     >           - tmat( 2, 4 ) * tv( 4, i, j )
     >           - tmat( 2, 5 ) * tv( 5, i, j )
            tv( 2, i, j ) = tv( 2, i, j )
     >                      / tmat( 2, 2 )

            tv( 1, i, j ) = tv( 1, i, j )
     >           - tmat( 1, 2 ) * tv( 2, i, j )
     >           - tmat( 1, 3 ) * tv( 3, i, j )
     >           - tmat( 1, 4 ) * tv( 4, i, j )
     >           - tmat( 1, 5 ) * tv( 5, i, j )
            tv( 1, i, j ) = tv( 1, i, j )
     >                      / tmat( 1, 1 )

            v( 1, i, j, k ) = v( 1, i, j, k ) - tv( 1, i, j )
            v( 2, i, j, k ) = v( 2, i, j, k ) - tv( 2, i, j )
            v( 3, i, j, k ) = v( 3, i, j, k ) - tv( 3, i, j )
            v( 4, i, j, k ) = v( 4, i, j, k ) - tv( 4, i, j )
            v( 5, i, j, k ) = v( 5, i, j, k ) - tv( 5, i, j )

        enddo
      end do

 
      return
      end
