
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine jacu(k)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c   compute the upper triangular part of the jacobian matrix
c---------------------------------------------------------------------


      implicit none

      include 'applu.incl'

c---------------------------------------------------------------------
c  input parameters
c---------------------------------------------------------------------
      integer k

c---------------------------------------------------------------------
c  local variables
c---------------------------------------------------------------------
      integer i, j
      double precision  r43
      double precision  c1345
      double precision  c34
      double precision  tmp1, tmp2, tmp3



      r43 = ( 4.0d+00 / 3.0d+00 )
      c1345 = c1 * c3 * c4 * c5
      c34 = c3 * c4

!$omp do schedule(static)
         do j = jend, jst, -1
            do i = iend, ist, -1

c---------------------------------------------------------------------
c   form the block daigonal
c---------------------------------------------------------------------
               tmp1 = rho_i(i,j,k)
               tmp2 = tmp1 * tmp1
               tmp3 = tmp1 * tmp2

               du(1,1,i,j) =  1.0d+00
     >                       + dt * 2.0d+00 * (   tx1 * dx1
     >                                          + ty1 * dy1
     >                                          + tz1 * dz1 )
               du(1,2,i,j) =  0.0d+00
               du(1,3,i,j) =  0.0d+00
               du(1,4,i,j) =  0.0d+00
               du(1,5,i,j) =  0.0d+00

               du(2,1,i,j) =  dt * 2.0d+00
     >           * ( - tx1 * r43 - ty1 - tz1 )
     >           * ( c34 * tmp2 * u(2,i,j,k) )
               du(2,2,i,j) =  1.0d+00
     >          + dt * 2.0d+00 * c34 * tmp1 
     >          * (  tx1 * r43 + ty1 + tz1 )
     >          + dt * 2.0d+00 * (   tx1 * dx2
     >                             + ty1 * dy2
     >                             + tz1 * dz2  )
               du(2,3,i,j) = 0.0d+00
               du(2,4,i,j) = 0.0d+00
               du(2,5,i,j) = 0.0d+00

               du(3,1,i,j) = dt * 2.0d+00
     >           * ( - tx1 - ty1 * r43 - tz1 )
     >           * ( c34 * tmp2 * u(3,i,j,k) )
               du(3,2,i,j) = 0.0d+00
               du(3,3,i,j) = 1.0d+00
     >         + dt * 2.0d+00 * c34 * tmp1
     >              * (  tx1 + ty1 * r43 + tz1 )
     >         + dt * 2.0d+00 * (  tx1 * dx3
     >                           + ty1 * dy3
     >                           + tz1 * dz3 )
               du(3,4,i,j) = 0.0d+00
               du(3,5,i,j) = 0.0d+00

               du(4,1,i,j) = dt * 2.0d+00
     >           * ( - tx1 - ty1 - tz1 * r43 )
     >           * ( c34 * tmp2 * u(4,i,j,k) )
               du(4,2,i,j) = 0.0d+00
               du(4,3,i,j) = 0.0d+00
               du(4,4,i,j) = 1.0d+00
     >         + dt * 2.0d+00 * c34 * tmp1
     >              * (  tx1 + ty1 + tz1 * r43 )
     >         + dt * 2.0d+00 * (  tx1 * dx4
     >                           + ty1 * dy4
     >                           + tz1 * dz4 )
               du(4,5,i,j) = 0.0d+00

               du(5,1,i,j) = -dt * 2.0d+00
     >  * ( ( ( tx1 * ( r43*c34 - c1345 )
     >     + ty1 * ( c34 - c1345 )
     >     + tz1 * ( c34 - c1345 ) ) * ( u(2,i,j,k) ** 2 )
     >   + ( tx1 * ( c34 - c1345 )
     >     + ty1 * ( r43*c34 - c1345 )
     >     + tz1 * ( c34 - c1345 ) ) * ( u(3,i,j,k) ** 2 )
     >   + ( tx1 * ( c34 - c1345 )
     >     + ty1 * ( c34 - c1345 )
     >     + tz1 * ( r43*c34 - c1345 ) ) * ( u(4,i,j,k) ** 2 )
     >      ) * tmp3
     >   + ( tx1 + ty1 + tz1 ) * c1345 * tmp2 * u(5,i,j,k) )

               du(5,2,i,j) = dt * 2.0d+00
     > * ( tx1 * ( r43*c34 - c1345 )
     >   + ty1 * (     c34 - c1345 )
     >   + tz1 * (     c34 - c1345 ) ) * tmp2 * u(2,i,j,k)
               du(5,3,i,j) = dt * 2.0d+00
     > * ( tx1 * ( c34 - c1345 )
     >   + ty1 * ( r43*c34 -c1345 )
     >   + tz1 * ( c34 - c1345 ) ) * tmp2 * u(3,i,j,k)
               du(5,4,i,j) = dt * 2.0d+00
     > * ( tx1 * ( c34 - c1345 )
     >   + ty1 * ( c34 - c1345 )
     >   + tz1 * ( r43*c34 - c1345 ) ) * tmp2 * u(4,i,j,k)
               du(5,5,i,j) = 1.0d+00
     >   + dt * 2.0d+00 * ( tx1 + ty1 + tz1 ) * c1345 * tmp1
     >   + dt * 2.0d+00 * (  tx1 * dx5
     >                    +  ty1 * dy5
     >                    +  tz1 * dz5 )

c---------------------------------------------------------------------
c   form the first block sub-diagonal
c---------------------------------------------------------------------
               tmp1 = rho_i(i+1,j,k)
               tmp2 = tmp1 * tmp1
               tmp3 = tmp1 * tmp2

               au(1,1,i,j) = - dt * tx1 * dx1
               au(1,2,i,j) =   dt * tx2
               au(1,3,i,j) =   0.0d+00
               au(1,4,i,j) =   0.0d+00
               au(1,5,i,j) =   0.0d+00

               au(2,1,i,j) =  dt * tx2
     >          * ( - ( u(2,i+1,j,k) * tmp1 ) ** 2
     >     + c2 * qs(i+1,j,k) * tmp1 )
     >          - dt * tx1 * ( - r43 * c34 * tmp2 * u(2,i+1,j,k) )
               au(2,2,i,j) =  dt * tx2
     >          * ( ( 2.0d+00 - c2 ) * ( u(2,i+1,j,k) * tmp1 ) )
     >          - dt * tx1 * ( r43 * c34 * tmp1 )
     >          - dt * tx1 * dx2
               au(2,3,i,j) =  dt * tx2
     >              * ( - c2 * ( u(3,i+1,j,k) * tmp1 ) )
               au(2,4,i,j) =  dt * tx2
     >              * ( - c2 * ( u(4,i+1,j,k) * tmp1 ) )
               au(2,5,i,j) =  dt * tx2 * c2 

               au(3,1,i,j) =  dt * tx2
     >              * ( - ( u(2,i+1,j,k) * u(3,i+1,j,k) ) * tmp2 )
     >         - dt * tx1 * ( - c34 * tmp2 * u(3,i+1,j,k) )
               au(3,2,i,j) =  dt * tx2 * ( u(3,i+1,j,k) * tmp1 )
               au(3,3,i,j) =  dt * tx2 * ( u(2,i+1,j,k) * tmp1 )
     >          - dt * tx1 * ( c34 * tmp1 )
     >          - dt * tx1 * dx3
               au(3,4,i,j) = 0.0d+00
               au(3,5,i,j) = 0.0d+00

               au(4,1,i,j) = dt * tx2
     >          * ( - ( u(2,i+1,j,k)*u(4,i+1,j,k) ) * tmp2 )
     >          - dt * tx1 * ( - c34 * tmp2 * u(4,i+1,j,k) )
               au(4,2,i,j) = dt * tx2 * ( u(4,i+1,j,k) * tmp1 )
               au(4,3,i,j) = 0.0d+00
               au(4,4,i,j) = dt * tx2 * ( u(2,i+1,j,k) * tmp1 )
     >          - dt * tx1 * ( c34 * tmp1 )
     >          - dt * tx1 * dx4
               au(4,5,i,j) = 0.0d+00

               au(5,1,i,j) = dt * tx2
     >          * ( ( c2 * 2.0d0 * qs(i+1,j,k)
     >              - c1 * u(5,i+1,j,k) )
     >          * ( u(2,i+1,j,k) * tmp2 ) )
     >          - dt * tx1
     >          * ( - ( r43*c34 - c1345 ) * tmp3 * ( u(2,i+1,j,k)**2 )
     >              - (     c34 - c1345 ) * tmp3 * ( u(3,i+1,j,k)**2 )
     >              - (     c34 - c1345 ) * tmp3 * ( u(4,i+1,j,k)**2 )
     >              - c1345 * tmp2 * u(5,i+1,j,k) )
               au(5,2,i,j) = dt * tx2
     >          * ( c1 * ( u(5,i+1,j,k) * tmp1 )
     >             - c2
     >             * (  u(2,i+1,j,k)*u(2,i+1,j,k) * tmp2
     >                  + qs(i+1,j,k) * tmp1 ) )
     >           - dt * tx1
     >           * ( r43*c34 - c1345 ) * tmp2 * u(2,i+1,j,k)
               au(5,3,i,j) = dt * tx2
     >           * ( - c2 * ( u(3,i+1,j,k)*u(2,i+1,j,k) ) * tmp2 )
     >           - dt * tx1
     >           * (  c34 - c1345 ) * tmp2 * u(3,i+1,j,k)
               au(5,4,i,j) = dt * tx2
     >           * ( - c2 * ( u(4,i+1,j,k)*u(2,i+1,j,k) ) * tmp2 )
     >           - dt * tx1
     >           * (  c34 - c1345 ) * tmp2 * u(4,i+1,j,k)
               au(5,5,i,j) = dt * tx2
     >           * ( c1 * ( u(2,i+1,j,k) * tmp1 ) )
     >           - dt * tx1 * c1345 * tmp1
     >           - dt * tx1 * dx5

c---------------------------------------------------------------------
c   form the second block sub-diagonal
c---------------------------------------------------------------------
               tmp1 = rho_i(i,j+1,k)
               tmp2 = tmp1 * tmp1
               tmp3 = tmp1 * tmp2

               bu(1,1,i,j) = - dt * ty1 * dy1
               bu(1,2,i,j) =   0.0d+00
               bu(1,3,i,j) =  dt * ty2
               bu(1,4,i,j) =   0.0d+00
               bu(1,5,i,j) =   0.0d+00

               bu(2,1,i,j) =  dt * ty2
     >           * ( - ( u(2,i,j+1,k)*u(3,i,j+1,k) ) * tmp2 )
     >           - dt * ty1 * ( - c34 * tmp2 * u(2,i,j+1,k) )
               bu(2,2,i,j) =  dt * ty2 * ( u(3,i,j+1,k) * tmp1 )
     >          - dt * ty1 * ( c34 * tmp1 )
     >          - dt * ty1 * dy2
               bu(2,3,i,j) =  dt * ty2 * ( u(2,i,j+1,k) * tmp1 )
               bu(2,4,i,j) = 0.0d+00
               bu(2,5,i,j) = 0.0d+00

               bu(3,1,i,j) =  dt * ty2
     >           * ( - ( u(3,i,j+1,k) * tmp1 ) ** 2
     >      + c2 * ( qs(i,j+1,k) * tmp1 ) )
     >       - dt * ty1 * ( - r43 * c34 * tmp2 * u(3,i,j+1,k) )
               bu(3,2,i,j) =  dt * ty2
     >                   * ( - c2 * ( u(2,i,j+1,k) * tmp1 ) )
               bu(3,3,i,j) =  dt * ty2 * ( ( 2.0d+00 - c2 )
     >                   * ( u(3,i,j+1,k) * tmp1 ) )
     >       - dt * ty1 * ( r43 * c34 * tmp1 )
     >       - dt * ty1 * dy3
               bu(3,4,i,j) =  dt * ty2
     >                   * ( - c2 * ( u(4,i,j+1,k) * tmp1 ) )
               bu(3,5,i,j) =  dt * ty2 * c2

               bu(4,1,i,j) =  dt * ty2
     >              * ( - ( u(3,i,j+1,k)*u(4,i,j+1,k) ) * tmp2 )
     >       - dt * ty1 * ( - c34 * tmp2 * u(4,i,j+1,k) )
               bu(4,2,i,j) = 0.0d+00
               bu(4,3,i,j) =  dt * ty2 * ( u(4,i,j+1,k) * tmp1 )
               bu(4,4,i,j) =  dt * ty2 * ( u(3,i,j+1,k) * tmp1 )
     >                        - dt * ty1 * ( c34 * tmp1 )
     >                        - dt * ty1 * dy4
               bu(4,5,i,j) = 0.0d+00

               bu(5,1,i,j) =  dt * ty2
     >          * ( ( c2 * 2.0d0 * qs(i,j+1,k)
     >               - c1 * u(5,i,j+1,k) )
     >          * ( u(3,i,j+1,k) * tmp2 ) )
     >          - dt * ty1
     >          * ( - (     c34 - c1345 )*tmp3*(u(2,i,j+1,k)**2)
     >              - ( r43*c34 - c1345 )*tmp3*(u(3,i,j+1,k)**2)
     >              - (     c34 - c1345 )*tmp3*(u(4,i,j+1,k)**2)
     >              - c1345*tmp2*u(5,i,j+1,k) )
               bu(5,2,i,j) =  dt * ty2
     >          * ( - c2 * ( u(2,i,j+1,k)*u(3,i,j+1,k) ) * tmp2 )
     >          - dt * ty1
     >          * ( c34 - c1345 ) * tmp2 * u(2,i,j+1,k)
               bu(5,3,i,j) =  dt * ty2
     >          * ( c1 * ( u(5,i,j+1,k) * tmp1 )
     >          - c2 
     >          * ( qs(i,j+1,k) * tmp1
     >               + u(3,i,j+1,k)*u(3,i,j+1,k) * tmp2 ) )
     >          - dt * ty1
     >          * ( r43*c34 - c1345 ) * tmp2 * u(3,i,j+1,k)
               bu(5,4,i,j) =  dt * ty2
     >          * ( - c2 * ( u(3,i,j+1,k)*u(4,i,j+1,k) ) * tmp2 )
     >          - dt * ty1 * ( c34 - c1345 ) * tmp2 * u(4,i,j+1,k)
               bu(5,5,i,j) =  dt * ty2
     >          * ( c1 * ( u(3,i,j+1,k) * tmp1 ) )
     >          - dt * ty1 * c1345 * tmp1
     >          - dt * ty1 * dy5

c---------------------------------------------------------------------
c   form the third block sub-diagonal
c---------------------------------------------------------------------
               tmp1 = rho_i(i,j,k+1)
               tmp2 = tmp1 * tmp1
               tmp3 = tmp1 * tmp2

               cu(1,1,i,j) = - dt * tz1 * dz1
               cu(1,2,i,j) =   0.0d+00
               cu(1,3,i,j) =   0.0d+00
               cu(1,4,i,j) = dt * tz2
               cu(1,5,i,j) =   0.0d+00

               cu(2,1,i,j) = dt * tz2
     >           * ( - ( u(2,i,j,k+1)*u(4,i,j,k+1) ) * tmp2 )
     >           - dt * tz1 * ( - c34 * tmp2 * u(2,i,j,k+1) )
               cu(2,2,i,j) = dt * tz2 * ( u(4,i,j,k+1) * tmp1 )
     >           - dt * tz1 * c34 * tmp1
     >           - dt * tz1 * dz2 
               cu(2,3,i,j) = 0.0d+00
               cu(2,4,i,j) = dt * tz2 * ( u(2,i,j,k+1) * tmp1 )
               cu(2,5,i,j) = 0.0d+00

               cu(3,1,i,j) = dt * tz2
     >           * ( - ( u(3,i,j,k+1)*u(4,i,j,k+1) ) * tmp2 )
     >           - dt * tz1 * ( - c34 * tmp2 * u(3,i,j,k+1) )
               cu(3,2,i,j) = 0.0d+00
               cu(3,3,i,j) = dt * tz2 * ( u(4,i,j,k+1) * tmp1 )
     >           - dt * tz1 * ( c34 * tmp1 )
     >           - dt * tz1 * dz3
               cu(3,4,i,j) = dt * tz2 * ( u(3,i,j,k+1) * tmp1 )
               cu(3,5,i,j) = 0.0d+00

               cu(4,1,i,j) = dt * tz2
     >        * ( - ( u(4,i,j,k+1) * tmp1 ) ** 2
     >            + c2 * ( qs(i,j,k+1) * tmp1 ) )
     >        - dt * tz1 * ( - r43 * c34 * tmp2 * u(4,i,j,k+1) )
               cu(4,2,i,j) = dt * tz2
     >             * ( - c2 * ( u(2,i,j,k+1) * tmp1 ) )
               cu(4,3,i,j) = dt * tz2
     >             * ( - c2 * ( u(3,i,j,k+1) * tmp1 ) )
               cu(4,4,i,j) = dt * tz2 * ( 2.0d+00 - c2 )
     >             * ( u(4,i,j,k+1) * tmp1 )
     >             - dt * tz1 * ( r43 * c34 * tmp1 )
     >             - dt * tz1 * dz4
               cu(4,5,i,j) = dt * tz2 * c2

               cu(5,1,i,j) = dt * tz2
     >     * ( ( c2 * 2.0d0 * qs(i,j,k+1)
     >       - c1 * u(5,i,j,k+1) )
     >            * ( u(4,i,j,k+1) * tmp2 ) )
     >       - dt * tz1
     >       * ( - ( c34 - c1345 ) * tmp3 * (u(2,i,j,k+1)**2)
     >           - ( c34 - c1345 ) * tmp3 * (u(3,i,j,k+1)**2)
     >           - ( r43*c34 - c1345 )* tmp3 * (u(4,i,j,k+1)**2)
     >          - c1345 * tmp2 * u(5,i,j,k+1) )
               cu(5,2,i,j) = dt * tz2
     >       * ( - c2 * ( u(2,i,j,k+1)*u(4,i,j,k+1) ) * tmp2 )
     >       - dt * tz1 * ( c34 - c1345 ) * tmp2 * u(2,i,j,k+1)
               cu(5,3,i,j) = dt * tz2
     >       * ( - c2 * ( u(3,i,j,k+1)*u(4,i,j,k+1) ) * tmp2 )
     >       - dt * tz1 * ( c34 - c1345 ) * tmp2 * u(3,i,j,k+1)
               cu(5,4,i,j) = dt * tz2
     >       * ( c1 * ( u(5,i,j,k+1) * tmp1 )
     >       - c2
     >       * ( qs(i,j,k+1) * tmp1
     >            + u(4,i,j,k+1)*u(4,i,j,k+1) * tmp2 ) )
     >       - dt * tz1 * ( r43*c34 - c1345 ) * tmp2 * u(4,i,j,k+1)
               cu(5,5,i,j) = dt * tz2
     >       * ( c1 * ( u(4,i,j,k+1) * tmp1 ) )
     >       - dt * tz1 * c1345 * tmp1
     >       - dt * tz1 * dz5

            end do
         end do
!$omp end do nowait

      return
      end
