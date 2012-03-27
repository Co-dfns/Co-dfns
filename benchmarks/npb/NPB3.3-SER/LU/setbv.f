
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine setbv

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c   set the boundary values of dependent variables
c---------------------------------------------------------------------

      implicit none

      include 'applu.incl'

c---------------------------------------------------------------------
c   local variables
c---------------------------------------------------------------------
      integer i, j, k, m
      double precision temp1(5), temp2(5)

c---------------------------------------------------------------------
c   set the dependent variable values along the top and bottom faces
c---------------------------------------------------------------------
      do j = 1, ny
         do i = 1, nx
            call exact( i, j, 1, temp1 )
            call exact( i, j, nz, temp2 )
            do m = 1, 5
               u( m, i, j, 1 ) = temp1(m)
               u( m, i, j, nz ) = temp2(m)
            end do
         end do
      end do

c---------------------------------------------------------------------
c   set the dependent variable values along north and south faces
c---------------------------------------------------------------------
      do k = 1, nz
         do i = 1, nx
            call exact( i, 1, k, temp1 )
            call exact( i, ny, k, temp2 )
            do m = 1, 5
               u( m, i, 1, k ) = temp1(m)
               u( m, i, ny, k ) = temp2(m)
            end do
         end do
      end do

c---------------------------------------------------------------------
c   set the dependent variable values along east and west faces
c---------------------------------------------------------------------
      do k = 1, nz
         do j = 1, ny
            call exact( 1, j, k, temp1 )
            call exact( nx, j, k, temp2 )
            do m = 1, 5
               u( m, 1, j, k ) = temp1(m)
               u( m, nx, j, k ) = temp2(m)
            end do
         end do
      end do

      return
      end
