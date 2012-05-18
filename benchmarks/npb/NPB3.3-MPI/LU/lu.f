!-------------------------------------------------------------------------!
!                                                                         !
!        N  A  S     P A R A L L E L     B E N C H M A R K S  3.3         !
!                                                                         !
!                                   L U                                   !
!                                                                         !
!-------------------------------------------------------------------------!
!                                                                         !
!    This benchmark is part of the NAS Parallel Benchmark 3.3 suite.      !
!    It is described in NAS Technical Reports 95-020 and 02-007           !
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
c Authors: S. Weeratunga
c          V. Venkatakrishnan
c          E. Barszcz
c          M. Yarrow
c
c---------------------------------------------------------------------

c---------------------------------------------------------------------
      program applu
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c
c   driver for the performance evaluation of the solver for
c   five coupled parabolic/elliptic partial differential equations.
c
c---------------------------------------------------------------------

      implicit none

      include 'mpinpb.h'
      include 'applu.incl'
      character class
      logical verified
      double precision mflops, timer_read
      integer i, ierr
      double precision tsum(t_last+2), t1(t_last+2),
     >                 tming(t_last+2), tmaxg(t_last+2)
      character        t_recs(t_last+2)*8

      data t_recs/'total', 'rhs', 'blts', 'buts', 'jacld', 'jacu', 
     >            'exch', 'lcomm', 'ucomm', 'rcomm',
     >            ' totcomp', ' totcomm'/

c---------------------------------------------------------------------
c   initialize communications
c---------------------------------------------------------------------
      call init_comm()

c---------------------------------------------------------------------
c   read input data
c---------------------------------------------------------------------
      call read_input()

      do i = 1, t_last
         call timer_clear(i)
      end do

c---------------------------------------------------------------------
c   set up processor grid
c---------------------------------------------------------------------
      call proc_grid()

c---------------------------------------------------------------------
c   determine the neighbors
c---------------------------------------------------------------------
      call neighbors()

c---------------------------------------------------------------------
c   set up sub-domain sizes
c---------------------------------------------------------------------
      call subdomain()

c---------------------------------------------------------------------
c   set up coefficients
c---------------------------------------------------------------------
      call setcoeff()

c---------------------------------------------------------------------
c   set the boundary values for dependent variables
c---------------------------------------------------------------------
      call setbv()

c---------------------------------------------------------------------
c   set the initial values for dependent variables
c---------------------------------------------------------------------
      call setiv()

c---------------------------------------------------------------------
c   compute the forcing term based on prescribed exact solution
c---------------------------------------------------------------------
      call erhs()

c---------------------------------------------------------------------
c   perform one SSOR iteration to touch all data and program pages 
c---------------------------------------------------------------------
      call ssor(1)

c---------------------------------------------------------------------
c   reset the boundary and initial values
c---------------------------------------------------------------------
      call setbv()
      call setiv()

c---------------------------------------------------------------------
c   perform the SSOR iterations
c---------------------------------------------------------------------
      call ssor(itmax)

c---------------------------------------------------------------------
c   compute the solution error
c---------------------------------------------------------------------
      call error()

c---------------------------------------------------------------------
c   compute the surface integral
c---------------------------------------------------------------------
      call pintgr()

c---------------------------------------------------------------------
c   verification test
c---------------------------------------------------------------------
      IF (id.eq.0) THEN
         call verify ( rsdnm, errnm, frc, class, verified )
         mflops = float(itmax)*(1984.77*float( nx0 )
     >        *float( ny0 )
     >        *float( nz0 )
     >        -10923.3*(float( nx0+ny0+nz0 )/3.)**2 
     >        +27770.9* float( nx0+ny0+nz0 )/3.
     >        -144010.)
     >        / (maxtime*1000000.)

         call print_results('LU', class, nx0,
     >     ny0, nz0, itmax, nnodes_compiled,
     >     num, maxtime, mflops, '          floating point', verified, 
     >     npbversion, compiletime, cs1, cs2, cs3, cs4, cs5, cs6, 
     >     '(none)')

      END IF

      if (.not.timeron) goto 999

      do i = 1, t_last
         t1(i) = timer_read(i)
      end do
      t1(t_rhs) = t1(t_rhs) - t1(t_exch)
      t1(t_last+2) = t1(t_lcomm)+t1(t_ucomm)+t1(t_rcomm)+t1(t_exch)
      t1(t_last+1) = t1(t_total) - t1(t_last+2)

      call MPI_Reduce(t1, tsum,  t_last+2, dp_type, MPI_SUM, 
     >                0, MPI_COMM_WORLD, ierr)
      call MPI_Reduce(t1, tming, t_last+2, dp_type, MPI_MIN, 
     >                0, MPI_COMM_WORLD, ierr)
      call MPI_Reduce(t1, tmaxg, t_last+2, dp_type, MPI_MAX, 
     >                0, MPI_COMM_WORLD, ierr)

      if (id .eq. 0) then
         write(*, 800) num
         do i = 1, t_last+2
            tsum(i) = tsum(i) / num
            write(*, 810) i, t_recs(i), tming(i), tmaxg(i), tsum(i)
         end do
      endif
 800  format(' nprocs =', i6, 11x, 'minimum', 5x, 'maximum', 
     >       5x, 'average')
 810  format(' timer ', i2, '(', A8, ') :', 3(2x,f10.4))

 999  continue
      call mpi_finalize(ierr)
      end


