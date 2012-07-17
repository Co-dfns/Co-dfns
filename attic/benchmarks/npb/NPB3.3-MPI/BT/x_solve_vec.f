
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine x_solve

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     
c     Performs line solves in X direction by first factoring
c     the block-tridiagonal matrix into an upper triangular matrix, 
c     and then performing back substitution to solve for the unknow
c     vectors of each line.  
c     
c     Make sure we treat elements zero to cell_size in the direction
c     of the sweep.
c     
c---------------------------------------------------------------------

      include 'header.h'
      include 'mpinpb.h'
      integer  c, istart, stage,
     >     first, last, recv_id, error, r_status(MPI_STATUS_SIZE),
     >     isize,jsize,ksize,send_id

      istart = 0

      if (timeron) call timer_start(t_xsolve)
c---------------------------------------------------------------------
c     in our terminology stage is the number of the cell in the x-direct
c     i.e. stage = 1 means the start of the line stage=ncells means end
c---------------------------------------------------------------------
      do stage = 1,ncells
         c = slice(1,stage)
         isize = cell_size(1,c) - 1
         jsize = cell_size(2,c) - 1
         ksize = cell_size(3,c) - 1
         
c---------------------------------------------------------------------
c     set last-cell flag
c---------------------------------------------------------------------
         if (stage .eq. ncells) then
            last = 1
         else
            last = 0
         endif

         if (stage .eq. 1) then
c---------------------------------------------------------------------
c     This is the first cell, so solve without receiving data
c---------------------------------------------------------------------
            first = 1
c            call lhsx(c)
            call x_solve_cell(first,last,c)
         else
c---------------------------------------------------------------------
c     Not the first cell of this line, so receive info from
c     processor working on preceeding cell
c---------------------------------------------------------------------
            first = 0
            if (timeron) call timer_start(t_xcomm)
            call x_receive_solve_info(recv_id,c)
c---------------------------------------------------------------------
c     overlap computations and communications
c---------------------------------------------------------------------
c            call lhsx(c)
c---------------------------------------------------------------------
c     wait for completion
c---------------------------------------------------------------------
            call mpi_wait(send_id,r_status,error)
            call mpi_wait(recv_id,r_status,error)
            if (timeron) call timer_stop(t_xcomm)
c---------------------------------------------------------------------
c     install C'(istart) and rhs'(istart) to be used in this cell
c---------------------------------------------------------------------
            call x_unpack_solve_info(c)
            call x_solve_cell(first,last,c)
         endif

         if (last .eq. 0) call x_send_solve_info(send_id,c)
      enddo

c---------------------------------------------------------------------
c     now perform backsubstitution in reverse direction
c---------------------------------------------------------------------
      do stage = ncells, 1, -1
         c = slice(1,stage)
         first = 0
         last = 0
         if (stage .eq. 1) first = 1
         if (stage .eq. ncells) then
            last = 1
c---------------------------------------------------------------------
c     last cell, so perform back substitute without waiting
c---------------------------------------------------------------------
            call x_backsubstitute(first, last,c)
         else
            if (timeron) call timer_start(t_xcomm)
            call x_receive_backsub_info(recv_id,c)
            call mpi_wait(send_id,r_status,error)
            call mpi_wait(recv_id,r_status,error)
            if (timeron) call timer_stop(t_xcomm)
            call x_unpack_backsub_info(c)
            call x_backsubstitute(first,last,c)
         endif
         if (first .eq. 0) call x_send_backsub_info(send_id,c)
      enddo

      if (timeron) call timer_stop(t_xsolve)

      return
      end
      
      
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine x_unpack_solve_info(c)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     unpack C'(-1) and rhs'(-1) for
c     all j and k
c---------------------------------------------------------------------

      include 'header.h'
      integer j,k,m,n,ptr,c,istart 

      istart = 0
      ptr = 0
      do k=0,KMAX-1
         do j=0,JMAX-1
            do m=1,BLOCK_SIZE
               do n=1,BLOCK_SIZE
                  lhsc(m,n,istart-1,j,k,c) = out_buffer(ptr+n)
               enddo
               ptr = ptr+BLOCK_SIZE
            enddo
            do n=1,BLOCK_SIZE
               rhs(n,istart-1,j,k,c) = out_buffer(ptr+n)
            enddo
            ptr = ptr+BLOCK_SIZE
         enddo
      enddo

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------
      
      subroutine x_send_solve_info(send_id,c)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     pack up and send C'(iend) and rhs'(iend) for
c     all j and k
c---------------------------------------------------------------------

      include 'header.h'
      include 'mpinpb.h'

      integer j,k,m,n,isize,ptr,c,jp,kp
      integer error,send_id,buffer_size 

      isize = cell_size(1,c)-1
      jp = cell_coord(2,c) - 1
      kp = cell_coord(3,c) - 1
      buffer_size=MAX_CELL_DIM*MAX_CELL_DIM*
     >     (BLOCK_SIZE*BLOCK_SIZE + BLOCK_SIZE)

c---------------------------------------------------------------------
c     pack up buffer
c---------------------------------------------------------------------
      ptr = 0
      do k=0,KMAX-1
         do j=0,JMAX-1
            do m=1,BLOCK_SIZE
               do n=1,BLOCK_SIZE
                  in_buffer(ptr+n) = lhsc(m,n,isize,j,k,c)
               enddo
               ptr = ptr+BLOCK_SIZE
            enddo
            do n=1,BLOCK_SIZE
               in_buffer(ptr+n) = rhs(n,isize,j,k,c)
            enddo
            ptr = ptr+BLOCK_SIZE
         enddo
      enddo

c---------------------------------------------------------------------
c     send buffer 
c---------------------------------------------------------------------
      if (timeron) call timer_start(t_xcomm)
      call mpi_isend(in_buffer, buffer_size,
     >     dp_type, successor(1),
     >     WEST+jp+kp*NCELLS, comm_solve,
     >     send_id,error)
      if (timeron) call timer_stop(t_xcomm)

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine x_send_backsub_info(send_id,c)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     pack up and send U(istart) for all j and k
c---------------------------------------------------------------------

      include 'header.h'
      include 'mpinpb.h'

      integer j,k,n,ptr,c,istart,jp,kp
      integer error,send_id,buffer_size

c---------------------------------------------------------------------
c     Send element 0 to previous processor
c---------------------------------------------------------------------
      istart = 0
      jp = cell_coord(2,c)-1
      kp = cell_coord(3,c)-1
      buffer_size=MAX_CELL_DIM*MAX_CELL_DIM*BLOCK_SIZE
      ptr = 0
      do k=0,KMAX-1
         do j=0,JMAX-1
            do n=1,BLOCK_SIZE
               in_buffer(ptr+n) = rhs(n,istart,j,k,c)
            enddo
            ptr = ptr+BLOCK_SIZE
         enddo
      enddo
      if (timeron) call timer_start(t_xcomm)
      call mpi_isend(in_buffer, buffer_size,
     >     dp_type, predecessor(1), 
     >     EAST+jp+kp*NCELLS, comm_solve, 
     >     send_id,error)
      if (timeron) call timer_stop(t_xcomm)

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine x_unpack_backsub_info(c)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     unpack U(isize) for all j and k
c---------------------------------------------------------------------

      include 'header.h'
      integer j,k,n,ptr,c

      ptr = 0
      do k=0,KMAX-1
         do j=0,JMAX-1
            do n=1,BLOCK_SIZE
               backsub_info(n,j,k,c) = out_buffer(ptr+n)
            enddo
            ptr = ptr+BLOCK_SIZE
         enddo
      enddo

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine x_receive_backsub_info(recv_id,c)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     post mpi receives
c---------------------------------------------------------------------

      include 'header.h'
      include 'mpinpb.h'

      integer error,recv_id,jp,kp,c,buffer_size
      jp = cell_coord(2,c) - 1
      kp = cell_coord(3,c) - 1
      buffer_size=MAX_CELL_DIM*MAX_CELL_DIM*BLOCK_SIZE
      call mpi_irecv(out_buffer, buffer_size,
     >     dp_type, successor(1), 
     >     EAST+jp+kp*NCELLS, comm_solve, 
     >     recv_id, error)

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine x_receive_solve_info(recv_id,c)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     post mpi receives 
c---------------------------------------------------------------------

      include 'header.h'
      include 'mpinpb.h'

      integer jp,kp,recv_id,error,c,buffer_size
      jp = cell_coord(2,c) - 1
      kp = cell_coord(3,c) - 1
      buffer_size=MAX_CELL_DIM*MAX_CELL_DIM*
     >     (BLOCK_SIZE*BLOCK_SIZE + BLOCK_SIZE)
      call mpi_irecv(out_buffer, buffer_size,
     >     dp_type, predecessor(1), 
     >     WEST+jp+kp*NCELLS,  comm_solve, 
     >     recv_id, error)

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------
      
      subroutine x_backsubstitute(first, last, c)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     back solve: if last cell, then generate U(isize)=rhs(isize)
c     else assume U(isize) is loaded in un pack backsub_info
c     so just use it
c     after call u(istart) will be sent to next cell
c---------------------------------------------------------------------

      include 'header.h'

      integer first, last, c, i, j, k
      integer m,n,isize,jsize,ksize,istart
      
      istart = 0
      isize = cell_size(1,c)-1
      jsize = cell_size(2,c)-end(2,c)-1      
      ksize = cell_size(3,c)-end(3,c)-1
      if (last .eq. 0) then
         do k=start(3,c),ksize
            do j=start(2,c),jsize
c---------------------------------------------------------------------
c     U(isize) uses info from previous cell if not last cell
c---------------------------------------------------------------------
               do m=1,BLOCK_SIZE
                  do n=1,BLOCK_SIZE
                     rhs(m,isize,j,k,c) = rhs(m,isize,j,k,c) 
     >                    - lhsc(m,n,isize,j,k,c)*
     >                    backsub_info(n,j,k,c)
c---------------------------------------------------------------------
c     rhs(m,isize,j,k,c) = rhs(m,isize,j,k,c) 
c     $                    - lhsc(m,n,isize,j,k,c)*rhs(n,isize+1,j,k,c)
c---------------------------------------------------------------------
                  enddo
               enddo
            enddo
         enddo
      endif
      do k=start(3,c),ksize
         do j=start(2,c),jsize
            do i=isize-1,istart,-1
               do m=1,BLOCK_SIZE
                  do n=1,BLOCK_SIZE
                     rhs(m,i,j,k,c) = rhs(m,i,j,k,c) 
     >                    - lhsc(m,n,i,j,k,c)*rhs(n,i+1,j,k,c)
                  enddo
               enddo
            enddo
         enddo
      enddo

      return
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine x_solve_cell(first,last,c)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     performs guaussian elimination on this cell.
c     
c     assumes that unpacking routines for non-first cells 
c     preload C' and rhs' from previous cell.
c     
c     assumed send happens outside this routine, but that
c     c'(IMAX) and rhs'(IMAX) will be sent to next cell
c---------------------------------------------------------------------

      include 'header.h'
      include 'work_lhs_vec.h'

      integer first,last,c
      integer i,j,k,m,n,isize,ksize,jsize,istart

      istart = 0
      isize = cell_size(1,c)-1
      jsize = cell_size(2,c)-end(2,c)-1
      ksize = cell_size(3,c)-end(3,c)-1

c---------------------------------------------------------------------
c     zero the left hand side for starters
c     set diagonal values to 1. This is overkill, but convenient
c---------------------------------------------------------------------
      do j = 0, jsize
         do m = 1, 5
            do n = 1, 5
               lhsa(m,n,0,j) = 0.0d0
               lhsb(m,n,0,j) = 0.0d0
               lhsa(m,n,isize,j) = 0.0d0
               lhsb(m,n,isize,j) = 0.0d0
            enddo
            lhsb(m,m,0,j) = 1.0d0
            lhsb(m,m,isize,j) = 1.0d0
         enddo
      enddo

      do k=start(3,c),ksize 

c---------------------------------------------------------------------
c     This function computes the left hand side in the xi-direction
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     determine a (labeled f) and n jacobians for cell c
c---------------------------------------------------------------------
         do j=start(2,c),jsize
            do i = start(1,c)-1, cell_size(1,c) - end(1,c)

               tmp1 = rho_i(i,j,k,c)
               tmp2 = tmp1 * tmp1
               tmp3 = tmp1 * tmp2
c---------------------------------------------------------------------
c     
c---------------------------------------------------------------------
               fjac(1,1,i,j) = 0.0d+00
               fjac(1,2,i,j) = 1.0d+00
               fjac(1,3,i,j) = 0.0d+00
               fjac(1,4,i,j) = 0.0d+00
               fjac(1,5,i,j) = 0.0d+00

               fjac(2,1,i,j) = -(u(2,i,j,k,c) * tmp2 * 
     >              u(2,i,j,k,c))
     >              + c2 * qs(i,j,k,c)
               fjac(2,2,i,j) = ( 2.0d+00 - c2 )
     >              * ( u(2,i,j,k,c) * tmp1 )
               fjac(2,3,i,j) = - c2 * ( u(3,i,j,k,c) * tmp1 )
               fjac(2,4,i,j) = - c2 * ( u(4,i,j,k,c) * tmp1 )
               fjac(2,5,i,j) = c2

               fjac(3,1,i,j) = - ( u(2,i,j,k,c)*u(3,i,j,k,c) ) * tmp2
               fjac(3,2,i,j) = u(3,i,j,k,c) * tmp1
               fjac(3,3,i,j) = u(2,i,j,k,c) * tmp1
               fjac(3,4,i,j) = 0.0d+00
               fjac(3,5,i,j) = 0.0d+00

               fjac(4,1,i,j) = - ( u(2,i,j,k,c)*u(4,i,j,k,c) ) * tmp2
               fjac(4,2,i,j) = u(4,i,j,k,c) * tmp1
               fjac(4,3,i,j) = 0.0d+00
               fjac(4,4,i,j) = u(2,i,j,k,c) * tmp1
               fjac(4,5,i,j) = 0.0d+00

               fjac(5,1,i,j) = ( c2 * 2.0d0 * qs(i,j,k,c)
     >              - c1 * ( u(5,i,j,k,c) * tmp1 ) )
     >              * ( u(2,i,j,k,c) * tmp1 )
               fjac(5,2,i,j) = c1 *  u(5,i,j,k,c) * tmp1 
     >              - c2
     >              * ( u(2,i,j,k,c)*u(2,i,j,k,c) * tmp2
     >              + qs(i,j,k,c) )
               fjac(5,3,i,j) = - c2 * ( u(3,i,j,k,c)*u(2,i,j,k,c) )
     >              * tmp2
               fjac(5,4,i,j) = - c2 * ( u(4,i,j,k,c)*u(2,i,j,k,c) )
     >              * tmp2
               fjac(5,5,i,j) = c1 * ( u(2,i,j,k,c) * tmp1 )

               njac(1,1,i,j) = 0.0d+00
               njac(1,2,i,j) = 0.0d+00
               njac(1,3,i,j) = 0.0d+00
               njac(1,4,i,j) = 0.0d+00
               njac(1,5,i,j) = 0.0d+00

               njac(2,1,i,j) = - con43 * c3c4 * tmp2 * u(2,i,j,k,c)
               njac(2,2,i,j) =   con43 * c3c4 * tmp1
               njac(2,3,i,j) =   0.0d+00
               njac(2,4,i,j) =   0.0d+00
               njac(2,5,i,j) =   0.0d+00

               njac(3,1,i,j) = - c3c4 * tmp2 * u(3,i,j,k,c)
               njac(3,2,i,j) =   0.0d+00
               njac(3,3,i,j) =   c3c4 * tmp1
               njac(3,4,i,j) =   0.0d+00
               njac(3,5,i,j) =   0.0d+00

               njac(4,1,i,j) = - c3c4 * tmp2 * u(4,i,j,k,c)
               njac(4,2,i,j) =   0.0d+00 
               njac(4,3,i,j) =   0.0d+00
               njac(4,4,i,j) =   c3c4 * tmp1
               njac(4,5,i,j) =   0.0d+00

               njac(5,1,i,j) = - ( con43 * c3c4
     >              - c1345 ) * tmp3 * (u(2,i,j,k,c)**2)
     >              - ( c3c4 - c1345 ) * tmp3 * (u(3,i,j,k,c)**2)
     >              - ( c3c4 - c1345 ) * tmp3 * (u(4,i,j,k,c)**2)
     >              - c1345 * tmp2 * u(5,i,j,k,c)

               njac(5,2,i,j) = ( con43 * c3c4
     >              - c1345 ) * tmp2 * u(2,i,j,k,c)
               njac(5,3,i,j) = ( c3c4 - c1345 ) * tmp2 * u(3,i,j,k,c)
               njac(5,4,i,j) = ( c3c4 - c1345 ) * tmp2 * u(4,i,j,k,c)
               njac(5,5,i,j) = ( c1345 ) * tmp1

            enddo
         enddo

c---------------------------------------------------------------------
c     now jacobians set, so form left hand side in x direction
c---------------------------------------------------------------------
         do j=start(2,c),jsize
            do i = start(1,c), isize - end(1,c)

               tmp1 = dt * tx1
               tmp2 = dt * tx2

               lhsa(1,1,i,j) = - tmp2 * fjac(1,1,i-1,j)
     >              - tmp1 * njac(1,1,i-1,j)
     >              - tmp1 * dx1 
               lhsa(1,2,i,j) = - tmp2 * fjac(1,2,i-1,j)
     >              - tmp1 * njac(1,2,i-1,j)
               lhsa(1,3,i,j) = - tmp2 * fjac(1,3,i-1,j)
     >              - tmp1 * njac(1,3,i-1,j)
               lhsa(1,4,i,j) = - tmp2 * fjac(1,4,i-1,j)
     >              - tmp1 * njac(1,4,i-1,j)
               lhsa(1,5,i,j) = - tmp2 * fjac(1,5,i-1,j)
     >              - tmp1 * njac(1,5,i-1,j)

               lhsa(2,1,i,j) = - tmp2 * fjac(2,1,i-1,j)
     >              - tmp1 * njac(2,1,i-1,j)
               lhsa(2,2,i,j) = - tmp2 * fjac(2,2,i-1,j)
     >              - tmp1 * njac(2,2,i-1,j)
     >              - tmp1 * dx2
               lhsa(2,3,i,j) = - tmp2 * fjac(2,3,i-1,j)
     >              - tmp1 * njac(2,3,i-1,j)
               lhsa(2,4,i,j) = - tmp2 * fjac(2,4,i-1,j)
     >              - tmp1 * njac(2,4,i-1,j)
               lhsa(2,5,i,j) = - tmp2 * fjac(2,5,i-1,j)
     >              - tmp1 * njac(2,5,i-1,j)

               lhsa(3,1,i,j) = - tmp2 * fjac(3,1,i-1,j)
     >              - tmp1 * njac(3,1,i-1,j)
               lhsa(3,2,i,j) = - tmp2 * fjac(3,2,i-1,j)
     >              - tmp1 * njac(3,2,i-1,j)
               lhsa(3,3,i,j) = - tmp2 * fjac(3,3,i-1,j)
     >              - tmp1 * njac(3,3,i-1,j)
     >              - tmp1 * dx3 
               lhsa(3,4,i,j) = - tmp2 * fjac(3,4,i-1,j)
     >              - tmp1 * njac(3,4,i-1,j)
               lhsa(3,5,i,j) = - tmp2 * fjac(3,5,i-1,j)
     >              - tmp1 * njac(3,5,i-1,j)

               lhsa(4,1,i,j) = - tmp2 * fjac(4,1,i-1,j)
     >              - tmp1 * njac(4,1,i-1,j)
               lhsa(4,2,i,j) = - tmp2 * fjac(4,2,i-1,j)
     >              - tmp1 * njac(4,2,i-1,j)
               lhsa(4,3,i,j) = - tmp2 * fjac(4,3,i-1,j)
     >              - tmp1 * njac(4,3,i-1,j)
               lhsa(4,4,i,j) = - tmp2 * fjac(4,4,i-1,j)
     >              - tmp1 * njac(4,4,i-1,j)
     >              - tmp1 * dx4
               lhsa(4,5,i,j) = - tmp2 * fjac(4,5,i-1,j)
     >              - tmp1 * njac(4,5,i-1,j)

               lhsa(5,1,i,j) = - tmp2 * fjac(5,1,i-1,j)
     >              - tmp1 * njac(5,1,i-1,j)
               lhsa(5,2,i,j) = - tmp2 * fjac(5,2,i-1,j)
     >              - tmp1 * njac(5,2,i-1,j)
               lhsa(5,3,i,j) = - tmp2 * fjac(5,3,i-1,j)
     >              - tmp1 * njac(5,3,i-1,j)
               lhsa(5,4,i,j) = - tmp2 * fjac(5,4,i-1,j)
     >              - tmp1 * njac(5,4,i-1,j)
               lhsa(5,5,i,j) = - tmp2 * fjac(5,5,i-1,j)
     >              - tmp1 * njac(5,5,i-1,j)
     >              - tmp1 * dx5

               lhsb(1,1,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(1,1,i,j)
     >              + tmp1 * 2.0d+00 * dx1
               lhsb(1,2,i,j) = tmp1 * 2.0d+00 * njac(1,2,i,j)
               lhsb(1,3,i,j) = tmp1 * 2.0d+00 * njac(1,3,i,j)
               lhsb(1,4,i,j) = tmp1 * 2.0d+00 * njac(1,4,i,j)
               lhsb(1,5,i,j) = tmp1 * 2.0d+00 * njac(1,5,i,j)

               lhsb(2,1,i,j) = tmp1 * 2.0d+00 * njac(2,1,i,j)
               lhsb(2,2,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(2,2,i,j)
     >              + tmp1 * 2.0d+00 * dx2
               lhsb(2,3,i,j) = tmp1 * 2.0d+00 * njac(2,3,i,j)
               lhsb(2,4,i,j) = tmp1 * 2.0d+00 * njac(2,4,i,j)
               lhsb(2,5,i,j) = tmp1 * 2.0d+00 * njac(2,5,i,j)

               lhsb(3,1,i,j) = tmp1 * 2.0d+00 * njac(3,1,i,j)
               lhsb(3,2,i,j) = tmp1 * 2.0d+00 * njac(3,2,i,j)
               lhsb(3,3,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(3,3,i,j)
     >              + tmp1 * 2.0d+00 * dx3
               lhsb(3,4,i,j) = tmp1 * 2.0d+00 * njac(3,4,i,j)
               lhsb(3,5,i,j) = tmp1 * 2.0d+00 * njac(3,5,i,j)

               lhsb(4,1,i,j) = tmp1 * 2.0d+00 * njac(4,1,i,j)
               lhsb(4,2,i,j) = tmp1 * 2.0d+00 * njac(4,2,i,j)
               lhsb(4,3,i,j) = tmp1 * 2.0d+00 * njac(4,3,i,j)
               lhsb(4,4,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(4,4,i,j)
     >              + tmp1 * 2.0d+00 * dx4
               lhsb(4,5,i,j) = tmp1 * 2.0d+00 * njac(4,5,i,j)

               lhsb(5,1,i,j) = tmp1 * 2.0d+00 * njac(5,1,i,j)
               lhsb(5,2,i,j) = tmp1 * 2.0d+00 * njac(5,2,i,j)
               lhsb(5,3,i,j) = tmp1 * 2.0d+00 * njac(5,3,i,j)
               lhsb(5,4,i,j) = tmp1 * 2.0d+00 * njac(5,4,i,j)
               lhsb(5,5,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(5,5,i,j)
     >              + tmp1 * 2.0d+00 * dx5

               lhsc(1,1,i,j,k,c) =  tmp2 * fjac(1,1,i+1,j)
     >              - tmp1 * njac(1,1,i+1,j)
     >              - tmp1 * dx1
               lhsc(1,2,i,j,k,c) =  tmp2 * fjac(1,2,i+1,j)
     >              - tmp1 * njac(1,2,i+1,j)
               lhsc(1,3,i,j,k,c) =  tmp2 * fjac(1,3,i+1,j)
     >              - tmp1 * njac(1,3,i+1,j)
               lhsc(1,4,i,j,k,c) =  tmp2 * fjac(1,4,i+1,j)
     >              - tmp1 * njac(1,4,i+1,j)
               lhsc(1,5,i,j,k,c) =  tmp2 * fjac(1,5,i+1,j)
     >              - tmp1 * njac(1,5,i+1,j)

               lhsc(2,1,i,j,k,c) =  tmp2 * fjac(2,1,i+1,j)
     >              - tmp1 * njac(2,1,i+1,j)
               lhsc(2,2,i,j,k,c) =  tmp2 * fjac(2,2,i+1,j)
     >              - tmp1 * njac(2,2,i+1,j)
     >              - tmp1 * dx2
               lhsc(2,3,i,j,k,c) =  tmp2 * fjac(2,3,i+1,j)
     >              - tmp1 * njac(2,3,i+1,j)
               lhsc(2,4,i,j,k,c) =  tmp2 * fjac(2,4,i+1,j)
     >              - tmp1 * njac(2,4,i+1,j)
               lhsc(2,5,i,j,k,c) =  tmp2 * fjac(2,5,i+1,j)
     >              - tmp1 * njac(2,5,i+1,j)

               lhsc(3,1,i,j,k,c) =  tmp2 * fjac(3,1,i+1,j)
     >              - tmp1 * njac(3,1,i+1,j)
               lhsc(3,2,i,j,k,c) =  tmp2 * fjac(3,2,i+1,j)
     >              - tmp1 * njac(3,2,i+1,j)
               lhsc(3,3,i,j,k,c) =  tmp2 * fjac(3,3,i+1,j)
     >              - tmp1 * njac(3,3,i+1,j)
     >              - tmp1 * dx3
               lhsc(3,4,i,j,k,c) =  tmp2 * fjac(3,4,i+1,j)
     >              - tmp1 * njac(3,4,i+1,j)
               lhsc(3,5,i,j,k,c) =  tmp2 * fjac(3,5,i+1,j)
     >              - tmp1 * njac(3,5,i+1,j)

               lhsc(4,1,i,j,k,c) =  tmp2 * fjac(4,1,i+1,j)
     >              - tmp1 * njac(4,1,i+1,j)
               lhsc(4,2,i,j,k,c) =  tmp2 * fjac(4,2,i+1,j)
     >              - tmp1 * njac(4,2,i+1,j)
               lhsc(4,3,i,j,k,c) =  tmp2 * fjac(4,3,i+1,j)
     >              - tmp1 * njac(4,3,i+1,j)
               lhsc(4,4,i,j,k,c) =  tmp2 * fjac(4,4,i+1,j)
     >              - tmp1 * njac(4,4,i+1,j)
     >              - tmp1 * dx4
               lhsc(4,5,i,j,k,c) =  tmp2 * fjac(4,5,i+1,j)
     >              - tmp1 * njac(4,5,i+1,j)

               lhsc(5,1,i,j,k,c) =  tmp2 * fjac(5,1,i+1,j)
     >              - tmp1 * njac(5,1,i+1,j)
               lhsc(5,2,i,j,k,c) =  tmp2 * fjac(5,2,i+1,j)
     >              - tmp1 * njac(5,2,i+1,j)
               lhsc(5,3,i,j,k,c) =  tmp2 * fjac(5,3,i+1,j)
     >              - tmp1 * njac(5,3,i+1,j)
               lhsc(5,4,i,j,k,c) =  tmp2 * fjac(5,4,i+1,j)
     >              - tmp1 * njac(5,4,i+1,j)
               lhsc(5,5,i,j,k,c) =  tmp2 * fjac(5,5,i+1,j)
     >              - tmp1 * njac(5,5,i+1,j)
     >              - tmp1 * dx5

            enddo
         enddo


c---------------------------------------------------------------------
c     outer most do loops - sweeping in i direction
c---------------------------------------------------------------------
         if (first .eq. 1) then 

c---------------------------------------------------------------------
c     multiply c(istart,j,k) by b_inverse and copy back to c
c     multiply rhs(istart) by b_inverse(istart) and copy to rhs
c---------------------------------------------------------------------
!dir$ ivdep
            do j=start(2,c),jsize
               call binvcrhs( lhsb(1,1,istart,j),
     >                        lhsc(1,1,istart,j,k,c),
     >                        rhs(1,istart,j,k,c) )
            enddo

         endif

c---------------------------------------------------------------------
c     begin inner most do loop
c     do all the elements of the cell unless last 
c---------------------------------------------------------------------
!dir$ ivdep
!dir$ interchange(i,j)
         do j=start(2,c),jsize
            do i=istart+first,isize-last

c---------------------------------------------------------------------
c     rhs(i) = rhs(i) - A*rhs(i-1)
c---------------------------------------------------------------------
               call matvec_sub(lhsa(1,1,i,j),
     >                         rhs(1,i-1,j,k,c),rhs(1,i,j,k,c))

c---------------------------------------------------------------------
c     B(i) = B(i) - C(i-1)*A(i)
c---------------------------------------------------------------------
               call matmul_sub(lhsa(1,1,i,j),
     >                         lhsc(1,1,i-1,j,k,c),
     >                         lhsb(1,1,i,j))


c---------------------------------------------------------------------
c     multiply c(i,j,k) by b_inverse and copy back to c
c     multiply rhs(1,j,k) by b_inverse(1,j,k) and copy to rhs
c---------------------------------------------------------------------
               call binvcrhs( lhsb(1,1,i,j),
     >                        lhsc(1,1,i,j,k,c),
     >                        rhs(1,i,j,k,c) )

            enddo
         enddo

c---------------------------------------------------------------------
c     Now finish up special cases for last cell
c---------------------------------------------------------------------
         if (last .eq. 1) then

!dir$ ivdep
            do j=start(2,c),jsize
c---------------------------------------------------------------------
c     rhs(isize) = rhs(isize) - A*rhs(isize-1)
c---------------------------------------------------------------------
               call matvec_sub(lhsa(1,1,isize,j),
     >                         rhs(1,isize-1,j,k,c),rhs(1,isize,j,k,c))

c---------------------------------------------------------------------
c     B(isize) = B(isize) - C(isize-1)*A(isize)
c---------------------------------------------------------------------
               call matmul_sub(lhsa(1,1,isize,j),
     >                         lhsc(1,1,isize-1,j,k,c),
     >                         lhsb(1,1,isize,j))

c---------------------------------------------------------------------
c     multiply rhs() by b_inverse() and copy to rhs
c---------------------------------------------------------------------
               call binvrhs( lhsb(1,1,isize,j),
     >                       rhs(1,isize,j,k,c) )
            enddo

         endif
      enddo


      return
      end
      
