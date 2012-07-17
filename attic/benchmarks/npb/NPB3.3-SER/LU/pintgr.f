
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine pintgr

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none

      include 'applu.incl'

c---------------------------------------------------------------------
c  local variables
c---------------------------------------------------------------------
      integer i, j, k
      integer ibeg, ifin, ifin1
      integer jbeg, jfin, jfin1
      double precision  phi1(0:isiz2+1,0:isiz3+1),
     >                  phi2(0:isiz2+1,0:isiz3+1)
      double precision  frc1, frc2, frc3



c---------------------------------------------------------------------
c   set up the sub-domains for integeration in each processor
c---------------------------------------------------------------------
      ibeg = ii1
      ifin = ii2
      jbeg = ji1
      jfin = ji2
      ifin1 = ifin - 1
      jfin1 = jfin - 1

c---------------------------------------------------------------------
c   initialize
c---------------------------------------------------------------------
      do i = 0,isiz2+1
        do k = 0,isiz3+1
          phi1(i,k) = 0.
          phi2(i,k) = 0.
        end do
      end do

      do j = jbeg,jfin
         do i = ibeg,ifin

            k = ki1

            phi1(i,j) = c2*(  u(5,i,j,k)
     >           - 0.50d+00 * (  u(2,i,j,k) ** 2
     >                         + u(3,i,j,k) ** 2
     >                         + u(4,i,j,k) ** 2 )
     >                        / u(1,i,j,k) )

            k = ki2

            phi2(i,j) = c2*(  u(5,i,j,k)
     >           - 0.50d+00 * (  u(2,i,j,k) ** 2
     >                         + u(3,i,j,k) ** 2
     >                         + u(4,i,j,k) ** 2 )
     >                        / u(1,i,j,k) )
         end do
      end do


      frc1 = 0.0d+00

      do j = jbeg,jfin1
         do i = ibeg, ifin1
            frc1 = frc1 + (  phi1(i,j)
     >                     + phi1(i+1,j)
     >                     + phi1(i,j+1)
     >                     + phi1(i+1,j+1)
     >                     + phi2(i,j)
     >                     + phi2(i+1,j)
     >                     + phi2(i,j+1)
     >                     + phi2(i+1,j+1) )
         end do
      end do


      frc1 = dxi * deta * frc1

c---------------------------------------------------------------------
c   initialize
c---------------------------------------------------------------------
      do i = 0,isiz2+1
        do k = 0,isiz3+1
          phi1(i,k) = 0.
          phi2(i,k) = 0.
        end do
      end do
      if (jbeg.eq.ji1) then
        do k = ki1, ki2
           do i = ibeg, ifin
              phi1(i,k) = c2*(  u(5,i,jbeg,k)
     >             - 0.50d+00 * (  u(2,i,jbeg,k) ** 2
     >                           + u(3,i,jbeg,k) ** 2
     >                           + u(4,i,jbeg,k) ** 2 )
     >                          / u(1,i,jbeg,k) )
           end do
        end do
      end if

      if (jfin.eq.ji2) then
        do k = ki1, ki2
           do i = ibeg, ifin
              phi2(i,k) = c2*(  u(5,i,jfin,k)
     >             - 0.50d+00 * (  u(2,i,jfin,k) ** 2
     >                           + u(3,i,jfin,k) ** 2
     >                           + u(4,i,jfin,k) ** 2 )
     >                          / u(1,i,jfin,k) )
           end do
        end do
      end if


      frc2 = 0.0d+00
      do k = ki1, ki2-1
         do i = ibeg, ifin1
            frc2 = frc2 + (  phi1(i,k)
     >                     + phi1(i+1,k)
     >                     + phi1(i,k+1)
     >                     + phi1(i+1,k+1)
     >                     + phi2(i,k)
     >                     + phi2(i+1,k)
     >                     + phi2(i,k+1)
     >                     + phi2(i+1,k+1) )
         end do
      end do


      frc2 = dxi * dzeta * frc2

c---------------------------------------------------------------------
c   initialize
c---------------------------------------------------------------------
      do i = 0,isiz2+1
        do k = 0,isiz3+1
          phi1(i,k) = 0.
          phi2(i,k) = 0.
        end do
      end do
      if (ibeg.eq.ii1) then
        do k = ki1, ki2
           do j = jbeg, jfin
              phi1(j,k) = c2*(  u(5,ibeg,j,k)
     >             - 0.50d+00 * (  u(2,ibeg,j,k) ** 2
     >                           + u(3,ibeg,j,k) ** 2
     >                           + u(4,ibeg,j,k) ** 2 )
     >                          / u(1,ibeg,j,k) )
           end do
        end do
      end if

      if (ifin.eq.ii2) then
        do k = ki1, ki2
           do j = jbeg, jfin
              phi2(j,k) = c2*(  u(5,ifin,j,k)
     >             - 0.50d+00 * (  u(2,ifin,j,k) ** 2
     >                           + u(3,ifin,j,k) ** 2
     >                           + u(4,ifin,j,k) ** 2 )
     >                          / u(1,ifin,j,k) )
           end do
        end do
      end if


      frc3 = 0.0d+00

      do k = ki1, ki2-1
         do j = jbeg, jfin1
            frc3 = frc3 + (  phi1(j,k)
     >                     + phi1(j+1,k)
     >                     + phi1(j,k+1)
     >                     + phi1(j+1,k+1)
     >                     + phi2(j,k)
     >                     + phi2(j+1,k)
     >                     + phi2(j,k+1)
     >                     + phi2(j+1,k+1) )
         end do
      end do


      frc3 = deta * dzeta * frc3
      frc = 0.25d+00 * ( frc1 + frc2 + frc3 )
c      write (*,1001) frc

      return

c 1001 format (//5x,'surface integral = ',1pe12.5//)

      end
