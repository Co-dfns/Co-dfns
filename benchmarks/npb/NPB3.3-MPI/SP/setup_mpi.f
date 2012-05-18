
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine setup_mpi

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c set up MPI stuff
c---------------------------------------------------------------------

      implicit none
      include 'mpinpb.h'
      include 'npbparams.h'
      integer error, nc, color

      call mpi_init(error)
      
      call mpi_comm_size(MPI_COMM_WORLD, total_nodes, error)
      call mpi_comm_rank(MPI_COMM_WORLD, node, error)

      if (.not. convertdouble) then
         dp_type = MPI_DOUBLE_PRECISION
      else
         dp_type = MPI_REAL
      endif

c---------------------------------------------------------------------
c     compute square root; add small number to allow for roundoff
c---------------------------------------------------------------------
      nc = dint(dsqrt(dble(total_nodes) + 0.00001d0))

c---------------------------------------------------------------------
c We handle a non-square number of nodes by making the excess nodes
c inactive. However, we can never handle more cells than were compiled
c in. 
c---------------------------------------------------------------------

      if (nc .gt. maxcells) nc = maxcells

      if (node .ge. nc*nc) then
         active = .false.
         color = 1
      else
         active = .true.
         color = 0
      end if
      
      call mpi_comm_split(MPI_COMM_WORLD,color,node,comm_setup,error)
      if (.not. active) return

      call mpi_comm_size(comm_setup, no_nodes, error)
      call mpi_comm_dup(comm_setup, comm_solve, error)
      call mpi_comm_dup(comm_setup, comm_rhs, error)
      
c---------------------------------------------------------------------
c     let node 0 be the root for the group (there is only one)
c---------------------------------------------------------------------
      root = 0

      return
      end

