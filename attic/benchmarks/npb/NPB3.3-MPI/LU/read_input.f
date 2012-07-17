
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine read_input

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none

      include 'mpinpb.h'
      include 'applu.incl'

      integer IERROR, fstatus, nnodes


c---------------------------------------------------------------------
c    only root reads the input file
c    if input file does not exist, it uses defaults
c       ipr = 1 for detailed progress output
c       inorm = how often the norm is printed (once every inorm iterations)
c       itmax = number of pseudo time steps
c       dt = time step
c       omega 1 over-relaxation factor for SSOR
c       tolrsd = steady state residual tolerance levels
c       nx, ny, nz = number of grid points in x, y, z directions
c---------------------------------------------------------------------
      ROOT = 0
      if (id .eq. ROOT) then

         write(*, 1000)

         open (unit=3,file='timer.flag',status='old',iostat=fstatus)
         timeron = .false.
         if (fstatus .eq. 0) then
            timeron = .true.
            close(3)
         endif

         open (unit=3,file='inputlu.data',status='old',
     >         access='sequential',form='formatted', iostat=fstatus)
         if (fstatus .eq. 0) then

            write(*, *) 'Reading from input file inputlu.data'

            read (3,*)
            read (3,*)
            read (3,*) ipr, inorm
            read (3,*)
            read (3,*)
            read (3,*) itmax
            read (3,*)
            read (3,*)
            read (3,*) dt
            read (3,*)
            read (3,*)
            read (3,*) omega
            read (3,*)
            read (3,*)
            read (3,*) tolrsd(1),tolrsd(2),tolrsd(3),tolrsd(4),tolrsd(5)
            read (3,*)
            read (3,*)
            read (3,*) nx0, ny0, nz0
            close(3)
         else
            ipr = ipr_default
            inorm = inorm_default
            itmax = itmax_default
            dt = dt_default
            omega = omega_default
            tolrsd(1) = tolrsd1_def
            tolrsd(2) = tolrsd2_def
            tolrsd(3) = tolrsd3_def
            tolrsd(4) = tolrsd4_def
            tolrsd(5) = tolrsd5_def
            nx0 = isiz01
            ny0 = isiz02
            nz0 = isiz03
         endif

c---------------------------------------------------------------------
c   check problem size
c---------------------------------------------------------------------
         call MPI_COMM_SIZE(MPI_COMM_WORLD, nnodes, ierror)
         if (nnodes .ne. nnodes_compiled) then
            write (*, 2000) nnodes, nnodes_compiled
 2000       format (5x,'Warning: program is running on',i5,' processors'
     >             /5x,'but was compiled for ', i5)
         endif

         if ( ( nx0 .lt. 4 ) .or.
     >        ( ny0 .lt. 4 ) .or.
     >        ( nz0 .lt. 4 ) ) then

            write (*,2001)
 2001       format (5x,'PROBLEM SIZE IS TOO SMALL - ',
     >           /5x,'SET EACH OF NX, NY AND NZ AT LEAST EQUAL TO 5')
            CALL MPI_ABORT( MPI_COMM_WORLD, MPI_ERR_OTHER, IERROR )

         end if

         if ( ( nx0 .gt. isiz01 ) .or.
     >        ( ny0 .gt. isiz02 ) .or.
     >        ( nz0 .gt. isiz03 ) ) then

            write (*,2002)
 2002       format (5x,'PROBLEM SIZE IS TOO LARGE - ',
     >           /5x,'NX, NY AND NZ SHOULD BE LESS THAN OR EQUAL TO ',
     >           /5x,'ISIZ01, ISIZ02 AND ISIZ03 RESPECTIVELY')
            CALL MPI_ABORT( MPI_COMM_WORLD, MPI_ERR_OTHER, IERROR )

         end if


         write(*, 1001) nx0, ny0, nz0
         write(*, 1002) itmax
         write(*, 1003) nnodes

 1000 format(//, ' NAS Parallel Benchmarks 3.3 -- LU Benchmark',/)
 1001    format(' Size: ', i4, 'x', i4, 'x', i4)
 1002    format(' Iterations: ', i4)
 1003    format(' Number of processes: ', i5, /)
         


      end if

      call bcast_inputs

      return
      end


