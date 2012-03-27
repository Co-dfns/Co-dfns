
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
      include 'work_lhs_vec.h'

      integer i,j,k,m,n,isize

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      if (timeron) call timer_start(t_xsolve)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     This function computes the left hand side in the xi-direction
c---------------------------------------------------------------------

      isize = grid_points(1)-1

c---------------------------------------------------------------------
c     determine a (labeled f) and n jacobians
c---------------------------------------------------------------------
!$omp parallel do default(shared) shared(isize)
!$omp& private(i,j,k,m,n)
      do k = 1, grid_points(3)-2
         do j = 1, grid_points(2)-2
            do i = 0, isize

               tmp1 = rho_i(i,j,k)
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

               fjac(2,1,i,j) = -(u(2,i,j,k) * tmp2 * 
     >              u(2,i,j,k))
     >              + c2 * qs(i,j,k)
               fjac(2,2,i,j) = ( 2.0d+00 - c2 )
     >              * ( u(2,i,j,k) / u(1,i,j,k) )
               fjac(2,3,i,j) = - c2 * ( u(3,i,j,k) * tmp1 )
               fjac(2,4,i,j) = - c2 * ( u(4,i,j,k) * tmp1 )
               fjac(2,5,i,j) = c2

               fjac(3,1,i,j) = - ( u(2,i,j,k)*u(3,i,j,k) ) * tmp2
               fjac(3,2,i,j) = u(3,i,j,k) * tmp1
               fjac(3,3,i,j) = u(2,i,j,k) * tmp1
               fjac(3,4,i,j) = 0.0d+00
               fjac(3,5,i,j) = 0.0d+00

               fjac(4,1,i,j) = - ( u(2,i,j,k)*u(4,i,j,k) ) * tmp2
               fjac(4,2,i,j) = u(4,i,j,k) * tmp1
               fjac(4,3,i,j) = 0.0d+00
               fjac(4,4,i,j) = u(2,i,j,k) * tmp1
               fjac(4,5,i,j) = 0.0d+00

               fjac(5,1,i,j) = ( c2 * 2.0d0 * square(i,j,k)
     >              - c1 * u(5,i,j,k) )
     >              * ( u(2,i,j,k) * tmp2 )
               fjac(5,2,i,j) = c1 *  u(5,i,j,k) * tmp1 
     >              - c2
     >              * ( u(2,i,j,k)*u(2,i,j,k) * tmp2
     >              + qs(i,j,k) )
               fjac(5,3,i,j) = - c2 * ( u(3,i,j,k)*u(2,i,j,k) )
     >              * tmp2
               fjac(5,4,i,j) = - c2 * ( u(4,i,j,k)*u(2,i,j,k) )
     >              * tmp2
               fjac(5,5,i,j) = c1 * ( u(2,i,j,k) * tmp1 )

               njac(1,1,i,j) = 0.0d+00
               njac(1,2,i,j) = 0.0d+00
               njac(1,3,i,j) = 0.0d+00
               njac(1,4,i,j) = 0.0d+00
               njac(1,5,i,j) = 0.0d+00

               njac(2,1,i,j) = - con43 * c3c4 * tmp2 * u(2,i,j,k)
               njac(2,2,i,j) =   con43 * c3c4 * tmp1
               njac(2,3,i,j) =   0.0d+00
               njac(2,4,i,j) =   0.0d+00
               njac(2,5,i,j) =   0.0d+00

               njac(3,1,i,j) = - c3c4 * tmp2 * u(3,i,j,k)
               njac(3,2,i,j) =   0.0d+00
               njac(3,3,i,j) =   c3c4 * tmp1
               njac(3,4,i,j) =   0.0d+00
               njac(3,5,i,j) =   0.0d+00

               njac(4,1,i,j) = - c3c4 * tmp2 * u(4,i,j,k)
               njac(4,2,i,j) =   0.0d+00 
               njac(4,3,i,j) =   0.0d+00
               njac(4,4,i,j) =   c3c4 * tmp1
               njac(4,5,i,j) =   0.0d+00

               njac(5,1,i,j) = - ( con43 * c3c4
     >              - c1345 ) * tmp3 * (u(2,i,j,k)**2)
     >              - ( c3c4 - c1345 ) * tmp3 * (u(3,i,j,k)**2)
     >              - ( c3c4 - c1345 ) * tmp3 * (u(4,i,j,k)**2)
     >              - c1345 * tmp2 * u(5,i,j,k)

               njac(5,2,i,j) = ( con43 * c3c4
     >              - c1345 ) * tmp2 * u(2,i,j,k)
               njac(5,3,i,j) = ( c3c4 - c1345 ) * tmp2 * u(3,i,j,k)
               njac(5,4,i,j) = ( c3c4 - c1345 ) * tmp2 * u(4,i,j,k)
               njac(5,5,i,j) = ( c1345 ) * tmp1

            enddo
         enddo

c---------------------------------------------------------------------
c     zero the left hand side for starters
c     set diagonal values to 1. This is overkill, but convenient
c---------------------------------------------------------------------
         do j = 1, grid_points(2)-2
            do m = 1, 5
               do n = 1, 5
                  lhs(m,n,aa,0,j) = 0.0d0
                  lhs(m,n,bb,0,j) = 0.0d0
                  lhs(m,n,cc,0,j) = 0.0d0
                  lhs(m,n,aa,isize,j) = 0.0d0
                  lhs(m,n,bb,isize,j) = 0.0d0
                  lhs(m,n,cc,isize,j) = 0.0d0
               end do
               lhs(m,m,bb,0,j) = 1.0d0
               lhs(m,m,bb,isize,j) = 1.0d0
            end do
         enddo

c---------------------------------------------------------------------
c     now jacobians set, so form left hand side in x direction
c---------------------------------------------------------------------
         do j = 1, grid_points(2)-2
            do i = 1, isize-1

               tmp1 = dt * tx1
               tmp2 = dt * tx2

               lhs(1,1,aa,i,j) = - tmp2 * fjac(1,1,i-1,j)
     >              - tmp1 * njac(1,1,i-1,j)
     >              - tmp1 * dx1 
               lhs(1,2,aa,i,j) = - tmp2 * fjac(1,2,i-1,j)
     >              - tmp1 * njac(1,2,i-1,j)
               lhs(1,3,aa,i,j) = - tmp2 * fjac(1,3,i-1,j)
     >              - tmp1 * njac(1,3,i-1,j)
               lhs(1,4,aa,i,j) = - tmp2 * fjac(1,4,i-1,j)
     >              - tmp1 * njac(1,4,i-1,j)
               lhs(1,5,aa,i,j) = - tmp2 * fjac(1,5,i-1,j)
     >              - tmp1 * njac(1,5,i-1,j)

               lhs(2,1,aa,i,j) = - tmp2 * fjac(2,1,i-1,j)
     >              - tmp1 * njac(2,1,i-1,j)
               lhs(2,2,aa,i,j) = - tmp2 * fjac(2,2,i-1,j)
     >              - tmp1 * njac(2,2,i-1,j)
     >              - tmp1 * dx2
               lhs(2,3,aa,i,j) = - tmp2 * fjac(2,3,i-1,j)
     >              - tmp1 * njac(2,3,i-1,j)
               lhs(2,4,aa,i,j) = - tmp2 * fjac(2,4,i-1,j)
     >              - tmp1 * njac(2,4,i-1,j)
               lhs(2,5,aa,i,j) = - tmp2 * fjac(2,5,i-1,j)
     >              - tmp1 * njac(2,5,i-1,j)

               lhs(3,1,aa,i,j) = - tmp2 * fjac(3,1,i-1,j)
     >              - tmp1 * njac(3,1,i-1,j)
               lhs(3,2,aa,i,j) = - tmp2 * fjac(3,2,i-1,j)
     >              - tmp1 * njac(3,2,i-1,j)
               lhs(3,3,aa,i,j) = - tmp2 * fjac(3,3,i-1,j)
     >              - tmp1 * njac(3,3,i-1,j)
     >              - tmp1 * dx3 
               lhs(3,4,aa,i,j) = - tmp2 * fjac(3,4,i-1,j)
     >              - tmp1 * njac(3,4,i-1,j)
               lhs(3,5,aa,i,j) = - tmp2 * fjac(3,5,i-1,j)
     >              - tmp1 * njac(3,5,i-1,j)

               lhs(4,1,aa,i,j) = - tmp2 * fjac(4,1,i-1,j)
     >              - tmp1 * njac(4,1,i-1,j)
               lhs(4,2,aa,i,j) = - tmp2 * fjac(4,2,i-1,j)
     >              - tmp1 * njac(4,2,i-1,j)
               lhs(4,3,aa,i,j) = - tmp2 * fjac(4,3,i-1,j)
     >              - tmp1 * njac(4,3,i-1,j)
               lhs(4,4,aa,i,j) = - tmp2 * fjac(4,4,i-1,j)
     >              - tmp1 * njac(4,4,i-1,j)
     >              - tmp1 * dx4
               lhs(4,5,aa,i,j) = - tmp2 * fjac(4,5,i-1,j)
     >              - tmp1 * njac(4,5,i-1,j)

               lhs(5,1,aa,i,j) = - tmp2 * fjac(5,1,i-1,j)
     >              - tmp1 * njac(5,1,i-1,j)
               lhs(5,2,aa,i,j) = - tmp2 * fjac(5,2,i-1,j)
     >              - tmp1 * njac(5,2,i-1,j)
               lhs(5,3,aa,i,j) = - tmp2 * fjac(5,3,i-1,j)
     >              - tmp1 * njac(5,3,i-1,j)
               lhs(5,4,aa,i,j) = - tmp2 * fjac(5,4,i-1,j)
     >              - tmp1 * njac(5,4,i-1,j)
               lhs(5,5,aa,i,j) = - tmp2 * fjac(5,5,i-1,j)
     >              - tmp1 * njac(5,5,i-1,j)
     >              - tmp1 * dx5

               lhs(1,1,bb,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(1,1,i,j)
     >              + tmp1 * 2.0d+00 * dx1
               lhs(1,2,bb,i,j) = tmp1 * 2.0d+00 * njac(1,2,i,j)
               lhs(1,3,bb,i,j) = tmp1 * 2.0d+00 * njac(1,3,i,j)
               lhs(1,4,bb,i,j) = tmp1 * 2.0d+00 * njac(1,4,i,j)
               lhs(1,5,bb,i,j) = tmp1 * 2.0d+00 * njac(1,5,i,j)

               lhs(2,1,bb,i,j) = tmp1 * 2.0d+00 * njac(2,1,i,j)
               lhs(2,2,bb,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(2,2,i,j)
     >              + tmp1 * 2.0d+00 * dx2
               lhs(2,3,bb,i,j) = tmp1 * 2.0d+00 * njac(2,3,i,j)
               lhs(2,4,bb,i,j) = tmp1 * 2.0d+00 * njac(2,4,i,j)
               lhs(2,5,bb,i,j) = tmp1 * 2.0d+00 * njac(2,5,i,j)

               lhs(3,1,bb,i,j) = tmp1 * 2.0d+00 * njac(3,1,i,j)
               lhs(3,2,bb,i,j) = tmp1 * 2.0d+00 * njac(3,2,i,j)
               lhs(3,3,bb,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(3,3,i,j)
     >              + tmp1 * 2.0d+00 * dx3
               lhs(3,4,bb,i,j) = tmp1 * 2.0d+00 * njac(3,4,i,j)
               lhs(3,5,bb,i,j) = tmp1 * 2.0d+00 * njac(3,5,i,j)

               lhs(4,1,bb,i,j) = tmp1 * 2.0d+00 * njac(4,1,i,j)
               lhs(4,2,bb,i,j) = tmp1 * 2.0d+00 * njac(4,2,i,j)
               lhs(4,3,bb,i,j) = tmp1 * 2.0d+00 * njac(4,3,i,j)
               lhs(4,4,bb,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(4,4,i,j)
     >              + tmp1 * 2.0d+00 * dx4
               lhs(4,5,bb,i,j) = tmp1 * 2.0d+00 * njac(4,5,i,j)

               lhs(5,1,bb,i,j) = tmp1 * 2.0d+00 * njac(5,1,i,j)
               lhs(5,2,bb,i,j) = tmp1 * 2.0d+00 * njac(5,2,i,j)
               lhs(5,3,bb,i,j) = tmp1 * 2.0d+00 * njac(5,3,i,j)
               lhs(5,4,bb,i,j) = tmp1 * 2.0d+00 * njac(5,4,i,j)
               lhs(5,5,bb,i,j) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(5,5,i,j)
     >              + tmp1 * 2.0d+00 * dx5

               lhs(1,1,cc,i,j) =  tmp2 * fjac(1,1,i+1,j)
     >              - tmp1 * njac(1,1,i+1,j)
     >              - tmp1 * dx1
               lhs(1,2,cc,i,j) =  tmp2 * fjac(1,2,i+1,j)
     >              - tmp1 * njac(1,2,i+1,j)
               lhs(1,3,cc,i,j) =  tmp2 * fjac(1,3,i+1,j)
     >              - tmp1 * njac(1,3,i+1,j)
               lhs(1,4,cc,i,j) =  tmp2 * fjac(1,4,i+1,j)
     >              - tmp1 * njac(1,4,i+1,j)
               lhs(1,5,cc,i,j) =  tmp2 * fjac(1,5,i+1,j)
     >              - tmp1 * njac(1,5,i+1,j)

               lhs(2,1,cc,i,j) =  tmp2 * fjac(2,1,i+1,j)
     >              - tmp1 * njac(2,1,i+1,j)
               lhs(2,2,cc,i,j) =  tmp2 * fjac(2,2,i+1,j)
     >              - tmp1 * njac(2,2,i+1,j)
     >              - tmp1 * dx2
               lhs(2,3,cc,i,j) =  tmp2 * fjac(2,3,i+1,j)
     >              - tmp1 * njac(2,3,i+1,j)
               lhs(2,4,cc,i,j) =  tmp2 * fjac(2,4,i+1,j)
     >              - tmp1 * njac(2,4,i+1,j)
               lhs(2,5,cc,i,j) =  tmp2 * fjac(2,5,i+1,j)
     >              - tmp1 * njac(2,5,i+1,j)

               lhs(3,1,cc,i,j) =  tmp2 * fjac(3,1,i+1,j)
     >              - tmp1 * njac(3,1,i+1,j)
               lhs(3,2,cc,i,j) =  tmp2 * fjac(3,2,i+1,j)
     >              - tmp1 * njac(3,2,i+1,j)
               lhs(3,3,cc,i,j) =  tmp2 * fjac(3,3,i+1,j)
     >              - tmp1 * njac(3,3,i+1,j)
     >              - tmp1 * dx3
               lhs(3,4,cc,i,j) =  tmp2 * fjac(3,4,i+1,j)
     >              - tmp1 * njac(3,4,i+1,j)
               lhs(3,5,cc,i,j) =  tmp2 * fjac(3,5,i+1,j)
     >              - tmp1 * njac(3,5,i+1,j)

               lhs(4,1,cc,i,j) =  tmp2 * fjac(4,1,i+1,j)
     >              - tmp1 * njac(4,1,i+1,j)
               lhs(4,2,cc,i,j) =  tmp2 * fjac(4,2,i+1,j)
     >              - tmp1 * njac(4,2,i+1,j)
               lhs(4,3,cc,i,j) =  tmp2 * fjac(4,3,i+1,j)
     >              - tmp1 * njac(4,3,i+1,j)
               lhs(4,4,cc,i,j) =  tmp2 * fjac(4,4,i+1,j)
     >              - tmp1 * njac(4,4,i+1,j)
     >              - tmp1 * dx4
               lhs(4,5,cc,i,j) =  tmp2 * fjac(4,5,i+1,j)
     >              - tmp1 * njac(4,5,i+1,j)

               lhs(5,1,cc,i,j) =  tmp2 * fjac(5,1,i+1,j)
     >              - tmp1 * njac(5,1,i+1,j)
               lhs(5,2,cc,i,j) =  tmp2 * fjac(5,2,i+1,j)
     >              - tmp1 * njac(5,2,i+1,j)
               lhs(5,3,cc,i,j) =  tmp2 * fjac(5,3,i+1,j)
     >              - tmp1 * njac(5,3,i+1,j)
               lhs(5,4,cc,i,j) =  tmp2 * fjac(5,4,i+1,j)
     >              - tmp1 * njac(5,4,i+1,j)
               lhs(5,5,cc,i,j) =  tmp2 * fjac(5,5,i+1,j)
     >              - tmp1 * njac(5,5,i+1,j)
     >              - tmp1 * dx5

            enddo
         enddo

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

c---------------------------------------------------------------------
c     outer most do loops - sweeping in i direction
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     multiply c(0,j,k) by b_inverse and copy back to c
c     multiply rhs(0) by b_inverse(0) and copy to rhs
c---------------------------------------------------------------------
!dir$ ivdep
         do j = 1, grid_points(2)-2
            call binvcrhs( lhs(1,1,bb,0,j),
     >                        lhs(1,1,cc,0,j),
     >                        rhs(1,0,j,k) )
         enddo

c---------------------------------------------------------------------
c     begin inner most do loop
c     do all the elements of the cell unless last 
c---------------------------------------------------------------------
!dir$ ivdep
!dir$ interchange(i,j)
         do j = 1, grid_points(2)-2
            do i=1,isize-1

c---------------------------------------------------------------------
c     rhs(i) = rhs(i) - A*rhs(i-1)
c---------------------------------------------------------------------
               call matvec_sub(lhs(1,1,aa,i,j),
     >                         rhs(1,i-1,j,k),rhs(1,i,j,k))

c---------------------------------------------------------------------
c     B(i) = B(i) - C(i-1)*A(i)
c---------------------------------------------------------------------
               call matmul_sub(lhs(1,1,aa,i,j),
     >                         lhs(1,1,cc,i-1,j),
     >                         lhs(1,1,bb,i,j))


c---------------------------------------------------------------------
c     multiply c(i,j,k) by b_inverse and copy back to c
c     multiply rhs(1,j,k) by b_inverse(1,j,k) and copy to rhs
c---------------------------------------------------------------------
               call binvcrhs( lhs(1,1,bb,i,j),
     >                        lhs(1,1,cc,i,j),
     >                        rhs(1,i,j,k) )

            enddo
         enddo

c---------------------------------------------------------------------
c     rhs(isize) = rhs(isize) - A*rhs(isize-1)
c---------------------------------------------------------------------
!dir$ ivdep
         do j = 1, grid_points(2)-2
            call matvec_sub(lhs(1,1,aa,isize,j),
     >                         rhs(1,isize-1,j,k),rhs(1,isize,j,k))

c---------------------------------------------------------------------
c     B(isize) = B(isize) - C(isize-1)*A(isize)
c---------------------------------------------------------------------
            call matmul_sub(lhs(1,1,aa,isize,j),
     >                         lhs(1,1,cc,isize-1,j),
     >                         lhs(1,1,bb,isize,j))

c---------------------------------------------------------------------
c     multiply rhs() by b_inverse() and copy to rhs
c---------------------------------------------------------------------
            call binvrhs( lhs(1,1,bb,isize,j),
     >                       rhs(1,isize,j,k) )
         enddo


c---------------------------------------------------------------------
c     back solve: if last cell, then generate U(isize)=rhs(isize)
c     else assume U(isize) is loaded in un pack backsub_info
c     so just use it
c     after call u(istart) will be sent to next cell
c---------------------------------------------------------------------

         do j = 1, grid_points(2)-2
            do i=isize-1,0,-1
               do m=1,BLOCK_SIZE
                  do n=1,BLOCK_SIZE
                     rhs(m,i,j,k) = rhs(m,i,j,k) 
     >                    - lhs(m,n,cc,i,j)*rhs(n,i+1,j,k)
                  enddo
               enddo
            enddo
         enddo

      enddo
      if (timeron) call timer_stop(t_xsolve)

      return
      end
      
