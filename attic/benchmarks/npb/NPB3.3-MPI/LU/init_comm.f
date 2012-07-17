
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine init_comm 

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c
c   initialize MPI and establish rank and size
c
c This is a module in the MPI implementation of LUSSOR
c pseudo application from the NAS Parallel Benchmarks. 
c
c---------------------------------------------------------------------

      implicit none

      include 'mpinpb.h'
      include 'applu.incl'

      integer nodedim
      integer IERROR


c---------------------------------------------------------------------
c    initialize MPI communication
c---------------------------------------------------------------------
      call MPI_INIT( IERROR )

c---------------------------------------------------------------------
c   establish the global rank of this process
c---------------------------------------------------------------------
      call MPI_COMM_RANK( MPI_COMM_WORLD,
     >                     id,
     >                     IERROR )

c---------------------------------------------------------------------
c   establish the size of the global group
c---------------------------------------------------------------------
      call MPI_COMM_SIZE( MPI_COMM_WORLD,
     >                     num,
     >                     IERROR )

      if (num .lt. nnodes_compiled) then
         if (id .eq. 0) write (*,2000) num, nnodes_compiled
2000     format(' Error: number of processes',i6,
     >          ' less than compiled',i6)
         CALL MPI_ABORT( MPI_COMM_WORLD, MPI_ERR_OTHER, IERROR )
      endif

      ndim   = nodedim(num)

      if (.not. convertdouble) then
         dp_type = MPI_DOUBLE_PRECISION
      else
         dp_type = MPI_REAL
      endif


      return
      end
