
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine proc_grid

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none

      include 'mpinpb.h'
      include 'applu.incl'

c---------------------------------------------------------------------
c  local variables
c---------------------------------------------------------------------
      integer xdim0, ydim0, IERROR

c---------------------------------------------------------------------
c
c   set up a two-d grid for processors: column-major ordering of unknowns
c
c---------------------------------------------------------------------

      xdim0  = nnodes_xdim
      ydim0  = nnodes_compiled/xdim0

      ydim   = dsqrt(dble(num))+0.001d0
      xdim   = num/ydim
      do while (ydim .ge. ydim0 .and. xdim*ydim .ne. num)
         ydim = ydim - 1
         xdim = num/ydim
      end do

      if (xdim .lt. xdim0 .or. ydim .lt. ydim0 .or. 
     &    xdim*ydim .ne. num) then
         if (id .eq. 0) write(*,2000) num
2000     format(' Error: couldn''t determine proper proc_grid',
     &          ' for nprocs=', i6)
         CALL MPI_ABORT( MPI_COMM_WORLD, MPI_ERR_OTHER, IERROR )
      endif

      if (id .eq. 0 .and. num .ne. 2**ndim)
     &   write(*,2100) num, xdim, ydim
2100  format(' Proc_grid for nprocs =',i6,':',i5,' x',i5)

      row    = mod(id,xdim) + 1
      col    = id/xdim + 1


      return
      end


