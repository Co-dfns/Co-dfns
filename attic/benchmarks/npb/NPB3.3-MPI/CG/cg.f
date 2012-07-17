!-------------------------------------------------------------------------!
!                                                                         !
!        N  A  S     P A R A L L E L     B E N C H M A R K S  3.3         !
!                                                                         !
!                                   C G                                   !
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
c Authors: M. Yarrow
c          C. Kuszmaul
c          R. F. Van der Wijngaart
c          H. Jin
c
c---------------------------------------------------------------------


c---------------------------------------------------------------------
c---------------------------------------------------------------------
      program cg
c---------------------------------------------------------------------
c---------------------------------------------------------------------


      implicit none

      include 'mpinpb.h'
      include 'timing.h'
      integer status(MPI_STATUS_SIZE), request, ierr

      include 'npbparams.h'

c---------------------------------------------------------------------
c  num_procs must be a power of 2, and num_procs=num_proc_cols*num_proc_rows.
c  num_proc_cols and num_proc_cols are to be found in npbparams.h.
c  When num_procs is not square, then num_proc_cols must be = 2*num_proc_rows.
c---------------------------------------------------------------------
      integer    num_procs 
      parameter( num_procs = num_proc_cols * num_proc_rows )



c---------------------------------------------------------------------
c  Class specific parameters: 
c  It appears here for reference only.
c  These are their values, however, this info is imported in the npbparams.h
c  include file, which is written by the sys/setparams.c program.
c---------------------------------------------------------------------

C----------
C  Class S:
C----------
CC       parameter( na=1400, 
CC      >           nonzer=7, 
CC      >           shift=10., 
CC      >           niter=15,
CC      >           rcond=1.0d-1 )
C----------
C  Class W:
C----------
CC       parameter( na=7000,
CC      >           nonzer=8, 
CC      >           shift=12., 
CC      >           niter=15,
CC      >           rcond=1.0d-1 )
C----------
C  Class A:
C----------
CC       parameter( na=14000,
CC      >           nonzer=11, 
CC      >           shift=20., 
CC      >           niter=15,
CC      >           rcond=1.0d-1 )
C----------
C  Class B:
C----------
CC       parameter( na=75000, 
CC      >           nonzer=13, 
CC      >           shift=60., 
CC      >           niter=75,
CC      >           rcond=1.0d-1 )
C----------
C  Class C:
C----------
CC       parameter( na=150000, 
CC      >           nonzer=15, 
CC      >           shift=110., 
CC      >           niter=75,
CC      >           rcond=1.0d-1 )
C----------
C  Class D:
C----------
CC       parameter( na=1500000, 
CC      >           nonzer=21, 
CC      >           shift=500., 
CC      >           niter=100,
CC      >           rcond=1.0d-1 )
C----------
C  Class E:
C----------
CC       parameter( na=9000000, 
CC      >           nonzer=26, 
CC      >           shift=1500., 
CC      >           niter=100,
CC      >           rcond=1.0d-1 )



      integer    nz
      parameter( nz = na*(nonzer+1)/num_procs*(nonzer+1)+nonzer
     >              + na*(nonzer+2+num_procs/256)/num_proc_cols )



      common / partit_size  /  naa, nzz, 
     >                         npcols, nprows,
     >                         proc_col, proc_row,
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol,
     >                         exch_proc,
     >                         exch_recv_length,
     >                         send_start,
     >                         send_len
      integer                  naa, nzz, 
     >                         npcols, nprows,
     >                         proc_col, proc_row,
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol,
     >                         exch_proc,
     >                         exch_recv_length,
     >                         send_start,
     >                         send_len


      common / main_int_mem /  colidx,     rowstr,
     >                         iv,         arow,     acol
      integer                  colidx(nz), rowstr(na+1),
     >                         iv(2*na+1), arow(nz), acol(nz)


      common / main_flt_mem /  v,       aelt,     a,
     >                         x,
     >                         z,
     >                         p,
     >                         q,
     >                         r,
     >                         w
      double precision         v(na+1), aelt(nz), a(nz),
     >                         x(na/num_proc_rows+2),
     >                         z(na/num_proc_rows+2),
     >                         p(na/num_proc_rows+2),
     >                         q(na/num_proc_rows+2),
     >                         r(na/num_proc_rows+2),
     >                         w(na/num_proc_rows+2)


      common /urando/          amult, tran
      double precision         amult, tran



      integer            l2npcols
      integer            reduce_exch_proc(num_proc_cols)
      integer            reduce_send_starts(num_proc_cols)
      integer            reduce_send_lengths(num_proc_cols)
      integer            reduce_recv_starts(num_proc_cols)
      integer            reduce_recv_lengths(num_proc_cols)

      integer            i, j, k, it

      double precision   zeta, randlc
      external           randlc
      double precision   rnorm
      double precision   norm_temp1(2), norm_temp2(2)

      double precision   t, tmax, mflops
      external           timer_read
      double precision   timer_read
      character          class
      logical            verified
      double precision   zeta_verify_value, epsilon, err

      double precision tsum(t_last+2), t1(t_last+2),
     >                 tming(t_last+2), tmaxg(t_last+2)
      character        t_recs(t_last+2)*8

      data t_recs/'total', 'conjg', 'rcomm', 'ncomm',
     >            ' totcomp', ' totcomm'/


c---------------------------------------------------------------------
c  Set up mpi initialization and number of proc testing
c---------------------------------------------------------------------
      call initialize_mpi


      if( na .eq. 1400 .and. 
     &    nonzer .eq. 7 .and. 
     &    niter .eq. 15 .and.
     &    shift .eq. 10.d0 ) then
         class = 'S'
         zeta_verify_value = 8.5971775078648d0
      else if( na .eq. 7000 .and. 
     &         nonzer .eq. 8 .and. 
     &         niter .eq. 15 .and.
     &         shift .eq. 12.d0 ) then
         class = 'W'
         zeta_verify_value = 10.362595087124d0
      else if( na .eq. 14000 .and. 
     &         nonzer .eq. 11 .and. 
     &         niter .eq. 15 .and.
     &         shift .eq. 20.d0 ) then
         class = 'A'
         zeta_verify_value = 17.130235054029d0
      else if( na .eq. 75000 .and. 
     &         nonzer .eq. 13 .and. 
     &         niter .eq. 75 .and.
     &         shift .eq. 60.d0 ) then
         class = 'B'
         zeta_verify_value = 22.712745482631d0
      else if( na .eq. 150000 .and. 
     &         nonzer .eq. 15 .and. 
     &         niter .eq. 75 .and.
     &         shift .eq. 110.d0 ) then
         class = 'C'
         zeta_verify_value = 28.973605592845d0
      else if( na .eq. 1500000 .and. 
     &         nonzer .eq. 21 .and. 
     &         niter .eq. 100 .and.
     &         shift .eq. 500.d0 ) then
         class = 'D'
         zeta_verify_value = 52.514532105794d0
      else if( na .eq. 9000000 .and. 
     &         nonzer .eq. 26 .and. 
     &         niter .eq. 100 .and.
     &         shift .eq. 1.5d3 ) then
         class = 'E'
         zeta_verify_value = 77.522164599383d0
      else
         class = 'U'
      endif

      if( me .eq. root )then
         write( *,1000 ) 
         write( *,1001 ) na
         write( *,1002 ) niter
         write( *,1003 ) nprocs
         write( *,1004 ) nonzer
         write( *,1005 ) shift
 1000 format(//,' NAS Parallel Benchmarks 3.3 -- CG Benchmark', /)
 1001 format(' Size: ', i10 )
 1002 format(' Iterations: ', i5 )
 1003 format(' Number of active processes: ', i5 )
 1004 format(' Number of nonzeroes per row: ', i8)
 1005 format(' Eigenvalue shift: ', e8.3)
      endif

      if (.not. convertdouble) then
         dp_type = MPI_DOUBLE_PRECISION
      else
         dp_type = MPI_REAL
      endif


      naa = na
      nzz = nz


c---------------------------------------------------------------------
c  Set up processor info, such as whether sq num of procs, etc
c---------------------------------------------------------------------
      call setup_proc_info( num_procs, 
     >                      num_proc_rows, 
     >                      num_proc_cols )


c---------------------------------------------------------------------
c  Set up partition's submatrix info: firstcol, lastcol, firstrow, lastrow
c---------------------------------------------------------------------
      call setup_submatrix_info( l2npcols,
     >                           reduce_exch_proc,
     >                           reduce_send_starts,
     >                           reduce_send_lengths,
     >                           reduce_recv_starts,
     >                           reduce_recv_lengths )


      do i = 1, t_last
         call timer_clear(i)
      end do

c---------------------------------------------------------------------
c  Inialize random number generator
c---------------------------------------------------------------------
      tran    = 314159265.0D0
      amult   = 1220703125.0D0
      zeta    = randlc( tran, amult )

c---------------------------------------------------------------------
c  Set up partition's sparse random matrix for given class size
c---------------------------------------------------------------------
      call makea(naa, nzz, a, colidx, rowstr, nonzer,
     >           firstrow, lastrow, firstcol, lastcol, 
     >           rcond, arow, acol, aelt, v, iv, shift)



c---------------------------------------------------------------------
c  Note: as a result of the above call to makea:
c        values of j used in indexing rowstr go from 1 --> lastrow-firstrow+1
c        values of colidx which are col indexes go from firstcol --> lastcol
c        So:
c        Shift the col index vals from actual (firstcol --> lastcol ) 
c        to local, i.e., (1 --> lastcol-firstcol+1)
c---------------------------------------------------------------------
      do j=1,lastrow-firstrow+1
         do k=rowstr(j),rowstr(j+1)-1
            colidx(k) = colidx(k) - firstcol + 1
         enddo
      enddo

c---------------------------------------------------------------------
c  set starting vector to (1, 1, .... 1)
c---------------------------------------------------------------------
      do i = 1, na/num_proc_rows+1
         x(i) = 1.0D0
      enddo

      zeta  = 0.0d0

c---------------------------------------------------------------------
c---->
c  Do one iteration untimed to init all code and data page tables
c---->                    (then reinit, start timing, to niter its)
c---------------------------------------------------------------------
      do it = 1, 1

c---------------------------------------------------------------------
c  The call to the conjugate gradient routine:
c---------------------------------------------------------------------
         call conj_grad ( colidx,
     >                    rowstr,
     >                    x,
     >                    z,
     >                    a,
     >                    p,
     >                    q,
     >                    r,
     >                    w,
     >                    rnorm, 
     >                    l2npcols,
     >                    reduce_exch_proc,
     >                    reduce_send_starts,
     >                    reduce_send_lengths,
     >                    reduce_recv_starts,
     >                    reduce_recv_lengths )

c---------------------------------------------------------------------
c  zeta = shift + 1/(x.z)
c  So, first: (x.z)
c  Also, find norm of z
c  So, first: (z.z)
c---------------------------------------------------------------------
         norm_temp1(1) = 0.0d0
         norm_temp1(2) = 0.0d0
         do j=1, lastcol-firstcol+1
            norm_temp1(1) = norm_temp1(1) + x(j)*z(j)
            norm_temp1(2) = norm_temp1(2) + z(j)*z(j)
         enddo

         do i = 1, l2npcols
            if (timeron) call timer_start(t_ncomm)
            call mpi_irecv( norm_temp2,
     >                      2, 
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      request,
     >                      ierr )
            call mpi_send(  norm_temp1,
     >                      2, 
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      ierr )
            call mpi_wait( request, status, ierr )
            if (timeron) call timer_stop(t_ncomm)

            norm_temp1(1) = norm_temp1(1) + norm_temp2(1)
            norm_temp1(2) = norm_temp1(2) + norm_temp2(2)
         enddo

         norm_temp1(2) = 1.0d0 / sqrt( norm_temp1(2) )


c---------------------------------------------------------------------
c  Normalize z to obtain x
c---------------------------------------------------------------------
         do j=1, lastcol-firstcol+1      
            x(j) = norm_temp1(2)*z(j)    
         enddo                           


      enddo                              ! end of do one iteration untimed


c---------------------------------------------------------------------
c  set starting vector to (1, 1, .... 1)
c---------------------------------------------------------------------
c
c  NOTE: a questionable limit on size:  should this be na/num_proc_cols+1 ?
c
      do i = 1, na/num_proc_rows+1
         x(i) = 1.0D0
      enddo

      zeta  = 0.0d0

c---------------------------------------------------------------------
c  Synchronize and start timing
c---------------------------------------------------------------------
      do i = 1, t_last
         call timer_clear(i)
      end do
      call mpi_barrier( mpi_comm_world,
     >                  ierr )

      call timer_clear( 1 )
      call timer_start( 1 )

c---------------------------------------------------------------------
c---->
c  Main Iteration for inverse power method
c---->
c---------------------------------------------------------------------
      do it = 1, niter

c---------------------------------------------------------------------
c  The call to the conjugate gradient routine:
c---------------------------------------------------------------------
         call conj_grad ( colidx,
     >                    rowstr,
     >                    x,
     >                    z,
     >                    a,
     >                    p,
     >                    q,
     >                    r,
     >                    w,
     >                    rnorm, 
     >                    l2npcols,
     >                    reduce_exch_proc,
     >                    reduce_send_starts,
     >                    reduce_send_lengths,
     >                    reduce_recv_starts,
     >                    reduce_recv_lengths )


c---------------------------------------------------------------------
c  zeta = shift + 1/(x.z)
c  So, first: (x.z)
c  Also, find norm of z
c  So, first: (z.z)
c---------------------------------------------------------------------
         norm_temp1(1) = 0.0d0
         norm_temp1(2) = 0.0d0
         do j=1, lastcol-firstcol+1
            norm_temp1(1) = norm_temp1(1) + x(j)*z(j)
            norm_temp1(2) = norm_temp1(2) + z(j)*z(j)
         enddo

         do i = 1, l2npcols
            if (timeron) call timer_start(t_ncomm)
            call mpi_irecv( norm_temp2,
     >                      2, 
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      request,
     >                      ierr )
            call mpi_send(  norm_temp1,
     >                      2, 
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      ierr )
            call mpi_wait( request, status, ierr )
            if (timeron) call timer_stop(t_ncomm)

            norm_temp1(1) = norm_temp1(1) + norm_temp2(1)
            norm_temp1(2) = norm_temp1(2) + norm_temp2(2)
         enddo

         norm_temp1(2) = 1.0d0 / sqrt( norm_temp1(2) )


         if( me .eq. root )then
            zeta = shift + 1.0d0 / norm_temp1(1)
            if( it .eq. 1 ) write( *,9000 )
            write( *,9001 ) it, rnorm, zeta
         endif
 9000 format( /,'   iteration           ||r||                 zeta' )
 9001 format( 4x, i5, 7x, e20.14, f20.13 )

c---------------------------------------------------------------------
c  Normalize z to obtain x
c---------------------------------------------------------------------
         do j=1, lastcol-firstcol+1      
            x(j) = norm_temp1(2)*z(j)    
         enddo                           


      enddo                              ! end of main iter inv pow meth

      call timer_stop( 1 )

c---------------------------------------------------------------------
c  End of timed section
c---------------------------------------------------------------------

      t = timer_read( 1 )

      call mpi_reduce( t,
     >                 tmax,
     >                 1, 
     >                 dp_type,
     >                 MPI_MAX,
     >                 root,
     >                 mpi_comm_world,
     >                 ierr )

      if( me .eq. root )then
         write(*,100)
 100     format(' Benchmark completed ')

         epsilon = 1.d-10
         if (class .ne. 'U') then

            err = abs( zeta - zeta_verify_value )/zeta_verify_value
            if( err .le. epsilon ) then
               verified = .TRUE.
               write(*, 200)
               write(*, 201) zeta
               write(*, 202) err
 200           format(' VERIFICATION SUCCESSFUL ')
 201           format(' Zeta is    ', E20.13)
 202           format(' Error is   ', E20.13)
            else
               verified = .FALSE.
               write(*, 300) 
               write(*, 301) zeta
               write(*, 302) zeta_verify_value
 300           format(' VERIFICATION FAILED')
 301           format(' Zeta                ', E20.13)
 302           format(' The correct zeta is ', E20.13)
            endif
         else
            verified = .FALSE.
            write (*, 400)
            write (*, 401)
            write (*, 201) zeta
 400        format(' Problem size unknown')
 401        format(' NO VERIFICATION PERFORMED')
         endif


         if( tmax .ne. 0. ) then
            mflops = float( 2*niter*na )
     &                  * ( 3.+float( nonzer*(nonzer+1) )
     &                    + 25.*(5.+float( nonzer*(nonzer+1) ))
     &                    + 3. ) / tmax / 1000000.0
         else
            mflops = 0.0
         endif

         call print_results('CG', class, na, 0, 0,
     >                      niter, nnodes_compiled, nprocs, tmax,
     >                      mflops, '          floating point', 
     >                      verified, npbversion, compiletime,
     >                      cs1, cs2, cs3, cs4, cs5, cs6, cs7)


      endif


      if (.not.timeron) goto 999

      do i = 1, t_last
         t1(i) = timer_read(i)
      end do
      t1(t_conjg) = t1(t_conjg) - t1(t_rcomm)
      t1(t_last+2) = t1(t_rcomm) + t1(t_ncomm)
      t1(t_last+1) = t1(t_total) - t1(t_last+2)

      call MPI_Reduce(t1, tsum,  t_last+2, dp_type, MPI_SUM, 
     >                0, MPI_COMM_WORLD, ierr)
      call MPI_Reduce(t1, tming, t_last+2, dp_type, MPI_MIN, 
     >                0, MPI_COMM_WORLD, ierr)
      call MPI_Reduce(t1, tmaxg, t_last+2, dp_type, MPI_MAX, 
     >                0, MPI_COMM_WORLD, ierr)

      if (me .eq. 0) then
         write(*, 800) nprocs
         do i = 1, t_last+2
            tsum(i) = tsum(i) / nprocs
            write(*, 810) i, t_recs(i), tming(i), tmaxg(i), tsum(i)
         end do
      endif
 800  format(' nprocs =', i6, 11x, 'minimum', 5x, 'maximum', 
     >       5x, 'average')
 810  format(' timer ', i2, '(', A8, ') :', 3(2x,f10.4))

 999  continue
      call mpi_finalize(ierr)



      end                              ! end main





c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine initialize_mpi
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none

      include 'mpinpb.h'
      include 'timing.h'

      integer   ierr, fstatus


      call mpi_init( ierr )
      call mpi_comm_rank( mpi_comm_world, me, ierr )
      call mpi_comm_size( mpi_comm_world, nprocs, ierr )
      root = 0

      if (me .eq. root) then
         open (unit=2,file='timer.flag',status='old',iostat=fstatus)
         timeron = .false.
         if (fstatus .eq. 0) then
            timeron = .true.
            close(2)
         endif
      endif

      call mpi_bcast(timeron, 1, MPI_LOGICAL, 0, mpi_comm_world, ierr)

      return
      end



c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine setup_proc_info( num_procs, 
     >                            num_proc_rows, 
     >                            num_proc_cols )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none

      include 'mpinpb.h'

      common / partit_size  /  naa, nzz, 
     >                         npcols, nprows,
     >                         proc_col, proc_row,
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol,
     >                         exch_proc,
     >                         exch_recv_length,
     >                         send_start,
     >                         send_len
      integer                  naa, nzz, 
     >                         npcols, nprows,
     >                         proc_col, proc_row,
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol,
     >                         exch_proc,
     >                         exch_recv_length,
     >                         send_start,
     >                         send_len

      integer   num_procs, num_proc_cols, num_proc_rows
      integer   i, ierr
      integer   log2nprocs

c---------------------------------------------------------------------
c  num_procs must be a power of 2, and num_procs=num_proc_cols*num_proc_rows
c  When num_procs is not square, then num_proc_cols = 2*num_proc_rows
c---------------------------------------------------------------------
c  First, number of procs must be power of two. 
c---------------------------------------------------------------------
      if( nprocs .ne. num_procs )then
          if( me .eq. root ) write( *,9000 ) nprocs, num_procs
 9000     format(      /,'Error: ',/,'num of procs allocated   (', 
     >                 i4, ' )',
     >                 /,'is not equal to',/,
     >                 'compiled number of procs (',
     >                 i4, ' )',/   )
          call mpi_finalize(ierr)
          stop
      endif


      i = num_proc_cols
 100  continue
          if( i .ne. 1 .and. i/2*2 .ne. i )then
              if ( me .eq. root ) then  
                 write( *,* ) 'Error: num_proc_cols is ',
     >                         num_proc_cols,
     >                        ' which is not a power of two'
              endif
              call mpi_finalize(ierr)
              stop
          endif
          i = i / 2
          if( i .ne. 0 )then
              goto 100
          endif
      
      i = num_proc_rows
 200  continue
          if( i .ne. 1 .and. i/2*2 .ne. i )then
              if ( me .eq. root ) then 
                 write( *,* ) 'Error: num_proc_rows is ',
     >                         num_proc_rows,
     >                        ' which is not a power of two'
              endif
              call mpi_finalize(ierr)
              stop
          endif
          i = i / 2
          if( i .ne. 0 )then
              goto 200
          endif
      
      log2nprocs = 0
      i = nprocs
 300  continue
          if( i .ne. 1 .and. i/2*2 .ne. i )then
              write( *,* ) 'Error: nprocs is ',
     >                      nprocs,
     >                      ' which is not a power of two'
              call mpi_finalize(ierr)
              stop
          endif
          i = i / 2
          if( i .ne. 0 )then
              log2nprocs = log2nprocs + 1
              goto 300
          endif

CC       write( *,* ) 'nprocs, log2nprocs: ',nprocs,log2nprocs

      
      npcols = num_proc_cols
      nprows = num_proc_rows


      return
      end




c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine setup_submatrix_info( l2npcols,
     >                                 reduce_exch_proc,
     >                                 reduce_send_starts,
     >                                 reduce_send_lengths,
     >                                 reduce_recv_starts,
     >                                 reduce_recv_lengths )
     >                                 
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none

      include 'mpinpb.h'

      integer      col_size, row_size

      common / partit_size  /  naa, nzz, 
     >                         npcols, nprows,
     >                         proc_col, proc_row,
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol,
     >                         exch_proc,
     >                         exch_recv_length,
     >                         send_start,
     >                         send_len
      integer                  naa, nzz, 
     >                         npcols, nprows,
     >                         proc_col, proc_row,
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol,
     >                         exch_proc,
     >                         exch_recv_length,
     >                         send_start,
     >                         send_len

      integer   reduce_exch_proc(*)
      integer   reduce_send_starts(*)
      integer   reduce_send_lengths(*)
      integer   reduce_recv_starts(*)
      integer   reduce_recv_lengths(*)

      integer   i, j
      integer   div_factor
      integer   l2npcols


      proc_row = me / npcols
      proc_col = me - proc_row*npcols



c---------------------------------------------------------------------
c  If naa evenly divisible by npcols, then it is evenly divisible 
c  by nprows 
c---------------------------------------------------------------------

      if( naa/npcols*npcols .eq. naa )then
          col_size = naa/npcols
          firstcol = proc_col*col_size + 1
          lastcol  = firstcol - 1 + col_size
          row_size = naa/nprows
          firstrow = proc_row*row_size + 1
          lastrow  = firstrow - 1 + row_size
c---------------------------------------------------------------------
c  If naa not evenly divisible by npcols, then first subdivide for nprows
c  and then, if npcols not equal to nprows (i.e., not a sq number of procs), 
c  get col subdivisions by dividing by 2 each row subdivision.
c---------------------------------------------------------------------
      else
          if( proc_row .lt. naa - naa/nprows*nprows)then
              row_size = naa/nprows+ 1
              firstrow = proc_row*row_size + 1
              lastrow  = firstrow - 1 + row_size
          else
              row_size = naa/nprows
              firstrow = (naa - naa/nprows*nprows)*(row_size+1)
     >                 + (proc_row-(naa-naa/nprows*nprows))
     >                     *row_size + 1
              lastrow  = firstrow - 1 + row_size
          endif
          if( npcols .eq. nprows )then
              if( proc_col .lt. naa - naa/npcols*npcols )then
                  col_size = naa/npcols+ 1
                  firstcol = proc_col*col_size + 1
                  lastcol  = firstcol - 1 + col_size
              else
                  col_size = naa/npcols
                  firstcol = (naa - naa/npcols*npcols)*(col_size+1)
     >                     + (proc_col-(naa-naa/npcols*npcols))
     >                         *col_size + 1
                  lastcol  = firstcol - 1 + col_size
              endif
          else
              if( (proc_col/2) .lt. 
     >                           naa - naa/(npcols/2)*(npcols/2) )then
                  col_size = naa/(npcols/2) + 1
                  firstcol = (proc_col/2)*col_size + 1
                  lastcol  = firstcol - 1 + col_size
              else
                  col_size = naa/(npcols/2)
                  firstcol = (naa - naa/(npcols/2)*(npcols/2))
     >                                                 *(col_size+1)
     >               + ((proc_col/2)-(naa-naa/(npcols/2)*(npcols/2)))
     >                         *col_size + 1
                  lastcol  = firstcol - 1 + col_size
              endif
CC               write( *,* ) col_size,firstcol,lastcol
              if( mod( me,2 ) .eq. 0 )then
                  lastcol  = firstcol - 1 + (col_size-1)/2 + 1
              else
                  firstcol = firstcol + (col_size-1)/2 + 1
                  lastcol  = firstcol - 1 + col_size/2
CC                   write( *,* ) firstcol,lastcol
              endif
          endif
      endif



      if( npcols .eq. nprows )then
          send_start = 1
          send_len   = lastrow - firstrow + 1
      else
          if( mod( me,2 ) .eq. 0 )then
              send_start = 1
              send_len   = (1 + lastrow-firstrow+1)/2
          else
              send_start = (1 + lastrow-firstrow+1)/2 + 1
              send_len   = (lastrow-firstrow+1)/2
          endif
      endif
          



c---------------------------------------------------------------------
c  Transpose exchange processor
c---------------------------------------------------------------------

      if( npcols .eq. nprows )then
          exch_proc = mod( me,nprows )*nprows + me/nprows
      else
          exch_proc = 2*(mod( me/2,nprows )*nprows + me/2/nprows)
     >                 + mod( me,2 )
      endif



      i = npcols / 2
      l2npcols = 0
      do while( i .gt. 0 )
         l2npcols = l2npcols + 1
         i = i / 2
      enddo


c---------------------------------------------------------------------
c  Set up the reduce phase schedules...
c---------------------------------------------------------------------

      div_factor = npcols
      do i = 1, l2npcols

         j = mod( proc_col+div_factor/2, div_factor )
     >     + proc_col / div_factor * div_factor
         reduce_exch_proc(i) = proc_row*npcols + j

         div_factor = div_factor / 2

      enddo


      do i = l2npcols, 1, -1

            if( nprows .eq. npcols )then
               reduce_send_starts(i)  = send_start
               reduce_send_lengths(i) = send_len
               reduce_recv_lengths(i) = lastrow - firstrow + 1
            else
               reduce_recv_lengths(i) = send_len
               if( i .eq. l2npcols )then
                  reduce_send_lengths(i) = lastrow-firstrow+1 - send_len
                  if( me/2*2 .eq. me )then
                     reduce_send_starts(i) = send_start + send_len
                  else
                     reduce_send_starts(i) = 1
                  endif
               else
                  reduce_send_lengths(i) = send_len
                  reduce_send_starts(i)  = send_start
               endif
            endif
            reduce_recv_starts(i) = send_start

      enddo


      exch_recv_length = lastcol - firstcol + 1


      return
      end




c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine conj_grad ( colidx,
     >                       rowstr,
     >                       x,
     >                       z,
     >                       a,
     >                       p,
     >                       q,
     >                       r,
     >                       w,
     >                       rnorm, 
     >                       l2npcols,
     >                       reduce_exch_proc,
     >                       reduce_send_starts,
     >                       reduce_send_lengths,
     >                       reduce_recv_starts,
     >                       reduce_recv_lengths )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c  Floaging point arrays here are named as in NPB1 spec discussion of 
c  CG algorithm
c---------------------------------------------------------------------
 
      implicit none

      include 'mpinpb.h'
      include 'timing.h'

      integer status(MPI_STATUS_SIZE ), request


      common / partit_size  /  naa, nzz, 
     >                         npcols, nprows,
     >                         proc_col, proc_row,
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol,
     >                         exch_proc,
     >                         exch_recv_length,
     >                         send_start,
     >                         send_len
      integer                  naa, nzz, 
     >                         npcols, nprows,
     >                         proc_col, proc_row,
     >                         firstrow, 
     >                         lastrow, 
     >                         firstcol, 
     >                         lastcol,
     >                         exch_proc,
     >                         exch_recv_length,
     >                         send_start,
     >                         send_len



      double precision   x(*),
     >                   z(*),
     >                   a(nzz)
      integer            colidx(nzz), rowstr(naa+1)

      double precision   p(*),
     >                   q(*),
     >                   r(*),               
     >                   w(*)                ! used as work temporary

      integer   l2npcols
      integer   reduce_exch_proc(l2npcols)
      integer   reduce_send_starts(l2npcols)
      integer   reduce_send_lengths(l2npcols)
      integer   reduce_recv_starts(l2npcols)
      integer   reduce_recv_lengths(l2npcols)

      integer   i, j, k, ierr
      integer   cgit, cgitmax

      double precision   d, sum, rho, rho0, alpha, beta, rnorm

      external         timer_read
      double precision timer_read

      data      cgitmax / 25 /


      if (timeron) call timer_start(t_conjg)
c---------------------------------------------------------------------
c  Initialize the CG algorithm:
c---------------------------------------------------------------------
      do j=1,naa/nprows+1
         q(j) = 0.0d0
         z(j) = 0.0d0
         r(j) = x(j)
         p(j) = r(j)
         w(j) = 0.0d0                 
      enddo


c---------------------------------------------------------------------
c  rho = r.r
c  Now, obtain the norm of r: First, sum squares of r elements locally...
c---------------------------------------------------------------------
      sum = 0.0d0
      do j=1, lastcol-firstcol+1
         sum = sum + r(j)*r(j)
      enddo

c---------------------------------------------------------------------
c  Exchange and sum with procs identified in reduce_exch_proc
c  (This is equivalent to mpi_allreduce.)
c  Sum the partial sums of rho, leaving rho on all processors
c---------------------------------------------------------------------
      do i = 1, l2npcols
         if (timeron) call timer_start(t_rcomm)
         call mpi_irecv( rho,
     >                   1,
     >                   dp_type,
     >                   reduce_exch_proc(i),
     >                   i,
     >                   mpi_comm_world,
     >                   request,
     >                   ierr )
         call mpi_send(  sum,
     >                   1,
     >                   dp_type,
     >                   reduce_exch_proc(i),
     >                   i,
     >                   mpi_comm_world,
     >                   ierr )
         call mpi_wait( request, status, ierr )
         if (timeron) call timer_stop(t_rcomm)

         sum = sum + rho
      enddo
      rho = sum



c---------------------------------------------------------------------
c---->
c  The conj grad iteration loop
c---->
c---------------------------------------------------------------------
      do cgit = 1, cgitmax


c---------------------------------------------------------------------
c  q = A.p
c  The partition submatrix-vector multiply: use workspace w
c---------------------------------------------------------------------
         do j=1,lastrow-firstrow+1
            sum = 0.d0
            do k=rowstr(j),rowstr(j+1)-1
               sum = sum + a(k)*p(colidx(k))
            enddo
            w(j) = sum
         enddo

c---------------------------------------------------------------------
c  Sum the partition submatrix-vec A.p's across rows
c  Exchange and sum piece of w with procs identified in reduce_exch_proc
c---------------------------------------------------------------------
         do i = l2npcols, 1, -1
            if (timeron) call timer_start(t_rcomm)
            call mpi_irecv( q(reduce_recv_starts(i)),
     >                      reduce_recv_lengths(i),
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      request,
     >                      ierr )
            call mpi_send(  w(reduce_send_starts(i)),
     >                      reduce_send_lengths(i),
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      ierr )
            call mpi_wait( request, status, ierr )
            if (timeron) call timer_stop(t_rcomm)
            do j=send_start,send_start + reduce_recv_lengths(i) - 1
               w(j) = w(j) + q(j)
            enddo
         enddo
      

c---------------------------------------------------------------------
c  Exchange piece of q with transpose processor:
c---------------------------------------------------------------------
         if( l2npcols .ne. 0 )then
            if (timeron) call timer_start(t_rcomm)
            call mpi_irecv( q,               
     >                      exch_recv_length,
     >                      dp_type,
     >                      exch_proc,
     >                      1,
     >                      mpi_comm_world,
     >                      request,
     >                      ierr )

            call mpi_send(  w(send_start),   
     >                      send_len,
     >                      dp_type,
     >                      exch_proc,
     >                      1,
     >                      mpi_comm_world,
     >                      ierr )
            call mpi_wait( request, status, ierr )
            if (timeron) call timer_stop(t_rcomm)
         else
            do j=1,exch_recv_length
               q(j) = w(j)
            enddo
         endif


c---------------------------------------------------------------------
c  Clear w for reuse...
c---------------------------------------------------------------------
         do j=1, max( lastrow-firstrow+1, lastcol-firstcol+1 )
            w(j) = 0.0d0
         enddo
         

c---------------------------------------------------------------------
c  Obtain p.q
c---------------------------------------------------------------------
         sum = 0.0d0
         do j=1, lastcol-firstcol+1
            sum = sum + p(j)*q(j)
         enddo

c---------------------------------------------------------------------
c  Obtain d with a sum-reduce
c---------------------------------------------------------------------
         do i = 1, l2npcols
            if (timeron) call timer_start(t_rcomm)
            call mpi_irecv( d,
     >                      1,
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      request,
     >                      ierr )
            call mpi_send(  sum,
     >                      1,
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      ierr )

            call mpi_wait( request, status, ierr )
            if (timeron) call timer_stop(t_rcomm)

            sum = sum + d
         enddo
         d = sum


c---------------------------------------------------------------------
c  Obtain alpha = rho / (p.q)
c---------------------------------------------------------------------
         alpha = rho / d

c---------------------------------------------------------------------
c  Save a temporary of rho
c---------------------------------------------------------------------
         rho0 = rho

c---------------------------------------------------------------------
c  Obtain z = z + alpha*p
c  and    r = r - alpha*q
c---------------------------------------------------------------------
         do j=1, lastcol-firstcol+1
            z(j) = z(j) + alpha*p(j)
            r(j) = r(j) - alpha*q(j)
         enddo
            
c---------------------------------------------------------------------
c  rho = r.r
c  Now, obtain the norm of r: First, sum squares of r elements locally...
c---------------------------------------------------------------------
         sum = 0.0d0
         do j=1, lastcol-firstcol+1
            sum = sum + r(j)*r(j)
         enddo

c---------------------------------------------------------------------
c  Obtain rho with a sum-reduce
c---------------------------------------------------------------------
         do i = 1, l2npcols
            if (timeron) call timer_start(t_rcomm)
            call mpi_irecv( rho,
     >                      1,
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      request,
     >                      ierr )
            call mpi_send(  sum,
     >                      1,
     >                      dp_type,
     >                      reduce_exch_proc(i),
     >                      i,
     >                      mpi_comm_world,
     >                      ierr )
            call mpi_wait( request, status, ierr )
            if (timeron) call timer_stop(t_rcomm)

            sum = sum + rho
         enddo
         rho = sum

c---------------------------------------------------------------------
c  Obtain beta:
c---------------------------------------------------------------------
         beta = rho / rho0

c---------------------------------------------------------------------
c  p = r + beta*p
c---------------------------------------------------------------------
         do j=1, lastcol-firstcol+1
            p(j) = r(j) + beta*p(j)
         enddo



      enddo                             ! end of do cgit=1,cgitmax



c---------------------------------------------------------------------
c  Compute residual norm explicitly:  ||r|| = ||x - A.z||
c  First, form A.z
c  The partition submatrix-vector multiply
c---------------------------------------------------------------------
      do j=1,lastrow-firstrow+1
         sum = 0.d0
         do k=rowstr(j),rowstr(j+1)-1
            sum = sum + a(k)*z(colidx(k))
         enddo
         w(j) = sum
      enddo



c---------------------------------------------------------------------
c  Sum the partition submatrix-vec A.z's across rows
c---------------------------------------------------------------------
      do i = l2npcols, 1, -1
         if (timeron) call timer_start(t_rcomm)
         call mpi_irecv( r(reduce_recv_starts(i)),
     >                   reduce_recv_lengths(i),
     >                   dp_type,
     >                   reduce_exch_proc(i),
     >                   i,
     >                   mpi_comm_world,
     >                   request,
     >                   ierr )
         call mpi_send(  w(reduce_send_starts(i)),
     >                   reduce_send_lengths(i),
     >                   dp_type,
     >                   reduce_exch_proc(i),
     >                   i,
     >                   mpi_comm_world,
     >                   ierr )
         call mpi_wait( request, status, ierr )
         if (timeron) call timer_stop(t_rcomm)

         do j=send_start,send_start + reduce_recv_lengths(i) - 1
            w(j) = w(j) + r(j)
         enddo
      enddo
      

c---------------------------------------------------------------------
c  Exchange piece of q with transpose processor:
c---------------------------------------------------------------------
      if( l2npcols .ne. 0 )then
         if (timeron) call timer_start(t_rcomm)
         call mpi_irecv( r,               
     >                   exch_recv_length,
     >                   dp_type,
     >                   exch_proc,
     >                   1,
     >                   mpi_comm_world,
     >                   request,
     >                   ierr )
   
         call mpi_send(  w(send_start),   
     >                   send_len,
     >                   dp_type,
     >                   exch_proc,
     >                   1,
     >                   mpi_comm_world,
     >                   ierr )
         call mpi_wait( request, status, ierr )
         if (timeron) call timer_stop(t_rcomm)
      else
         do j=1,exch_recv_length
            r(j) = w(j)
         enddo
      endif


c---------------------------------------------------------------------
c  At this point, r contains A.z
c---------------------------------------------------------------------
         sum = 0.0d0
         do j=1, lastcol-firstcol+1
            d   = x(j) - r(j)         
            sum = sum + d*d
         enddo
         
c---------------------------------------------------------------------
c  Obtain d with a sum-reduce
c---------------------------------------------------------------------
      do i = 1, l2npcols
         if (timeron) call timer_start(t_rcomm)
         call mpi_irecv( d,
     >                   1,
     >                   dp_type,
     >                   reduce_exch_proc(i),
     >                   i,
     >                   mpi_comm_world,
     >                   request,
     >                   ierr )
         call mpi_send(  sum,
     >                   1,
     >                   dp_type,
     >                   reduce_exch_proc(i),
     >                   i,
     >                   mpi_comm_world,
     >                   ierr )
         call mpi_wait( request, status, ierr )
         if (timeron) call timer_stop(t_rcomm)

         sum = sum + d
      enddo
      d = sum


      if( me .eq. root ) rnorm = sqrt( d )

      if (timeron) call timer_stop(t_conjg)


      return
      end                               ! end of routine conj_grad



c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine makea( n, nz, a, colidx, rowstr, nonzer,
     >                  firstrow, lastrow, firstcol, lastcol,
     >                  rcond, arow, acol, aelt, v, iv, shift )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit            none
      integer             n, nz, nonzer
      integer             firstrow, lastrow, firstcol, lastcol
      integer             colidx(nz), rowstr(n+1)
      integer             iv(2*n+1), arow(nz), acol(nz)
      double precision    v(n+1), aelt(nz)
      double precision    rcond, a(nz), shift

c---------------------------------------------------------------------
c       generate the test problem for benchmark 6
c       makea generates a sparse matrix with a
c       prescribed sparsity distribution
c
c       parameter    type        usage
c
c       input
c
c       n            i           number of cols/rows of matrix
c       nz           i           nonzeros as declared array size
c       rcond        r*8         condition number
c       shift        r*8         main diagonal shift
c
c       output
c
c       a            r*8         array for nonzeros
c       colidx       i           col indices
c       rowstr       i           row pointers
c
c       workspace
c
c       iv, arow, acol i
c       v, aelt        r*8
c---------------------------------------------------------------------

      integer i, nnza, iouter, ivelt, ivelt1, irow, nzv, jcol

c---------------------------------------------------------------------
c      nonzer is approximately  (int(sqrt(nnza /n)));
c---------------------------------------------------------------------

      double precision  size, ratio, scale
      external          sparse, sprnvc, vecset

      size = 1.0D0
      ratio = rcond ** (1.0D0 / dfloat(n))
      nnza = 0

c---------------------------------------------------------------------
c  Initialize iv(n+1 .. 2n) to zero.
c  Used by sprnvc to mark nonzero positions
c---------------------------------------------------------------------

      do i = 1, n
           iv(n+i) = 0
      enddo
      do iouter = 1, n
         nzv = nonzer
         call sprnvc( n, nzv, v, colidx, iv(1), iv(n+1) )
         call vecset( n, v, colidx, nzv, iouter, .5D0 )
         do ivelt = 1, nzv
              jcol = colidx(ivelt)
              if (jcol.ge.firstcol .and. jcol.le.lastcol) then
                 scale = size * v(ivelt)
                 do ivelt1 = 1, nzv
                    irow = colidx(ivelt1)
                    if (irow.ge.firstrow .and. irow.le.lastrow) then
                       nnza = nnza + 1
                       if (nnza .gt. nz) goto 9999
                       acol(nnza) = jcol
                       arow(nnza) = irow
                       aelt(nnza) = v(ivelt1) * scale
                    endif
                 enddo
              endif
         enddo
         size = size * ratio
      enddo


c---------------------------------------------------------------------
c       ... add the identity * rcond to the generated matrix to bound
c           the smallest eigenvalue from below by rcond
c---------------------------------------------------------------------
        do i = firstrow, lastrow
           if (i.ge.firstcol .and. i.le.lastcol) then
              iouter = n + i
              nnza = nnza + 1
              if (nnza .gt. nz) goto 9999
              acol(nnza) = i
              arow(nnza) = i
              aelt(nnza) = rcond - shift
           endif
        enddo


c---------------------------------------------------------------------
c       ... make the sparse matrix from list of elements with duplicates
c           (v and iv are used as  workspace)
c---------------------------------------------------------------------
      call sparse( a, colidx, rowstr, n, arow, acol, aelt,
     >             firstrow, lastrow,
     >             v, iv(1), iv(n+1), nnza )
      return

 9999 continue
      write(*,*) 'Space for matrix elements exceeded in makea'
      write(*,*) 'nnza, nzmax = ',nnza, nz
      write(*,*) ' iouter = ',iouter

      stop
      end
c-------end   of makea------------------------------

c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine sparse( a, colidx, rowstr, n, arow, acol, aelt,
     >                   firstrow, lastrow,
     >                   x, mark, nzloc, nnza )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit           none
      integer            colidx(*), rowstr(*)
      integer            firstrow, lastrow
      integer            n, arow(*), acol(*), nnza
      double precision   a(*), aelt(*)

c---------------------------------------------------------------------
c       rows range from firstrow to lastrow
c       the rowstr pointers are defined for nrows = lastrow-firstrow+1 values
c---------------------------------------------------------------------
      integer            nzloc(n), nrows
      double precision   x(n)
      logical            mark(n)

c---------------------------------------------------
c       generate a sparse matrix from a list of
c       [col, row, element] tri
c---------------------------------------------------

      integer            i, j, jajp1, nza, k, nzrow
      double precision   xi

c---------------------------------------------------------------------
c    how many rows of result
c---------------------------------------------------------------------
      nrows = lastrow - firstrow + 1

c---------------------------------------------------------------------
c     ...count the number of triples in each row
c---------------------------------------------------------------------
      do j = 1, n
         rowstr(j) = 0
         mark(j) = .false.
      enddo
      rowstr(n+1) = 0

      do nza = 1, nnza
         j = (arow(nza) - firstrow + 1) + 1
         rowstr(j) = rowstr(j) + 1
      enddo

      rowstr(1) = 1
      do j = 2, nrows+1
         rowstr(j) = rowstr(j) + rowstr(j-1)
      enddo


c---------------------------------------------------------------------
c     ... rowstr(j) now is the location of the first nonzero
c           of row j of a
c---------------------------------------------------------------------


c---------------------------------------------------------------------
c     ... do a bucket sort of the triples on the row index
c---------------------------------------------------------------------
      do nza = 1, nnza
         j = arow(nza) - firstrow + 1
         k = rowstr(j)
         a(k) = aelt(nza)
         colidx(k) = acol(nza)
         rowstr(j) = rowstr(j) + 1
      enddo


c---------------------------------------------------------------------
c       ... rowstr(j) now points to the first element of row j+1
c---------------------------------------------------------------------
      do j = nrows, 1, -1
          rowstr(j+1) = rowstr(j)
      enddo
      rowstr(1) = 1


c---------------------------------------------------------------------
c       ... generate the actual output rows by adding elements
c---------------------------------------------------------------------
      nza = 0
      do i = 1, n
          x(i)    = 0.0
          mark(i) = .false.
      enddo

      jajp1 = rowstr(1)
      do j = 1, nrows
         nzrow = 0

c---------------------------------------------------------------------
c          ...loop over the jth row of a
c---------------------------------------------------------------------
         do k = jajp1 , rowstr(j+1)-1
            i = colidx(k)
            x(i) = x(i) + a(k)
            if ( (.not. mark(i)) .and. (x(i) .ne. 0.D0)) then
             mark(i) = .true.
             nzrow = nzrow + 1
             nzloc(nzrow) = i
            endif
         enddo

c---------------------------------------------------------------------
c          ... extract the nonzeros of this row
c---------------------------------------------------------------------
         do k = 1, nzrow
            i = nzloc(k)
            mark(i) = .false.
            xi = x(i)
            x(i) = 0.D0
            if (xi .ne. 0.D0) then
             nza = nza + 1
             a(nza) = xi
             colidx(nza) = i
            endif
         enddo
         jajp1 = rowstr(j+1)
         rowstr(j+1) = nza + rowstr(1)
      enddo
CC       write (*, 11000) nza
      return
11000   format ( //,'final nonzero count in sparse ',
     1            /,'number of nonzeros       = ', i16 )
      end
c-------end   of sparse-----------------------------


c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine sprnvc( n, nz, v, iv, nzloc, mark )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit           none
      double precision   v(*)
      integer            n, nz, iv(*), nzloc(n), nn1
      integer mark(n)
      common /urando/    amult, tran
      double precision   amult, tran


c---------------------------------------------------------------------
c       generate a sparse n-vector (v, iv)
c       having nzv nonzeros
c
c       mark(i) is set to 1 if position i is nonzero.
c       mark is all zero on entry and is reset to all zero before exit
c       this corrects a performance bug found by John G. Lewis, caused by
c       reinitialization of mark on every one of the n calls to sprnvc
c---------------------------------------------------------------------

        integer            nzrow, nzv, ii, i, icnvrt

        external           randlc, icnvrt
        double precision   randlc, vecelt, vecloc


        nzv = 0
        nzrow = 0
        nn1 = 1
 50     continue
          nn1 = 2 * nn1
          if (nn1 .lt. n) goto 50

c---------------------------------------------------------------------
c    nn1 is the smallest power of two not less than n
c---------------------------------------------------------------------

100     continue
        if (nzv .ge. nz) goto 110
         vecelt = randlc( tran, amult )

c---------------------------------------------------------------------
c   generate an integer between 1 and n in a portable manner
c---------------------------------------------------------------------
         vecloc = randlc(tran, amult)
         i = icnvrt(vecloc, nn1) + 1
         if (i .gt. n) goto 100

c---------------------------------------------------------------------
c  was this integer generated already?
c---------------------------------------------------------------------
         if (mark(i) .eq. 0) then
            mark(i) = 1
            nzrow = nzrow + 1
            nzloc(nzrow) = i
            nzv = nzv + 1
            v(nzv) = vecelt
            iv(nzv) = i
         endif
         goto 100
110      continue
      do ii = 1, nzrow
         i = nzloc(ii)
         mark(i) = 0
      enddo
      return
      end
c-------end   of sprnvc-----------------------------


c---------------------------------------------------------------------
c---------------------------------------------------------------------
      function icnvrt(x, ipwr2)
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit           none
      double precision   x
      integer            ipwr2, icnvrt

c---------------------------------------------------------------------
c    scale a double precision number x in (0,1) by a power of 2 and chop it
c---------------------------------------------------------------------
      icnvrt = int(ipwr2 * x)

      return
      end
c-------end   of icnvrt-----------------------------


c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine vecset(n, v, iv, nzv, i, val)
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit           none
      integer            n, iv(*), nzv, i, k
      double precision   v(*), val

c---------------------------------------------------------------------
c       set ith element of sparse vector (v, iv) with
c       nzv nonzeros to val
c---------------------------------------------------------------------

      logical set

      set = .false.
      do k = 1, nzv
         if (iv(k) .eq. i) then
            v(k) = val
            set  = .true.
         endif
      enddo
      if (.not. set) then
         nzv     = nzv + 1
         v(nzv)  = val
         iv(nzv) = i
      endif
      return
      end
c-------end   of vecset-----------------------------

