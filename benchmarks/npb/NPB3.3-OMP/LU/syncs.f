c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine sync_left( ldmx, ldmy, ldmz, v )

c---------------------------------------------------------------------
c   Thread synchronization for pipeline operation
c---------------------------------------------------------------------

      implicit none

      integer ldmx, ldmy, ldmz
      double precision  v( 5, ldmx/2*2+1, ldmy/2*2+1, ldmz)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      include 'npbparams.h'

      integer isync(0:isiz2), mthreadnum, iam
      common /threadinfo1/ isync
      common /threadinfo2/ mthreadnum, iam
!$omp threadprivate(/threadinfo2/)

      integer neigh


      if (iam .gt. 0 .and. iam .le. mthreadnum) then
         neigh = iam - 1
         do while (isync(neigh) .eq. 0)
!$omp flush(isync)
         end do
         isync(neigh) = 0
!$omp flush(isync,v)
      endif


      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine sync_right( ldmx, ldmy, ldmz, v )

c---------------------------------------------------------------------
c   Thread synchronization for pipeline operation
c---------------------------------------------------------------------

      implicit none

      integer ldmx, ldmy, ldmz
      double precision  v( 5, ldmx/2*2+1, ldmy/2*2+1, ldmz)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      include 'npbparams.h'

      integer isync(0:isiz2), mthreadnum, iam
      common /threadinfo1/ isync
      common /threadinfo2/ mthreadnum, iam
!$omp threadprivate(/threadinfo2/)


      if (iam .lt. mthreadnum) then
!$omp flush(isync,v)
         do while (isync(iam) .eq. 1)
!$omp flush(isync)
         end do
         isync(iam) = 1
!$omp flush(isync)
      endif


      return
      end
