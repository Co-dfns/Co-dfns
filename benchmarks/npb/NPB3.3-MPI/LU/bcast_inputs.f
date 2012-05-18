c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine bcast_inputs

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none

      include 'mpinpb.h'
      include 'applu.incl'

c---------------------------------------------------------------------
c  local variables
c---------------------------------------------------------------------
      integer ierr

c---------------------------------------------------------------------
c   root broadcasts the data
c   The data isn't contiguous or of the same type, so it's not
c   clear how to send it in the "MPI" way. 
c   We could pack the info into a buffer or we could create
c   an obscene datatype to handle it all at once. Since we only
c   broadcast the data once, just use a separate broadcast for
c   each piece. 
c---------------------------------------------------------------------
      call MPI_BCAST(ipr, 1, MPI_INTEGER, root, MPI_COMM_WORLD, ierr)
      call MPI_BCAST(inorm, 1, MPI_INTEGER, root, MPI_COMM_WORLD, ierr)
      call MPI_BCAST(itmax, 1, MPI_INTEGER, root, MPI_COMM_WORLD, ierr)
      call MPI_BCAST(dt, 1, dp_type, root, MPI_COMM_WORLD, ierr)
      call MPI_BCAST(omega, 1, dp_type, root, MPI_COMM_WORLD, ierr)
      call MPI_BCAST(tolrsd, 5, dp_type, root, MPI_COMM_WORLD, ierr)
      call MPI_BCAST(nx0, 1, MPI_INTEGER, root, MPI_COMM_WORLD, ierr)
      call MPI_BCAST(ny0, 1, MPI_INTEGER, root, MPI_COMM_WORLD, ierr)
      call MPI_BCAST(nz0, 1, MPI_INTEGER, root, MPI_COMM_WORLD, ierr)
      call MPI_BCAST(timeron, 1, MPI_LOGICAL, root, MPI_COMM_WORLD, 
     &               ierr)

      return
      end


