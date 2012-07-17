c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine error

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c
c   compute the solution error
c
c---------------------------------------------------------------------

      implicit none

      include 'applu.incl'

c---------------------------------------------------------------------
c  local variables
c---------------------------------------------------------------------
      integer i, j, k, m
      double precision  tmp
      double precision  u000ijk(5)
      double precision  errnm_local(5)


      do m = 1, 5
         errnm(m) = 0.0d+00
      end do

!$omp parallel default(shared) private(i,j,k,m,tmp,u000ijk,errnm_local)
      do m = 1, 5
         errnm_local(m) = 0.0d+00
      end do
!$omp do
      do k = 2, nz-1
         do j = jst, jend
            do i = ist, iend
               call exact( i, j, k, u000ijk )
               do m = 1, 5
                  tmp = ( u000ijk(m) - u(m,i,j,k) )
                  errnm_local(m) = errnm_local(m) + tmp * tmp
               end do
            end do
         end do
      end do
!$omp end do nowait
      do m = 1, 5
!$omp atomic
         errnm(m) = errnm(m) + errnm_local(m)
      end do
!$omp end parallel

      do m = 1, 5
         errnm(m) = sqrt ( errnm(m) / ( (nx0-2)*(ny0-2)*(nz0-2) ) )
      end do

c        write (*,1002) ( errnm(m), m = 1, 5 )

 1002 format (1x/1x,'RMS-norm of error in soln. to ',
     > 'first pde  = ',1pe12.5/,
     > 1x,'RMS-norm of error in soln. to ',
     > 'second pde = ',1pe12.5/,
     > 1x,'RMS-norm of error in soln. to ',
     > 'third pde  = ',1pe12.5/,
     > 1x,'RMS-norm of error in soln. to ',
     > 'fourth pde = ',1pe12.5/,
     > 1x,'RMS-norm of error in soln. to ',
     > 'fifth pde  = ',1pe12.5)

      return
      end
