c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine z_solve

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     Performs line solves in Z direction by first factoring
c     the block-tridiagonal matrix into an upper triangular matrix, 
c     and then performing back substitution to solve for the unknow
c     vectors of each line.  
c     
c     Make sure we treat elements zero to cell_size in the direction
c     of the sweep.
c---------------------------------------------------------------------

      include 'header.h'
      include 'work_lhs_vec.h'

      integer i, j, k, m, n, ksize
      
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      if (timeron) call timer_start(t_zsolve)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     This function computes the left hand side for the three z-factors 
c---------------------------------------------------------------------

      ksize = grid_points(3)-1

c---------------------------------------------------------------------
c     Compute the indices for storing the block-diagonal matrix;
c     determine c (labeled f) and s jacobians
c---------------------------------------------------------------------
!$omp parallel do default(shared) shared(ksize)
!$omp& private(i,j,k,m,n)
      do j = 1, grid_points(2)-2
         do k = 0, ksize
            do i = 1, grid_points(1)-2

               tmp1 = 1.0d+00 / u(1,i,j,k)
               tmp2 = tmp1 * tmp1
               tmp3 = tmp1 * tmp2

               fjac(1,1,i,k) = 0.0d+00
               fjac(1,2,i,k) = 0.0d+00
               fjac(1,3,i,k) = 0.0d+00
               fjac(1,4,i,k) = 1.0d+00
               fjac(1,5,i,k) = 0.0d+00

               fjac(2,1,i,k) = - ( u(2,i,j,k)*u(4,i,j,k) ) 
     >              * tmp2 
               fjac(2,2,i,k) = u(4,i,j,k) * tmp1
               fjac(2,3,i,k) = 0.0d+00
               fjac(2,4,i,k) = u(2,i,j,k) * tmp1
               fjac(2,5,i,k) = 0.0d+00

               fjac(3,1,i,k) = - ( u(3,i,j,k)*u(4,i,j,k) )
     >              * tmp2 
               fjac(3,2,i,k) = 0.0d+00
               fjac(3,3,i,k) = u(4,i,j,k) * tmp1
               fjac(3,4,i,k) = u(3,i,j,k) * tmp1
               fjac(3,5,i,k) = 0.0d+00

               fjac(4,1,i,k) = - (u(4,i,j,k)*u(4,i,j,k) * tmp2 ) 
     >              + c2 * qs(i,j,k)
               fjac(4,2,i,k) = - c2 *  u(2,i,j,k) * tmp1 
               fjac(4,3,i,k) = - c2 *  u(3,i,j,k) * tmp1
               fjac(4,4,i,k) = ( 2.0d+00 - c2 )
     >              *  u(4,i,j,k) * tmp1 
               fjac(4,5,i,k) = c2

               fjac(5,1,i,k) = ( c2 * 2.0d0 * square(i,j,k) 
     >              - c1 * u(5,i,j,k) )
     >              * u(4,i,j,k) * tmp2
               fjac(5,2,i,k) = - c2 * ( u(2,i,j,k)*u(4,i,j,k) )
     >              * tmp2 
               fjac(5,3,i,k) = - c2 * ( u(3,i,j,k)*u(4,i,j,k) )
     >              * tmp2
               fjac(5,4,i,k) = c1 * ( u(5,i,j,k) * tmp1 )
     >              - c2
     >              * ( qs(i,j,k)
     >              + u(4,i,j,k)*u(4,i,j,k) * tmp2 )
               fjac(5,5,i,k) = c1 * u(4,i,j,k) * tmp1

               njac(1,1,i,k) = 0.0d+00
               njac(1,2,i,k) = 0.0d+00
               njac(1,3,i,k) = 0.0d+00
               njac(1,4,i,k) = 0.0d+00
               njac(1,5,i,k) = 0.0d+00

               njac(2,1,i,k) = - c3c4 * tmp2 * u(2,i,j,k)
               njac(2,2,i,k) =   c3c4 * tmp1
               njac(2,3,i,k) =   0.0d+00
               njac(2,4,i,k) =   0.0d+00
               njac(2,5,i,k) =   0.0d+00

               njac(3,1,i,k) = - c3c4 * tmp2 * u(3,i,j,k)
               njac(3,2,i,k) =   0.0d+00
               njac(3,3,i,k) =   c3c4 * tmp1
               njac(3,4,i,k) =   0.0d+00
               njac(3,5,i,k) =   0.0d+00

               njac(4,1,i,k) = - con43 * c3c4 * tmp2 * u(4,i,j,k)
               njac(4,2,i,k) =   0.0d+00
               njac(4,3,i,k) =   0.0d+00
               njac(4,4,i,k) =   con43 * c3 * c4 * tmp1
               njac(4,5,i,k) =   0.0d+00

               njac(5,1,i,k) = - (  c3c4
     >              - c1345 ) * tmp3 * (u(2,i,j,k)**2)
     >              - ( c3c4 - c1345 ) * tmp3 * (u(3,i,j,k)**2)
     >              - ( con43 * c3c4
     >              - c1345 ) * tmp3 * (u(4,i,j,k)**2)
     >              - c1345 * tmp2 * u(5,i,j,k)

               njac(5,2,i,k) = (  c3c4 - c1345 ) * tmp2 * u(2,i,j,k)
               njac(5,3,i,k) = (  c3c4 - c1345 ) * tmp2 * u(3,i,j,k)
               njac(5,4,i,k) = ( con43 * c3c4
     >              - c1345 ) * tmp2 * u(4,i,j,k)
               njac(5,5,i,k) = ( c1345 )* tmp1


            enddo
         enddo

c---------------------------------------------------------------------
c     zero the whole left hand side for starters
c     set all diagonal values to 1. This is overkill, but convenient
c---------------------------------------------------------------------
         do i = 1, grid_points(1)-2
            do m = 1, 5
               do n = 1, 5
                  lhs(m,n,aa,i,0) = 0.0d0
                  lhs(m,n,bb,i,0) = 0.0d0
                  lhs(m,n,cc,i,0) = 0.0d0
                  lhs(m,n,aa,i,ksize) = 0.0d0
                  lhs(m,n,bb,i,ksize) = 0.0d0
                  lhs(m,n,cc,i,ksize) = 0.0d0
               end do
               lhs(m,m,bb,i,0) = 1.0d0
               lhs(m,m,bb,i,ksize) = 1.0d0
            end do
         enddo

c---------------------------------------------------------------------
c     now jacobians set, so form left hand side in z direction
c---------------------------------------------------------------------
         do k = 1, ksize-1
            do i = 1, grid_points(1)-2

               tmp1 = dt * tz1
               tmp2 = dt * tz2

               lhs(1,1,aa,i,k) = - tmp2 * fjac(1,1,i,k-1)
     >              - tmp1 * njac(1,1,i,k-1)
     >              - tmp1 * dz1 
               lhs(1,2,aa,i,k) = - tmp2 * fjac(1,2,i,k-1)
     >              - tmp1 * njac(1,2,i,k-1)
               lhs(1,3,aa,i,k) = - tmp2 * fjac(1,3,i,k-1)
     >              - tmp1 * njac(1,3,i,k-1)
               lhs(1,4,aa,i,k) = - tmp2 * fjac(1,4,i,k-1)
     >              - tmp1 * njac(1,4,i,k-1)
               lhs(1,5,aa,i,k) = - tmp2 * fjac(1,5,i,k-1)
     >              - tmp1 * njac(1,5,i,k-1)

               lhs(2,1,aa,i,k) = - tmp2 * fjac(2,1,i,k-1)
     >              - tmp1 * njac(2,1,i,k-1)
               lhs(2,2,aa,i,k) = - tmp2 * fjac(2,2,i,k-1)
     >              - tmp1 * njac(2,2,i,k-1)
     >              - tmp1 * dz2
               lhs(2,3,aa,i,k) = - tmp2 * fjac(2,3,i,k-1)
     >              - tmp1 * njac(2,3,i,k-1)
               lhs(2,4,aa,i,k) = - tmp2 * fjac(2,4,i,k-1)
     >              - tmp1 * njac(2,4,i,k-1)
               lhs(2,5,aa,i,k) = - tmp2 * fjac(2,5,i,k-1)
     >              - tmp1 * njac(2,5,i,k-1)

               lhs(3,1,aa,i,k) = - tmp2 * fjac(3,1,i,k-1)
     >              - tmp1 * njac(3,1,i,k-1)
               lhs(3,2,aa,i,k) = - tmp2 * fjac(3,2,i,k-1)
     >              - tmp1 * njac(3,2,i,k-1)
               lhs(3,3,aa,i,k) = - tmp2 * fjac(3,3,i,k-1)
     >              - tmp1 * njac(3,3,i,k-1)
     >              - tmp1 * dz3 
               lhs(3,4,aa,i,k) = - tmp2 * fjac(3,4,i,k-1)
     >              - tmp1 * njac(3,4,i,k-1)
               lhs(3,5,aa,i,k) = - tmp2 * fjac(3,5,i,k-1)
     >              - tmp1 * njac(3,5,i,k-1)

               lhs(4,1,aa,i,k) = - tmp2 * fjac(4,1,i,k-1)
     >              - tmp1 * njac(4,1,i,k-1)
               lhs(4,2,aa,i,k) = - tmp2 * fjac(4,2,i,k-1)
     >              - tmp1 * njac(4,2,i,k-1)
               lhs(4,3,aa,i,k) = - tmp2 * fjac(4,3,i,k-1)
     >              - tmp1 * njac(4,3,i,k-1)
               lhs(4,4,aa,i,k) = - tmp2 * fjac(4,4,i,k-1)
     >              - tmp1 * njac(4,4,i,k-1)
     >              - tmp1 * dz4
               lhs(4,5,aa,i,k) = - tmp2 * fjac(4,5,i,k-1)
     >              - tmp1 * njac(4,5,i,k-1)

               lhs(5,1,aa,i,k) = - tmp2 * fjac(5,1,i,k-1)
     >              - tmp1 * njac(5,1,i,k-1)
               lhs(5,2,aa,i,k) = - tmp2 * fjac(5,2,i,k-1)
     >              - tmp1 * njac(5,2,i,k-1)
               lhs(5,3,aa,i,k) = - tmp2 * fjac(5,3,i,k-1)
     >              - tmp1 * njac(5,3,i,k-1)
               lhs(5,4,aa,i,k) = - tmp2 * fjac(5,4,i,k-1)
     >              - tmp1 * njac(5,4,i,k-1)
               lhs(5,5,aa,i,k) = - tmp2 * fjac(5,5,i,k-1)
     >              - tmp1 * njac(5,5,i,k-1)
     >              - tmp1 * dz5

               lhs(1,1,bb,i,k) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(1,1,i,k)
     >              + tmp1 * 2.0d+00 * dz1
               lhs(1,2,bb,i,k) = tmp1 * 2.0d+00 * njac(1,2,i,k)
               lhs(1,3,bb,i,k) = tmp1 * 2.0d+00 * njac(1,3,i,k)
               lhs(1,4,bb,i,k) = tmp1 * 2.0d+00 * njac(1,4,i,k)
               lhs(1,5,bb,i,k) = tmp1 * 2.0d+00 * njac(1,5,i,k)

               lhs(2,1,bb,i,k) = tmp1 * 2.0d+00 * njac(2,1,i,k)
               lhs(2,2,bb,i,k) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(2,2,i,k)
     >              + tmp1 * 2.0d+00 * dz2
               lhs(2,3,bb,i,k) = tmp1 * 2.0d+00 * njac(2,3,i,k)
               lhs(2,4,bb,i,k) = tmp1 * 2.0d+00 * njac(2,4,i,k)
               lhs(2,5,bb,i,k) = tmp1 * 2.0d+00 * njac(2,5,i,k)

               lhs(3,1,bb,i,k) = tmp1 * 2.0d+00 * njac(3,1,i,k)
               lhs(3,2,bb,i,k) = tmp1 * 2.0d+00 * njac(3,2,i,k)
               lhs(3,3,bb,i,k) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(3,3,i,k)
     >              + tmp1 * 2.0d+00 * dz3
               lhs(3,4,bb,i,k) = tmp1 * 2.0d+00 * njac(3,4,i,k)
               lhs(3,5,bb,i,k) = tmp1 * 2.0d+00 * njac(3,5,i,k)

               lhs(4,1,bb,i,k) = tmp1 * 2.0d+00 * njac(4,1,i,k)
               lhs(4,2,bb,i,k) = tmp1 * 2.0d+00 * njac(4,2,i,k)
               lhs(4,3,bb,i,k) = tmp1 * 2.0d+00 * njac(4,3,i,k)
               lhs(4,4,bb,i,k) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(4,4,i,k)
     >              + tmp1 * 2.0d+00 * dz4
               lhs(4,5,bb,i,k) = tmp1 * 2.0d+00 * njac(4,5,i,k)

               lhs(5,1,bb,i,k) = tmp1 * 2.0d+00 * njac(5,1,i,k)
               lhs(5,2,bb,i,k) = tmp1 * 2.0d+00 * njac(5,2,i,k)
               lhs(5,3,bb,i,k) = tmp1 * 2.0d+00 * njac(5,3,i,k)
               lhs(5,4,bb,i,k) = tmp1 * 2.0d+00 * njac(5,4,i,k)
               lhs(5,5,bb,i,k) = 1.0d+00
     >              + tmp1 * 2.0d+00 * njac(5,5,i,k) 
     >              + tmp1 * 2.0d+00 * dz5

               lhs(1,1,cc,i,k) =  tmp2 * fjac(1,1,i,k+1)
     >              - tmp1 * njac(1,1,i,k+1)
     >              - tmp1 * dz1
               lhs(1,2,cc,i,k) =  tmp2 * fjac(1,2,i,k+1)
     >              - tmp1 * njac(1,2,i,k+1)
               lhs(1,3,cc,i,k) =  tmp2 * fjac(1,3,i,k+1)
     >              - tmp1 * njac(1,3,i,k+1)
               lhs(1,4,cc,i,k) =  tmp2 * fjac(1,4,i,k+1)
     >              - tmp1 * njac(1,4,i,k+1)
               lhs(1,5,cc,i,k) =  tmp2 * fjac(1,5,i,k+1)
     >              - tmp1 * njac(1,5,i,k+1)

               lhs(2,1,cc,i,k) =  tmp2 * fjac(2,1,i,k+1)
     >              - tmp1 * njac(2,1,i,k+1)
               lhs(2,2,cc,i,k) =  tmp2 * fjac(2,2,i,k+1)
     >              - tmp1 * njac(2,2,i,k+1)
     >              - tmp1 * dz2
               lhs(2,3,cc,i,k) =  tmp2 * fjac(2,3,i,k+1)
     >              - tmp1 * njac(2,3,i,k+1)
               lhs(2,4,cc,i,k) =  tmp2 * fjac(2,4,i,k+1)
     >              - tmp1 * njac(2,4,i,k+1)
               lhs(2,5,cc,i,k) =  tmp2 * fjac(2,5,i,k+1)
     >              - tmp1 * njac(2,5,i,k+1)

               lhs(3,1,cc,i,k) =  tmp2 * fjac(3,1,i,k+1)
     >              - tmp1 * njac(3,1,i,k+1)
               lhs(3,2,cc,i,k) =  tmp2 * fjac(3,2,i,k+1)
     >              - tmp1 * njac(3,2,i,k+1)
               lhs(3,3,cc,i,k) =  tmp2 * fjac(3,3,i,k+1)
     >              - tmp1 * njac(3,3,i,k+1)
     >              - tmp1 * dz3
               lhs(3,4,cc,i,k) =  tmp2 * fjac(3,4,i,k+1)
     >              - tmp1 * njac(3,4,i,k+1)
               lhs(3,5,cc,i,k) =  tmp2 * fjac(3,5,i,k+1)
     >              - tmp1 * njac(3,5,i,k+1)

               lhs(4,1,cc,i,k) =  tmp2 * fjac(4,1,i,k+1)
     >              - tmp1 * njac(4,1,i,k+1)
               lhs(4,2,cc,i,k) =  tmp2 * fjac(4,2,i,k+1)
     >              - tmp1 * njac(4,2,i,k+1)
               lhs(4,3,cc,i,k) =  tmp2 * fjac(4,3,i,k+1)
     >              - tmp1 * njac(4,3,i,k+1)
               lhs(4,4,cc,i,k) =  tmp2 * fjac(4,4,i,k+1)
     >              - tmp1 * njac(4,4,i,k+1)
     >              - tmp1 * dz4
               lhs(4,5,cc,i,k) =  tmp2 * fjac(4,5,i,k+1)
     >              - tmp1 * njac(4,5,i,k+1)

               lhs(5,1,cc,i,k) =  tmp2 * fjac(5,1,i,k+1)
     >              - tmp1 * njac(5,1,i,k+1)
               lhs(5,2,cc,i,k) =  tmp2 * fjac(5,2,i,k+1)
     >              - tmp1 * njac(5,2,i,k+1)
               lhs(5,3,cc,i,k) =  tmp2 * fjac(5,3,i,k+1)
     >              - tmp1 * njac(5,3,i,k+1)
               lhs(5,4,cc,i,k) =  tmp2 * fjac(5,4,i,k+1)
     >              - tmp1 * njac(5,4,i,k+1)
               lhs(5,5,cc,i,k) =  tmp2 * fjac(5,5,i,k+1)
     >              - tmp1 * njac(5,5,i,k+1)
     >              - tmp1 * dz5

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
c     c'(KMAX) and rhs'(KMAX) will be sent to next cell.
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     outer most do loops - sweeping in i direction
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     multiply c(i,j,0) by b_inverse and copy back to c
c     multiply rhs(0) by b_inverse(0) and copy to rhs
c---------------------------------------------------------------------
!dir$ ivdep
         do i = 1, grid_points(1)-2
            call binvcrhs( lhs(1,1,bb,i,0),
     >                        lhs(1,1,cc,i,0),
     >                        rhs(1,i,j,0) )
         enddo


c---------------------------------------------------------------------
c     begin inner most do loop
c     do all the elements of the cell unless last 
c---------------------------------------------------------------------
         do k=1,ksize-1
!dir$ ivdep
            do i = 1, grid_points(1)-2

c---------------------------------------------------------------------
c     subtract A*lhs_vector(k-1) from lhs_vector(k)
c     
c     rhs(k) = rhs(k) - A*rhs(k-1)
c---------------------------------------------------------------------
               call matvec_sub(lhs(1,1,aa,i,k),
     >                         rhs(1,i,j,k-1),rhs(1,i,j,k))

c---------------------------------------------------------------------
c     B(k) = B(k) - C(k-1)*A(k)
c     call matmul_sub(aa,i,j,k,c,cc,i,j,k-1,c,bb,i,j,k)
c---------------------------------------------------------------------
               call matmul_sub(lhs(1,1,aa,i,k),
     >                         lhs(1,1,cc,i,k-1),
     >                         lhs(1,1,bb,i,k))

c---------------------------------------------------------------------
c     multiply c(i,j,k) by b_inverse and copy back to c
c     multiply rhs(i,j,1) by b_inverse(i,j,1) and copy to rhs
c---------------------------------------------------------------------
               call binvcrhs( lhs(1,1,bb,i,k),
     >                        lhs(1,1,cc,i,k),
     >                        rhs(1,i,j,k) )

            enddo
         enddo

c---------------------------------------------------------------------
c     Now finish up special cases for last cell
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     rhs(ksize) = rhs(ksize) - A*rhs(ksize-1)
c---------------------------------------------------------------------
!dir$ ivdep
         do i = 1, grid_points(1)-2
            call matvec_sub(lhs(1,1,aa,i,ksize),
     >                         rhs(1,i,j,ksize-1),rhs(1,i,j,ksize))

c---------------------------------------------------------------------
c     B(ksize) = B(ksize) - C(ksize-1)*A(ksize)
c     call matmul_sub(aa,i,j,ksize,c,
c     $              cc,i,j,ksize-1,c,bb,i,j,ksize)
c---------------------------------------------------------------------
            call matmul_sub(lhs(1,1,aa,i,ksize),
     >                         lhs(1,1,cc,i,ksize-1),
     >                         lhs(1,1,bb,i,ksize))

c---------------------------------------------------------------------
c     multiply rhs(ksize) by b_inverse(ksize) and copy to rhs
c---------------------------------------------------------------------
            call binvrhs( lhs(1,1,bb,i,ksize),
     >                       rhs(1,i,j,ksize) )
         enddo


c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     back solve: if last cell, then generate U(ksize)=rhs(ksize)
c     else assume U(ksize) is loaded in un pack backsub_info
c     so just use it
c     after call u(kstart) will be sent to next cell
c---------------------------------------------------------------------

         do k=ksize-1,0,-1
            do i = 1, grid_points(1)-2
               do m=1,BLOCK_SIZE
                  do n=1,BLOCK_SIZE
                     rhs(m,i,j,k) = rhs(m,i,j,k) 
     >                    - lhs(m,n,cc,i,k)*rhs(n,i,j,k+1)
                  enddo
               enddo
            enddo
         enddo

      enddo
      if (timeron) call timer_stop(t_zsolve)

      return
      end
