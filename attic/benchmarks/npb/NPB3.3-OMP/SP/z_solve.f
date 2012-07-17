
c---------------------------------------------------------------------
c---------------------------------------------------------------------

       subroutine z_solve

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c this function performs the solution of the approximate factorization
c step in the z-direction for all five matrix components
c simultaneously. The Thomas algorithm is employed to solve the
c systems for the z-lines. Boundary conditions are non-periodic
c---------------------------------------------------------------------

       include 'header.h'

       integer i, j, k, k1, k2, m
       double precision ru1, fac1, fac2


c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c Prepare for z-solve, array redistribution   
c---------------------------------------------------------------------

       if (timeron) call timer_start(t_zsolve)
!$omp parallel do default(shared) private(i,j,k,k1,k2,m,
!$omp&    ru1,fac1,fac2)
       do   j = 1, ny2

          call lhsinitj(nz2+1, nx2)

c---------------------------------------------------------------------
c Computes the left hand side for the three z-factors   
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c first fill the lhs for the u-eigenvalue                          
c---------------------------------------------------------------------

          do   i = 1, nx2
             do   k = 0, nz2 + 1
                ru1 = c3c4*rho_i(i,j,k)
                cv(k) = ws(i,j,k)
                rhos(k) = dmax1(dz4 + con43 * ru1,
     >                          dz5 + c1c5 * ru1,
     >                          dzmax + ru1,
     >                          dz1)
             end do

             do   k =  1, nz2
                lhs(1,i,k) =  0.0d0
                lhs(2,i,k) = -dttz2 * cv(k-1) - dttz1 * rhos(k-1)
                lhs(3,i,k) =  1.0 + c2dttz1 * rhos(k)
                lhs(4,i,k) =  dttz2 * cv(k+1) - dttz1 * rhos(k+1)
                lhs(5,i,k) =  0.0d0
             end do
          end do

c---------------------------------------------------------------------
c      add fourth order dissipation                                  
c---------------------------------------------------------------------

          do   i = 1, nx2
             k = 1
             lhs(3,i,k) = lhs(3,i,k) + comz5
             lhs(4,i,k) = lhs(4,i,k) - comz4
             lhs(5,i,k) = lhs(5,i,k) + comz1

             k = 2
             lhs(2,i,k) = lhs(2,i,k) - comz4
             lhs(3,i,k) = lhs(3,i,k) + comz6
             lhs(4,i,k) = lhs(4,i,k) - comz4
             lhs(5,i,k) = lhs(5,i,k) + comz1
          end do

          do    k = 3, nz2-2
             do   i = 1, nx2
                lhs(1,i,k) = lhs(1,i,k) + comz1
                lhs(2,i,k) = lhs(2,i,k) - comz4
                lhs(3,i,k) = lhs(3,i,k) + comz6
                lhs(4,i,k) = lhs(4,i,k) - comz4
                lhs(5,i,k) = lhs(5,i,k) + comz1
             end do
          end do

          do   i = 1, nx2
             k = nz2-1
             lhs(1,i,k) = lhs(1,i,k) + comz1
             lhs(2,i,k) = lhs(2,i,k) - comz4
             lhs(3,i,k) = lhs(3,i,k) + comz6
             lhs(4,i,k) = lhs(4,i,k) - comz4

             k = nz2
             lhs(1,i,k) = lhs(1,i,k) + comz1
             lhs(2,i,k) = lhs(2,i,k) - comz4
             lhs(3,i,k) = lhs(3,i,k) + comz5
          end do


c---------------------------------------------------------------------
c      subsequently, fill the other factors (u+c), (u-c) 
c---------------------------------------------------------------------
          do    k = 1, nz2
             do   i = 1, nx2
                lhsp(1,i,k) = lhs(1,i,k)
                lhsp(2,i,k) = lhs(2,i,k) - 
     >                            dttz2 * speed(i,j,k-1)
                lhsp(3,i,k) = lhs(3,i,k)
                lhsp(4,i,k) = lhs(4,i,k) + 
     >                            dttz2 * speed(i,j,k+1)
                lhsp(5,i,k) = lhs(5,i,k)
                lhsm(1,i,k) = lhs(1,i,k)
                lhsm(2,i,k) = lhs(2,i,k) + 
     >                            dttz2 * speed(i,j,k-1)
                lhsm(3,i,k) = lhs(3,i,k)
                lhsm(4,i,k) = lhs(4,i,k) - 
     >                            dttz2 * speed(i,j,k+1)
                lhsm(5,i,k) = lhs(5,i,k)
             end do
          end do


c---------------------------------------------------------------------
c                          FORWARD ELIMINATION  
c---------------------------------------------------------------------

          do    k = 0, grid_points(3)-3
             k1 = k  + 1
             k2 = k  + 2
             do   i = 1, nx2
                fac1      = 1.d0/lhs(3,i,k)
                lhs(4,i,k)  = fac1*lhs(4,i,k)
                lhs(5,i,k)  = fac1*lhs(5,i,k)
                do    m = 1, 3
                   rhs(m,i,j,k) = fac1*rhs(m,i,j,k)
                end do
                lhs(3,i,k1) = lhs(3,i,k1) -
     >                         lhs(2,i,k1)*lhs(4,i,k)
                lhs(4,i,k1) = lhs(4,i,k1) -
     >                         lhs(2,i,k1)*lhs(5,i,k)
                do    m = 1, 3
                   rhs(m,i,j,k1) = rhs(m,i,j,k1) -
     >                         lhs(2,i,k1)*rhs(m,i,j,k)
                end do
                lhs(2,i,k2) = lhs(2,i,k2) -
     >                         lhs(1,i,k2)*lhs(4,i,k)
                lhs(3,i,k2) = lhs(3,i,k2) -
     >                         lhs(1,i,k2)*lhs(5,i,k)
                do    m = 1, 3
                   rhs(m,i,j,k2) = rhs(m,i,j,k2) -
     >                         lhs(1,i,k2)*rhs(m,i,j,k)
                end do
             end do
          end do

c---------------------------------------------------------------------
c      The last two rows in this grid block are a bit different, 
c      since they do not have two more rows available for the
c      elimination of off-diagonal entries
c---------------------------------------------------------------------
          k  = grid_points(3)-2
          k1 = grid_points(3)-1
          do   i = 1, nx2
             fac1      = 1.d0/lhs(3,i,k)
             lhs(4,i,k)  = fac1*lhs(4,i,k)
             lhs(5,i,k)  = fac1*lhs(5,i,k)
             do    m = 1, 3
                rhs(m,i,j,k) = fac1*rhs(m,i,j,k)
             end do
             lhs(3,i,k1) = lhs(3,i,k1) -
     >                      lhs(2,i,k1)*lhs(4,i,k)
             lhs(4,i,k1) = lhs(4,i,k1) -
     >                      lhs(2,i,k1)*lhs(5,i,k)
             do    m = 1, 3
                rhs(m,i,j,k1) = rhs(m,i,j,k1) -
     >                      lhs(2,i,k1)*rhs(m,i,j,k)
             end do
c---------------------------------------------------------------------
c               scale the last row immediately
c---------------------------------------------------------------------
             fac2      = 1.d0/lhs(3,i,k1)
             do    m = 1, 3
                rhs(m,i,j,k1) = fac2*rhs(m,i,j,k1)
             end do
          end do

c---------------------------------------------------------------------
c      do the u+c and the u-c factors               
c---------------------------------------------------------------------
          do    k = 0, grid_points(3)-3
             k1 = k  + 1
             k2 = k  + 2
             do   i = 1, nx2
                m = 4
                fac1       = 1.d0/lhsp(3,i,k)
                lhsp(4,i,k)  = fac1*lhsp(4,i,k)
                lhsp(5,i,k)  = fac1*lhsp(5,i,k)
                rhs(m,i,j,k)  = fac1*rhs(m,i,j,k)
                lhsp(3,i,k1) = lhsp(3,i,k1) -
     >                       lhsp(2,i,k1)*lhsp(4,i,k)
                lhsp(4,i,k1) = lhsp(4,i,k1) -
     >                       lhsp(2,i,k1)*lhsp(5,i,k)
                rhs(m,i,j,k1) = rhs(m,i,j,k1) -
     >                       lhsp(2,i,k1)*rhs(m,i,j,k)
                lhsp(2,i,k2) = lhsp(2,i,k2) -
     >                       lhsp(1,i,k2)*lhsp(4,i,k)
                lhsp(3,i,k2) = lhsp(3,i,k2) -
     >                       lhsp(1,i,k2)*lhsp(5,i,k)
                rhs(m,i,j,k2) = rhs(m,i,j,k2) -
     >                       lhsp(1,i,k2)*rhs(m,i,j,k)
                m = 5
                fac1       = 1.d0/lhsm(3,i,k)
                lhsm(4,i,k)  = fac1*lhsm(4,i,k)
                lhsm(5,i,k)  = fac1*lhsm(5,i,k)
                rhs(m,i,j,k)  = fac1*rhs(m,i,j,k)
                lhsm(3,i,k1) = lhsm(3,i,k1) -
     >                       lhsm(2,i,k1)*lhsm(4,i,k)
                lhsm(4,i,k1) = lhsm(4,i,k1) -
     >                       lhsm(2,i,k1)*lhsm(5,i,k)
                rhs(m,i,j,k1) = rhs(m,i,j,k1) -
     >                       lhsm(2,i,k1)*rhs(m,i,j,k)
                lhsm(2,i,k2) = lhsm(2,i,k2) -
     >                       lhsm(1,i,k2)*lhsm(4,i,k)
                lhsm(3,i,k2) = lhsm(3,i,k2) -
     >                       lhsm(1,i,k2)*lhsm(5,i,k)
                rhs(m,i,j,k2) = rhs(m,i,j,k2) -
     >                       lhsm(1,i,k2)*rhs(m,i,j,k)
             end do
          end do

c---------------------------------------------------------------------
c         And again the last two rows separately
c---------------------------------------------------------------------
          k  = grid_points(3)-2
          k1 = grid_points(3)-1
          do   i = 1, nx2
             m = 4
             fac1       = 1.d0/lhsp(3,i,k)
             lhsp(4,i,k)  = fac1*lhsp(4,i,k)
             lhsp(5,i,k)  = fac1*lhsp(5,i,k)
             rhs(m,i,j,k)  = fac1*rhs(m,i,j,k)
             lhsp(3,i,k1) = lhsp(3,i,k1) -
     >                    lhsp(2,i,k1)*lhsp(4,i,k)
             lhsp(4,i,k1) = lhsp(4,i,k1) -
     >                    lhsp(2,i,k1)*lhsp(5,i,k)
             rhs(m,i,j,k1) = rhs(m,i,j,k1) -
     >                    lhsp(2,i,k1)*rhs(m,i,j,k)
             m = 5
             fac1       = 1.d0/lhsm(3,i,k)
             lhsm(4,i,k)  = fac1*lhsm(4,i,k)
             lhsm(5,i,k)  = fac1*lhsm(5,i,k)
             rhs(m,i,j,k)  = fac1*rhs(m,i,j,k)
             lhsm(3,i,k1) = lhsm(3,i,k1) -
     >                    lhsm(2,i,k1)*lhsm(4,i,k)
             lhsm(4,i,k1) = lhsm(4,i,k1) -
     >                    lhsm(2,i,k1)*lhsm(5,i,k)
             rhs(m,i,j,k1) = rhs(m,i,j,k1) -
     >                    lhsm(2,i,k1)*rhs(m,i,j,k)
c---------------------------------------------------------------------
c               Scale the last row immediately (some of this is overkill
c               if this is the last cell)
c---------------------------------------------------------------------
             rhs(4,i,j,k1) = rhs(4,i,j,k1)/lhsp(3,i,k1)
             rhs(5,i,j,k1) = rhs(5,i,j,k1)/lhsm(3,i,k1)
          end do


c---------------------------------------------------------------------
c                         BACKSUBSTITUTION 
c---------------------------------------------------------------------

          k  = grid_points(3)-2
          k1 = grid_points(3)-1
          do   i = 1, nx2
             do   m = 1, 3
                rhs(m,i,j,k) = rhs(m,i,j,k) -
     >                             lhs(4,i,k)*rhs(m,i,j,k1)
             end do

             rhs(4,i,j,k) = rhs(4,i,j,k) -
     >                             lhsp(4,i,k)*rhs(4,i,j,k1)
             rhs(5,i,j,k) = rhs(5,i,j,k) -
     >                             lhsm(4,i,k)*rhs(5,i,j,k1)
          end do

c---------------------------------------------------------------------
c      Whether or not this is the last processor, we always have
c      to complete the back-substitution 
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c      The first three factors
c---------------------------------------------------------------------
          do   k = grid_points(3)-3, 0, -1
             k1 = k  + 1
             k2 = k  + 2
             do   i = 1, nx2
                do   m = 1, 3
                   rhs(m,i,j,k) = rhs(m,i,j,k) - 
     >                          lhs(4,i,k)*rhs(m,i,j,k1) -
     >                          lhs(5,i,k)*rhs(m,i,j,k2)
                end do

c---------------------------------------------------------------------
c      And the remaining two
c---------------------------------------------------------------------
                rhs(4,i,j,k) = rhs(4,i,j,k) - 
     >                          lhsp(4,i,k)*rhs(4,i,j,k1) -
     >                          lhsp(5,i,k)*rhs(4,i,j,k2)
                rhs(5,i,j,k) = rhs(5,i,j,k) - 
     >                          lhsm(4,i,k)*rhs(5,i,j,k1) -
     >                          lhsm(5,i,k)*rhs(5,i,j,k2)
             end do
          end do

       end do
       if (timeron) call timer_stop(t_zsolve)

       call tzetar

       return
       end



