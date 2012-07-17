c---------------------------------------------------------------------
c---------------------------------------------------------------------
      
      subroutine timer_clear(n)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none
      integer n
      
      double precision start(64), elapsed(64)
      common /tt/ start, elapsed
c$omp threadprivate(/tt/)

      elapsed(n) = 0.0
      return
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine timer_start(n)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none
      external         elapsed_time
      double precision elapsed_time
      integer n
      double precision start(64), elapsed(64)
      common /tt/ start, elapsed
c$omp threadprivate(/tt/)

      start(n) = elapsed_time()

      return
      end
      

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine timer_stop(n)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none
      external         elapsed_time
      double precision elapsed_time
      integer n
      double precision start(64), elapsed(64)
      common /tt/ start, elapsed
c$omp threadprivate(/tt/)
      double precision t, now
      now = elapsed_time()
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
c$omp threadprivate(/tt/)
      
      timer_read = elapsed(n)
      return
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------

      double precision function elapsed_time()

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none
c$    external         omp_get_wtime
c$    double precision omp_get_wtime

      double precision t
      logical          mp

c ... Use the OpenMP timer if we can (via C$ conditional compilation)
      mp = .false.
c$    mp = .true.
c$    t = omp_get_wtime()

      if (.not.mp) then
c This function must measure wall clock time, not CPU time. 
c Since there is no portable timer in Fortran (77)
c we call a routine compiled in C (though the C source may have
c to be tweaked). 
         call wtime(t)
c The following is not ok for "official" results because it reports
c CPU time not wall clock time. It may be useful for developing/testing
c on timeshared Crays, though. 
c        call second(t)
      endif

      elapsed_time = t

      return
      end

