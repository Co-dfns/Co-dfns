c---------------------------------------------------------------------
c---------------------------------------------------------------------
      
      subroutine timer_clear(n)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none
      integer n
      
      double precision start(64), elapsed(64)
      common /tt/ start, elapsed

      elapsed(n) = 0.0
      return
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine timer_start(n)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none
      integer n
      include 'mpif.h'
      double precision start(64), elapsed(64)
      common /tt/ start, elapsed

      start(n) = MPI_Wtime()

      return
      end
      

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine timer_stop(n)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none
      integer n
      include 'mpif.h'
      double precision start(64), elapsed(64)
      common /tt/ start, elapsed
      double precision t, now
      now = MPI_Wtime()
      t = now - start(n)
      elapsed(n) = elapsed(n) + t

      return
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------

      double precision function timer_read(n)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none
      integer n
      double precision start(64), elapsed(64)
      common /tt/ start, elapsed
      
      timer_read = elapsed(n)
      return
      end

