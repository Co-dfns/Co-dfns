
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
      integer i, j, k
      integer iglob, jglob

c---------------------------------------------------------------------
c   set the dependent variable values along the top and bottom faces
c---------------------------------------------------------------------
      do j = 1, ny
         jglob = jpt + j
         do i = 1, nx
           iglob = ipt + i
            call exact( iglob, jglob, 1, u( 1, i, j, 1 ) )
            call exact( iglob, jglob, nz, u( 1, i, j, nz ) )
         end do
      end do

c---------------------------------------------------------------------
c   set the dependent variable values along north and south faces
c---------------------------------------------------------------------
      IF (west.eq.-1) then
         do k = 1, nz
            do i = 1, nx
               iglob = ipt + i
               call exact( iglob, 1, k, u( 1, i, 1, k ) )
            end do
         end do
      END IF

      IF (east.eq.-1) then
          do k = 1, nz
             do i = 1, nx
                iglob = ipt + i
                call exact( iglob, ny0, k, u( 1, i, ny, k ) )
             end do
          end do
      END IF

c---------------------------------------------------------------------
c   set the dependent variable values along east and west faces
c---------------------------------------------------------------------
      IF (north.eq.-1) then
         do k = 1, nz
            do j = 1, ny
               jglob = jpt + j
               call exact( 1, jglob, k, u( 1, 1, j, k ) )
            end do
         end do
      END IF

      IF (south.eq.-1) then
         do k = 1, nz
            do j = 1, ny
                  jglob = jpt + j
            call exact( nx0, jglob, k, u( 1, nx, j, k ) )
            end do
         end do
      END IF

      return
      end
