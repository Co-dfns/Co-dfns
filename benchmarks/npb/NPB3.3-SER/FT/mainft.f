!-------------------------------------------------------------------------!
!                                                                         !
!        N  A  S     P A R A L L E L     B E N C H M A R K S  3.3         !
!                                                                         !
!                      S E R I A L     V E R S I O N                      !
!                                                                         !
!                                   F T                                   !
!                                                                         !
!-------------------------------------------------------------------------!
!                                                                         !
!    This benchmark is a serial version of the NPB FT code.               !
!    Refer to NAS Technical Reports 95-020 for details.                   !
!                                                                         !
!    Permission to use, copy, distribute and modify this software         !
!    for any purpose with or without fee is hereby granted.  We           !
!    request, however, that all derived work reference the NAS            !
!    Parallel Benchmarks 3.3. This software is provided "as is"           !
!    without express or implied warranty.                                 !
!                                                                         !
!    Information on NPB 3.3, including the technical report, the          !
!    original specifications, source code, results and information        !
!    on how to submit new results, is available at:                       !
!                                                                         !
!           http://www.nas.nasa.gov/Software/NPB/                         !
!                                                                         !
!    Send comments or suggestions to  npb@nas.nasa.gov                    !
!                                                                         !
!          NAS Parallel Benchmarks Group                                  !
!          NASA Ames Research Center                                      !
!          Mail Stop: T27A-1                                              !
!          Moffett Field, CA   94035-1000                                 !
!                                                                         !
!          E-mail:  npb@nas.nasa.gov                                      !
!          Fax:     (650) 604-3957                                        !
!                                                                         !
!-------------------------------------------------------------------------!

c---------------------------------------------------------------------
c
c Authors: D. Bailey
c          W. Saphir
c
c          M. Frumkin
c
c---------------------------------------------------------------------

c---------------------------------------------------------------------

c---------------------------------------------------------------------
c FT benchmark
c---------------------------------------------------------------------
      program mainft
         implicit none
         include 'global.h'

         integer i, niter, fstatus
         character class
         double precision total_time, mflops
         logical verified

         open (unit=2,file='timer.flag',status='old',iostat=fstatus)
         if (fstatus .eq. 0) then
            timers_enabled = .true.
            close(2)
         else
            timers_enabled = .false.
         endif

         niter=niter_default

         write(*, 1000)
         write(*, 1001) nx, ny, nz
         write(*, 1002) niter
         write(*, *)

 1000    format(//,' NAS Parallel Benchmarks (NPB3.3-SER)',
     >          ' - FT Benchmark', /)
 1001    format(' Size                : ', i4, 'x', i4, 'x', i4)
 1002    format(' Iterations          :     ', i10)

         call getclass(class)
!
         call appft (niter, total_time, verified)
!
         if( total_time .ne. 0. ) then
           mflops = 1.0d-6*float(ntotal) *
     >             (14.8157+7.19641*log(float(ntotal))
     >          +  (5.23518+7.21113*log(float(ntotal)))*niter)
     >                 /total_time
         else
           mflops = 0.0
         endif
         call print_results('FT', class, nx, ny, nz, niter,
     >      total_time, mflops, '          floating point', verified, 
     >      npbversion, compiletime, cs1, cs2, cs3, cs4, 
     >      cs5, cs6, cs7)
!
      end
      
      subroutine getclass(class)
        implicit none
        include 'npbparams.h'
        character class
        if ((nx .eq. 64) .and. (ny .eq. 64) .and.                 
     &      (nz .eq. 64) .and. (niter_default .eq. 6)) then
          class='S'
        else if ((nx .eq. 128) .and. (ny .eq. 128) .and.
     &           (nz .eq. 32) .and. (niter_default .eq. 6)) then
          class='W'
        else if ((nx .eq. 256) .and. (ny .eq. 256) .and.
     &           (nz .eq. 128) .and. (niter_default .eq. 6)) then
          class='A'
        else if ((nx .eq. 512) .and. (ny .eq. 256) .and.
     &           (nz .eq. 256) .and. (niter_default .eq. 20)) then
          class='B'
        else if ((nx .eq. 512) .and. (ny .eq. 512) .and.
     &           (nz .eq. 512) .and. (niter_default .eq. 20)) then
          class='C'
        else if ((nx .eq. 2048) .and. (ny .eq. 1024) .and.
     &           (nz .eq. 1024) .and. (niter_default .eq. 25)) then
          class='D'
        else
          class='U'
        endif

        return
      end
      
