c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine ssor(niter)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c   to perform pseudo-time stepping SSOR iterations
c   for five nonlinear pde's.
c---------------------------------------------------------------------

      implicit none
      integer  niter

      include 'mpinpb.h'
      include 'applu.incl'

c---------------------------------------------------------------------
c  local variables
c---------------------------------------------------------------------
      integer i, j, k, m
      integer istep
      double precision  tmp
      double precision  delunm(5), tv(5,isiz1,isiz2)

      external timer_read
      double precision wtime, timer_read

      integer IERROR

 
      ROOT = 0
 
c---------------------------------------------------------------------
c   begin pseudo-time stepping iterations
c---------------------------------------------------------------------
      tmp = 1.0d+00 / ( omega * ( 2.0d+00 - omega ) ) 

c---------------------------------------------------------------------
c   initialize a,b,c,d to zero (guarantees that page tables have been
c   formed, if applicable on given architecture, before timestepping).
c---------------------------------------------------------------------
      do m=1,isiz2
         do k=1,isiz1
            do j=1,5
               do i=1,5
                  a(i,j,k,m) = 0.d0
                  b(i,j,k,m) = 0.d0
                  c(i,j,k,m) = 0.d0
                  d(i,j,k,m) = 0.d0
               enddo
            enddo
         enddo
      enddo

c---------------------------------------------------------------------
c   compute the steady-state residuals
c---------------------------------------------------------------------
      call rhs
 
c---------------------------------------------------------------------
c   compute the L2 norms of newton iteration residuals
c---------------------------------------------------------------------
      call l2norm( isiz1, isiz2, isiz3, nx0, ny0, nz0,
     >             ist, iend, jst, jend,
     >             rsd, rsdnm )
  
      do i = 1, t_last
         call timer_clear(i)
      end do

      call MPI_BARRIER( MPI_COMM_WORLD, IERROR )
 
      call timer_clear(1)
      call timer_start(1)

c---------------------------------------------------------------------
c   the timestep loop
c---------------------------------------------------------------------
      do istep = 1, niter

         if (id .eq. 0) then
            if (mod ( istep, 20) .eq. 0 .or.
     >            istep .eq. itmax .or.
     >            istep .eq. 1) then
               if (niter .gt. 1) write( *, 200) istep
 200           format(' Time step ', i4)
            endif
         endif
 
c---------------------------------------------------------------------
c   perform SSOR iteration
c---------------------------------------------------------------------
         do k = 2, nz - 1
            do j = jst, jend
               do i = ist, iend
                  do m = 1, 5
                     rsd(m,i,j,k) = dt * rsd(m,i,j,k)
                  end do
               end do
            end do
         end do
 
         DO k = 2, nz -1 
c---------------------------------------------------------------------
c   form the lower triangular part of the jacobian matrix
c---------------------------------------------------------------------
            call jacld(k)
 
c---------------------------------------------------------------------
c   perform the lower triangular solution
c---------------------------------------------------------------------
            call blts( isiz1, isiz2, isiz3,
     >                 nx, ny, nz, k,
     >                 omega,
     >                 rsd,
     >                 a, b, c, d,
     >                 ist, iend, jst, jend, 
     >                 nx0, ny0, ipt, jpt)
          END DO
 
          DO k = nz - 1, 2, -1
c---------------------------------------------------------------------
c   form the strictly upper triangular part of the jacobian matrix
c---------------------------------------------------------------------
            call jacu(k)

c---------------------------------------------------------------------
c   perform the upper triangular solution
c---------------------------------------------------------------------
            call buts( isiz1, isiz2, isiz3,
     >                 nx, ny, nz, k,
     >                 omega,
     >                 rsd, tv,
     >                 d, a, b, c,
     >                 ist, iend, jst, jend,
     >                 nx0, ny0, ipt, jpt)
          END DO
 
c---------------------------------------------------------------------
c   update the variables
c---------------------------------------------------------------------
 
         do k = 2, nz-1
            do j = jst, jend
               do i = ist, iend
                  do m = 1, 5
                     u( m, i, j, k ) = u( m, i, j, k )
     >                    + tmp * rsd( m, i, j, k )
                  end do
               end do
            end do
         end do
 
c---------------------------------------------------------------------
c   compute the max-norms of newton iteration corrections
c---------------------------------------------------------------------
         if ( mod ( istep, inorm ) .eq. 0 ) then
            call l2norm( isiz1, isiz2, isiz3, nx0, ny0, nz0,
     >                   ist, iend, jst, jend,
     >                   rsd, delunm )
c            if ( ipr .eq. 1 .and. id .eq. 0 ) then
c                write (*,1006) ( delunm(m), m = 1, 5 )
c            else if ( ipr .eq. 2 .and. id .eq. 0 ) then
c                write (*,'(i5,f15.6)') istep,delunm(5)
c            end if
         end if
 
c---------------------------------------------------------------------
c   compute the steady-state residuals
c---------------------------------------------------------------------
         call rhs
 
c---------------------------------------------------------------------
c   compute the max-norms of newton iteration residuals
c---------------------------------------------------------------------
         if ( ( mod ( istep, inorm ) .eq. 0 ) .or.
     >        ( istep .eq. itmax ) ) then
            call l2norm( isiz1, isiz2, isiz3, nx0, ny0, nz0,
     >                   ist, iend, jst, jend,
     >                   rsd, rsdnm )
c            if ( ipr .eq. 1.and.id.eq.0 ) then
c                write (*,1007) ( rsdnm(m), m = 1, 5 )
c            end if
         end if

c---------------------------------------------------------------------
c   check the newton-iteration residuals against the tolerance levels
c---------------------------------------------------------------------
         if ( ( rsdnm(1) .lt. tolrsd(1) ) .and.
     >        ( rsdnm(2) .lt. tolrsd(2) ) .and.
     >        ( rsdnm(3) .lt. tolrsd(3) ) .and.
     >        ( rsdnm(4) .lt. tolrsd(4) ) .and.
     >        ( rsdnm(5) .lt. tolrsd(5) ) ) then
            if (id.eq.0) then
               write (*,1004) istep
            end if
            go to 900
         end if
 
      end do
  900 continue
 
      call timer_stop(1)
      wtime = timer_read(1)
 

      call MPI_ALLREDUCE( wtime, 
     >                    maxtime, 
     >                    1, 
     >                    MPI_DOUBLE_PRECISION, 
     >                    MPI_MAX, 
     >                    MPI_COMM_WORLD,
     >                    IERROR )
 


      return
      
 1001 format (1x/5x,'pseudo-time SSOR iteration no.=',i4/)
 1004 format (1x/1x,'convergence was achieved after ',i4,
     >   ' pseudo-time steps' )
 1006 format (1x/1x,'RMS-norm of SSOR-iteration correction ',
     > 'for first pde  = ',1pe12.5/,
     > 1x,'RMS-norm of SSOR-iteration correction ',
     > 'for second pde = ',1pe12.5/,
     > 1x,'RMS-norm of SSOR-iteration correction ',
     > 'for third pde  = ',1pe12.5/,
     > 1x,'RMS-norm of SSOR-iteration correction ',
     > 'for fourth pde = ',1pe12.5/,
     > 1x,'RMS-norm of SSOR-iteration correction ',
     > 'for fifth pde  = ',1pe12.5)
 1007 format (1x/1x,'RMS-norm of steady-state residual for ',
     > 'first pde  = ',1pe12.5/,
     > 1x,'RMS-norm of steady-state residual for ',
     > 'second pde = ',1pe12.5/,
     > 1x,'RMS-norm of steady-state residual for ',
     > 'third pde  = ',1pe12.5/,
     > 1x,'RMS-norm of steady-state residual for ',
     > 'fourth pde = ',1pe12.5/,
     > 1x,'RMS-norm of steady-state residual for ',
     > 'fifth pde  = ',1pe12.5)
 
      end
