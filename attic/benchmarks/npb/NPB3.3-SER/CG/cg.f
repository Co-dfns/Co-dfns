!-------------------------------------------------------------------------!
!                                                                         !
!        N  A  S     P A R A L L E L     B E N C H M A R K S  3.3         !
!                                                                         !
!                      S E R I A L     V E R S I O N                      !
!                                                                         !
!                                   C G                                   !
!                                                                         !
!-------------------------------------------------------------------------!
!                                                                         !
!    This benchmark is a serial version of the NPB CG code.               !
!    Refer to NAS Technical Reports 95-020 for details.                   !
!                                                                         !
!    Permission to use, copy, distribute and modify this software         !
!    for any purpose with or without fee is hereby granted.  We           !
!    request, however, that all derived work reference the NAS            !
!    Parallel Benchmarks 3.3. This software is provided "as is"           !
!    without express or implied warranty.                                 !
!                                                                         !
!    Information on NPB 3.3, including the technical report, the          !
!    original specifications, source code, results and information        !
!    on how to submit new results, is available at:                       !
!                                                                         !
!           http://www.nas.nasa.gov/Software/NPB/                         !
!                                                                         !
!    Send comments or suggestions to  npb@nas.nasa.gov                    !
!                                                                         !
!          NAS Parallel Benchmarks Group                                  !
!          NASA Ames Research Center                                      !
!          Mail Stop: T27A-1                                              !
!          Moffett Field, CA   94035-1000                                 !
!                                                                         !
!          E-mail:  npb@nas.nasa.gov                                      !
!          Fax:     (650) 604-3957                                        !
!                                                                         !
!-------------------------------------------------------------------------!


c---------------------------------------------------------------------
c      NPB CG serial version      
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c
c Authors: M. Yarrow
c          C. Kuszmaul
c
c---------------------------------------------------------------------


c---------------------------------------------------------------------
c---------------------------------------------------------------------
      program cg
c---------------------------------------------------------------------
c---------------------------------------------------------------------


      implicit none

      include 'globals.h'


      common / main_int_mem /  colidx,     rowstr,
     >                         iv,         arow,     acol
      integer                  colidx(nz), rowstr(na+1),
     >                         iv(na),  arow(na), acol(naz)


      common / main_flt_mem /  aelt,     a,
     >                         x,
     >                         z,
     >                         p,
     >                         q,
     >                         r
      double precision         aelt(naz), a(nz),
     >                         x(na+2),
     >                         z(na+2),
     >                         p(na+2),
     >                         q(na+2),
     >                         r(na+2)



      integer            i, j, k, it

      double precision   zeta, randlc
      external           randlc
      double precision   rnorm
      double precision   norm_temp1,norm_temp2

      double precision   t, mflops, tmax
      character          class
      logical            verified
      double precision   zeta_verify_value, epsilon, err

      integer   fstatus
      character t_names(t_last)*8

      do i = 1, T_last
         call timer_clear( i )
      end do

      open(unit=2, file='timer.flag', status='old', iostat=fstatus)
      if (fstatus .eq. 0) then
         timeron = .true.
         t_names(t_init) = 'init'
         t_names(t_bench) = 'benchmk'
         t_names(t_conj_grad) = 'conjgd'
         close(2)
      else
         timeron = .false.
      endif

      call timer_start( T_init )

      firstrow = 1
      lastrow  = na
      firstcol = 1
      lastcol  = na


      if( na .eq. 1400 .and. 
     &    nonzer .eq. 7 .and. 
     &    niter .eq. 15 .and.
     &    shift .eq. 10.d0 ) then
         class = 'S'
         zeta_verify_value = 8.5971775078648d0
      else if( na .eq. 7000 .and. 
     &         nonzer .eq. 8 .and. 
     &         niter .eq. 15 .and.
     &         shift .eq. 12.d0 ) then
         class = 'W'
         zeta_verify_value = 10.362595087124d0
      else if( na .eq. 14000 .and. 
     &         nonzer .eq. 11 .and. 
     &         niter .eq. 15 .and.
     &         shift .eq. 20.d0 ) then
         class = 'A'
         zeta_verify_value = 17.130235054029d0
      else if( na .eq. 75000 .and. 
     &         nonzer .eq. 13 .and. 
     &         niter .eq. 75 .and.
     &         shift .eq. 60.d0 ) then
         class = 'B'
         zeta_verify_value = 22.712745482631d0
      else if( na .eq. 150000 .and. 
     &         nonzer .eq. 15 .and. 
     &         niter .eq. 75 .and.
     &         shift .eq. 110.d0 ) then
         class = 'C'
         zeta_verify_value = 28.973605592845d0
      else if( na .eq. 1500000 .and. 
     &         nonzer .eq. 21 .and. 
     &         niter .eq. 100 .and.
     &         shift .eq. 500.d0 ) then
         class = 'D'
         zeta_verify_value = 52.514532105794d0
      else if( na .eq. 9000000 .and. 
     &         nonzer .eq. 26 .and. 
     &         niter .eq. 100 .and.
     &         shift .eq. 1.5d3 ) then
         class = 'E'
         zeta_verify_value = 77.522164599383d0
      else
         class = 'U'
      endif

      write( *,1000 ) 
      write( *,1001 ) na
      write( *,1002 ) niter
      write( *,* )
 1000 format(//,' NAS Parallel Benchmarks (NPB3.3-SER)',
     >          ' - CG Benchmark', /)
 1001 format(' Size: ', i11 )
 1002 format(' Iterations: ', i5 )



      naa = na
      nzz = nz


c---------------------------------------------------------------------
c  Inialize random number generator
c---------------------------------------------------------------------
      tran    = 314159265.0D0
      amult   = 1220703125.0D0
      zeta    = randlc( tran, amult )

c---------------------------------------------------------------------
c  
c---------------------------------------------------------------------
      call makea(naa, nzz, a, colidx, rowstr, 
     >           firstrow, lastrow, firstcol, lastcol, 
     >           arow, acol, aelt, iv)



c---------------------------------------------------------------------
c  Note: as a result of the above call to makea:
c        values of j used in indexing rowstr go from 1 --> lastrow-firstrow+1
c        values of colidx which are col indexes go from firstcol --> lastcol
c        So:
c        Shift the col index vals from actual (firstcol --> lastcol ) 
c        to local, i.e., (1 --> lastcol-firstcol+1)
c---------------------------------------------------------------------
      do j=1,lastrow-firstrow+1
         do k=rowstr(j),rowstr(j+1)-1
            colidx(k) = colidx(k) - firstcol + 1
         enddo
      enddo

c---------------------------------------------------------------------
c  set starting vector to (1, 1, .... 1)
c---------------------------------------------------------------------
      do i = 1, na+1
         x(i) = 1.0D0
      enddo
      do j=1, lastcol-firstcol+1
         q(j) = 0.0d0
         z(j) = 0.0d0
         r(j) = 0.0d0
         p(j) = 0.0d0
      enddo

      zeta  = 0.0d0

c---------------------------------------------------------------------
c---->
c  Do one iteration untimed to init all code and data page tables
c---->                    (then reinit, start timing, to niter its)
c---------------------------------------------------------------------
      do it = 1, 1

c---------------------------------------------------------------------
c  The call to the conjugate gradient routine:
c---------------------------------------------------------------------
         call conj_grad ( colidx,
     >                    rowstr,
     >                    x,
     >                    z,
     >                    a,
     >                    p,
     >                    q,
     >                    r,
     >                    rnorm )

c---------------------------------------------------------------------
c  zeta = shift + 1/(x.z)
c  So, first: (x.z)
c  Also, find norm of z
c  So, first: (z.z)
c---------------------------------------------------------------------
         norm_temp1 = 0.0d0
         norm_temp2 = 0.0d0
         do j=1, lastcol-firstcol+1
            norm_temp1 = norm_temp1 + x(j)*z(j)
            norm_temp2 = norm_temp2 + z(j)*z(j)
         enddo

         norm_temp2 = 1.0d0 / sqrt( norm_temp2 )


c---------------------------------------------------------------------
c  Normalize z to obtain x
c---------------------------------------------------------------------
         do j=1, lastcol-firstcol+1      
            x(j) = norm_temp2*z(j)    
         enddo                           


      enddo                              ! end of do one iteration untimed


c---------------------------------------------------------------------
c  set starting vector to (1, 1, .... 1)
c---------------------------------------------------------------------
c
c  
c
      do i = 1, na+1
         x(i) = 1.0D0
      enddo

      zeta  = 0.0d0

      call timer_stop( T_init )

      write (*, 2000) timer_read(T_init)
 2000 format(' Initialization time = ',f15.3,' seconds')

      call timer_start( T_bench )

c---------------------------------------------------------------------
c---->
c  Main Iteration for inverse power method
c---->
c---------------------------------------------------------------------
      do it = 1, niter

c---------------------------------------------------------------------
c  The call to the conjugate gradient routine:
c---------------------------------------------------------------------
         if ( timeron ) call timer_start( T_conj_grad )
         call conj_grad ( colidx,
     >                    rowstr,
     >                    x,
     >                    z,
     >                    a,
     >                    p,
     >                    q,
     >                    r,
     >                    rnorm )
         if ( timeron ) call timer_stop( T_conj_grad )


c---------------------------------------------------------------------
c  zeta = shift + 1/(x.z)
c  So, first: (x.z)
c  Also, find norm of z
c  So, first: (z.z)
c---------------------------------------------------------------------
         norm_temp1 = 0.0d0
         norm_temp2 = 0.0d0
         do j=1, lastcol-firstcol+1
            norm_temp1 = norm_temp1 + x(j)*z(j)
            norm_temp2 = norm_temp2 + z(j)*z(j)
         enddo


         norm_temp2 = 1.0d0 / sqrt( norm_temp2 )


         zeta = shift + 1.0d0 / norm_temp1
         if( it .eq. 1 ) write( *,9000 )
         write( *,9001 ) it, rnorm, zeta

 9000    format( /,'   iteration           ||r||                 zeta' )
 9001    format( 4x, i5, 7x, e20.14, f20.13 )

c---------------------------------------------------------------------
c  Normalize z to obtain x
c---------------------------------------------------------------------
         do j=1, lastcol-firstcol+1      
            x(j) = norm_temp2*z(j)    
         enddo                           


      enddo                              ! end of main iter inv pow meth

      call timer_stop( T_bench )

c---------------------------------------------------------------------
c  End of timed section
c---------------------------------------------------------------------

      t = timer_read( T_bench )


      write(*,100)
 100  format(' Benchmark completed ')

      epsilon = 1.d-10
      if (class .ne. 'U') then

c         err = abs( zeta - zeta_verify_value)
         err = abs( zeta - zeta_verify_value )/zeta_verify_value
         if( err .le. epsilon ) then
            verified = .TRUE.
            write(*, 200)
            write(*, 201) zeta
            write(*, 202) err
 200        format(' VERIFICATION SUCCESSFUL ')
 201        format(' Zeta is    ', E20.13)
 202        format(' Error is   ', E20.13)
         else
            verified = .FALSE.
            write(*, 300) 
            write(*, 301) zeta
            write(*, 302) zeta_verify_value
 300        format(' VERIFICATION FAILED')
 301        format(' Zeta                ', E20.13)
 302        format(' The correct zeta is ', E20.13)
         endif
      else
         verified = .FALSE.
         write (*, 400)
         write (*, 401)
         write (*, 201) zeta
 400     format(' Problem size unknown')
 401     format(' NO VERIFICATION PERFORMED')
      endif


      if( t .ne. 0. ) then
         mflops = float( 2*niter*na )
     &               * ( 3.+float( nonzer*(nonzer+1) )
     &                 + 25.*(5.+float( nonzer*(nonzer+1) ))
     &                 + 3. ) / t / 1000000.0
      else
         mflops = 0.0
      endif


         call print_results('CG', class, na, 0, 0,
     >                      niter, t,
     >                      mflops, '          floating point', 
     >                      verified, npbversion, compiletime,
     >                      cs1, cs2, cs3, cs4, cs5, cs6, cs7)



 600  format( i4, 2e19.12)


c---------------------------------------------------------------------
c      More timers
c---------------------------------------------------------------------
      if (.not.timeron) goto 999

      tmax = timer_read(T_bench)
      if (tmax .eq. 0.0) tmax = 1.0

      write(*,800)
 800  format('  SECTION   Time (secs)')
      do i=1, t_last
         t = timer_read(i)
         if (i.eq.t_init) then
            write(*,810) t_names(i), t
         else
            write(*,810) t_names(i), t, t*100./tmax
            if (i.eq.t_conj_grad) then
               t = tmax - t
               write(*,820) 'rest', t, t*100./tmax
            endif
         endif
 810     format(2x,a8,':',f9.3:'  (',f6.2,'%)')
 820     format('    --> ',a8,':',f9.3,'  (',f6.2,'%)')
      end do

 999  continue


      end                              ! end main



c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine conj_grad ( colidx,
     >                       rowstr,
     >                       x,
     >                       z,
     >                       a,
     >                       p,
     >                       q,
     >                       r,
     >                       rnorm )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c  Floaging point arrays here are named as in NPB1 spec discussion of 
c  CG algorithm
c---------------------------------------------------------------------
 
      implicit none


      include 'globals.h'


      double precision   x(*),
     >                   z(*),
     >                   a(nzz)
      integer            colidx(nzz), rowstr(naa+1)

      double precision   p(*),
     >                   q(*),
     >                   r(*)


      integer   j, k
      integer   cgit, cgitmax

      double precision   d, sum, rho, rho0, alpha, beta, rnorm

      data      cgitmax / 25 /


      rho = 0.0d0

c---------------------------------------------------------------------
c  Initialize the CG algorithm:
c---------------------------------------------------------------------
      do j=1,naa+1
         q(j) = 0.0d0
         z(j) = 0.0d0
         r(j) = x(j)
         p(j) = r(j)
      enddo


c---------------------------------------------------------------------
c  rho = r.r
c  Now, obtain the norm of r: First, sum squares of r elements locally...
c---------------------------------------------------------------------
      do j=1, lastcol-firstcol+1
         rho = rho + r(j)*r(j)
      enddo

c---------------------------------------------------------------------
c---->
c  The conj grad iteration loop
c---->
c---------------------------------------------------------------------
      do cgit = 1, cgitmax

c---------------------------------------------------------------------
c  q = A.p
c  The partition submatrix-vector multiply: use workspace w
c---------------------------------------------------------------------
C
C  NOTE: this version of the multiply is actually (slightly: maybe %5) 
C        faster on the sp2 on 16 nodes than is the unrolled-by-2 version 
C        below.   On the Cray t3d, the reverse is true, i.e., the 
C        unrolled-by-two version is some 10% faster.  
C        The unrolled-by-8 version below is significantly faster
C        on the Cray t3d - overall speed of code is 1.5 times faster.
C
         do j=1,lastrow-firstrow+1
            sum = 0.d0
            do k=rowstr(j),rowstr(j+1)-1
               sum = sum + a(k)*p(colidx(k))
            enddo
            q(j) = sum
         enddo

CC          do j=1,lastrow-firstrow+1
CC             i = rowstr(j) 
CC             iresidue = mod( rowstr(j+1)-i, 2 )
CC             sum1 = 0.d0
CC             sum2 = 0.d0
CC             if( iresidue .eq. 1 )
CC      &          sum1 = sum1 + a(i)*p(colidx(i))
CC             do k=i+iresidue, rowstr(j+1)-2, 2
CC                sum1 = sum1 + a(k)  *p(colidx(k))
CC                sum2 = sum2 + a(k+1)*p(colidx(k+1))
CC             enddo
CC             q(j) = sum1 + sum2
CC          enddo

CC          do j=1,lastrow-firstrow+1
CC             i = rowstr(j) 
CC             iresidue = mod( rowstr(j+1)-i, 8 )
CC             sum = 0.d0
CC             do k=i,i+iresidue-1
CC                sum = sum +  a(k)*p(colidx(k))
CC             enddo
CC             do k=i+iresidue, rowstr(j+1)-8, 8
CC                sum = sum + a(k  )*p(colidx(k  ))
CC      &                   + a(k+1)*p(colidx(k+1))
CC      &                   + a(k+2)*p(colidx(k+2))
CC      &                   + a(k+3)*p(colidx(k+3))
CC      &                   + a(k+4)*p(colidx(k+4))
CC      &                   + a(k+5)*p(colidx(k+5))
CC      &                   + a(k+6)*p(colidx(k+6))
CC      &                   + a(k+7)*p(colidx(k+7))
CC             enddo
CC             q(j) = sum
CC          enddo
            


c---------------------------------------------------------------------
c  Obtain p.q
c---------------------------------------------------------------------
         d = 0.0d0
         do j=1, lastcol-firstcol+1
            d = d + p(j)*q(j)
         enddo


c---------------------------------------------------------------------
c  Obtain alpha = rho / (p.q)
c---------------------------------------------------------------------
         alpha = rho / d

c---------------------------------------------------------------------
c  Save a temporary of rho
c---------------------------------------------------------------------
         rho0 = rho

c---------------------------------------------------------------------
c  Obtain z = z + alpha*p
c  and    r = r - alpha*q
c---------------------------------------------------------------------
         rho = 0.0d0
         do j=1, lastcol-firstcol+1
            z(j) = z(j) + alpha*p(j)
            r(j) = r(j) - alpha*q(j)
         enddo
            
c---------------------------------------------------------------------
c  rho = r.r
c  Now, obtain the norm of r: First, sum squares of r elements locally...
c---------------------------------------------------------------------
         do j=1, lastcol-firstcol+1
            rho = rho + r(j)*r(j)
         enddo

c---------------------------------------------------------------------
c  Obtain beta:
c---------------------------------------------------------------------
         beta = rho / rho0

c---------------------------------------------------------------------
c  p = r + beta*p
c---------------------------------------------------------------------
         do j=1, lastcol-firstcol+1
            p(j) = r(j) + beta*p(j)
         enddo


      enddo                             ! end of do cgit=1,cgitmax


c---------------------------------------------------------------------
c  Compute residual norm explicitly:  ||r|| = ||x - A.z||
c  First, form A.z
c  The partition submatrix-vector multiply
c---------------------------------------------------------------------
      sum = 0.0d0
      do j=1,lastrow-firstrow+1
         d = 0.d0
         do k=rowstr(j),rowstr(j+1)-1
            d = d + a(k)*z(colidx(k))
         enddo
         r(j) = d
      enddo


c---------------------------------------------------------------------
c  At this point, r contains A.z
c---------------------------------------------------------------------
      do j=1, lastcol-firstcol+1
         d   = x(j) - r(j)         
         sum = sum + d*d
      enddo

      rnorm = sqrt( sum )



      return
      end                               ! end of routine conj_grad



c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine makea( n, nz, a, colidx, rowstr, 
     >                  firstrow, lastrow, firstcol, lastcol,
     >                  arow, acol, aelt, iv )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit            none
      include             'npbparams.h'

      integer             n, nz
      integer             firstrow, lastrow, firstcol, lastcol
      integer             colidx(nz), rowstr(n+1)
      integer             iv(n), arow(n), acol(nonzer+1,n)
      double precision    aelt(nonzer+1,n)
      double precision    a(nz)

c---------------------------------------------------------------------
c       generate the test problem for benchmark 6
c       makea generates a sparse matrix with a
c       prescribed sparsity distribution
c
c       parameter    type        usage
c
c       input
c
c       n            i           number of cols/rows of matrix
c       nz           i           nonzeros as declared array size
c       rcond        r*8         condition number
c       shift        r*8         main diagonal shift
c
c       output
c
c       a            r*8         array for nonzeros
c       colidx       i           col indices
c       rowstr       i           row pointers
c
c       workspace
c
c       iv, arow, acol i
c       aelt           r*8
c---------------------------------------------------------------------

      integer          i, iouter, ivelt, nzv, nn1
      integer          ivc(nonzer+1)
      double precision vc(nonzer+1)

c---------------------------------------------------------------------
c      nonzer is approximately  (int(sqrt(nnza /n)));
c---------------------------------------------------------------------

      external          sparse, sprnvc, vecset

c---------------------------------------------------------------------
c    nn1 is the smallest power of two not less than n
c---------------------------------------------------------------------

      nn1 = 1
 50   continue
        nn1 = 2 * nn1
        if (nn1 .lt. n) goto 50

c---------------------------------------------------------------------
c  Generate nonzero positions and save for the use in sparse.
c---------------------------------------------------------------------

      do iouter = 1, n
         nzv = nonzer
         call sprnvc( n, nzv, nn1, vc, ivc )
         call vecset( n, vc, ivc, nzv, iouter, .5D0 )
         arow(iouter) = nzv
         do ivelt = 1, nzv
            acol(ivelt, iouter) = ivc(ivelt)
            aelt(ivelt, iouter) = vc(ivelt)
         enddo
      enddo

c---------------------------------------------------------------------
c       ... make the sparse matrix from list of elements with duplicates
c           (iv is used as  workspace)
c---------------------------------------------------------------------
      call sparse( a, colidx, rowstr, n, nz, nonzer, arow, acol, 
     >             aelt, firstrow, lastrow,
     >             iv, rcond, shift )
      return

      end
c-------end   of makea------------------------------

c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine sparse( a, colidx, rowstr, n, nz, nonzer, arow, acol, 
     >                   aelt, firstrow, lastrow,
     >                   nzloc, rcond, shift )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit           none
      integer            colidx(*), rowstr(*)
      integer            firstrow, lastrow
      integer            n, nz, nonzer, arow(*), acol(nonzer+1,*)
      double precision   a(*), aelt(nonzer+1,*), rcond, shift

c---------------------------------------------------------------------
c       rows range from firstrow to lastrow
c       the rowstr pointers are defined for nrows = lastrow-firstrow+1 values
c---------------------------------------------------------------------
      integer            nzloc(n), nrows

c---------------------------------------------------
c       generate a sparse matrix from a list of
c       [col, row, element] tri
c---------------------------------------------------

      integer            i, j, j1, j2, nza, k, kk, nzrow, jcol
      double precision   xi, size, scale, ratio, va

c---------------------------------------------------------------------
c    how many rows of result
c---------------------------------------------------------------------
      nrows = lastrow - firstrow + 1

c---------------------------------------------------------------------
c     ...count the number of triples in each row
c---------------------------------------------------------------------
      do j = 1, nrows+1
         rowstr(j) = 0
      enddo

      do i = 1, n
         do nza = 1, arow(i)
            j = acol(nza, i) + 1
            rowstr(j) = rowstr(j) + arow(i)
         end do
      end do

      rowstr(1) = 1
      do j = 2, nrows+1
         rowstr(j) = rowstr(j) + rowstr(j-1)
      enddo
      nza = rowstr(nrows+1) - 1

c---------------------------------------------------------------------
c     ... rowstr(j) now is the location of the first nonzero
c           of row j of a
c---------------------------------------------------------------------

      if (nza .gt. nz) then
         write(*,*) 'Space for matrix elements exceeded in sparse'
         write(*,*) 'nza, nzmax = ',nza, nz
         stop
      endif


c---------------------------------------------------------------------
c     ... preload data pages
c---------------------------------------------------------------------
      do j = 1, nrows
         do k = rowstr(j), rowstr(j+1)-1
             a(k) = 0.d0
             colidx(k) = 0
         enddo
         nzloc(j) = 0
      enddo

c---------------------------------------------------------------------
c     ... generate actual values by summing duplicates
c---------------------------------------------------------------------

      size = 1.0D0
      ratio = rcond ** (1.0D0 / dfloat(n))

      do i = 1, n
         do nza = 1, arow(i)
            j = acol(nza, i)

            scale = size * aelt(nza, i)
            do nzrow = 1, arow(i)
               jcol = acol(nzrow, i)
               va = aelt(nzrow, i) * scale

c---------------------------------------------------------------------
c       ... add the identity * rcond to the generated matrix to bound
c           the smallest eigenvalue from below by rcond
c---------------------------------------------------------------------
               if (jcol .eq. j .and. j .eq. i) then
                  va = va + rcond - shift
               endif

               do k = rowstr(j), rowstr(j+1)-1
                  if (colidx(k) .gt. jcol) then
c---------------------------------------------------------------------
c       ... insert colidx here orderly
c---------------------------------------------------------------------
                     do kk = rowstr(j+1)-2, k, -1
                        if (colidx(kk) .gt. 0) then
                           a(kk+1)  = a(kk)
                           colidx(kk+1) = colidx(kk)
                        endif
                     enddo
                     colidx(k) = jcol
                     a(k)  = 0.d0
                     goto 40
                  else if (colidx(k) .eq. 0) then
                     colidx(k) = jcol
                     goto 40
                  else if (colidx(k) .eq. jcol) then
c---------------------------------------------------------------------
c       ... mark the duplicated entry
c---------------------------------------------------------------------
                     nzloc(j) = nzloc(j) + 1
                     goto 40
                  endif
               enddo
               print *,'internal error in sparse: i=',i
               stop
   40          continue
               a(k) = a(k) + va
            enddo
   60       continue
         enddo
         size = size * ratio
      enddo


c---------------------------------------------------------------------
c       ... remove empty entries and generate final results
c---------------------------------------------------------------------
      do j = 2, nrows
         nzloc(j) = nzloc(j) + nzloc(j-1)
      enddo

      do j = 1, nrows
         if (j .gt. 1) then
            j1 = rowstr(j) - nzloc(j-1)
         else
            j1 = 1
         endif
         j2 = rowstr(j+1) - nzloc(j) - 1
         nza = rowstr(j)
         do k = j1, j2
            a(k) = a(nza)
            colidx(k) = colidx(nza)
            nza = nza + 1
         enddo
      enddo
      do j = 2, nrows+1
         rowstr(j) = rowstr(j) - nzloc(j-1)
      enddo
      nza = rowstr(nrows+1) - 1


CC       write (*, 11000) nza
      return
11000   format ( //,'final nonzero count in sparse ',
     1            /,'number of nonzeros       = ', i16 )
      end
c-------end   of sparse-----------------------------


c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine sprnvc( n, nz, nn1, v, iv )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit           none
      double precision   v(*)
      integer            n, nz, nn1, iv(*)
      common /urando/    amult, tran
      double precision   amult, tran


c---------------------------------------------------------------------
c       generate a sparse n-vector (v, iv)
c       having nzv nonzeros
c
c       mark(i) is set to 1 if position i is nonzero.
c       mark is all zero on entry and is reset to all zero before exit
c       this corrects a performance bug found by John G. Lewis, caused by
c       reinitialization of mark on every one of the n calls to sprnvc
c---------------------------------------------------------------------

        integer            nzv, ii, i, icnvrt

        external           randlc, icnvrt
        double precision   randlc, vecelt, vecloc


        nzv = 0

100     continue
        if (nzv .ge. nz) goto 110

         vecelt = randlc( tran, amult )

c---------------------------------------------------------------------
c   generate an integer between 1 and n in a portable manner
c---------------------------------------------------------------------
         vecloc = randlc(tran, amult)
         i = icnvrt(vecloc, nn1) + 1
         if (i .gt. n) goto 100

c---------------------------------------------------------------------
c  was this integer generated already?
c---------------------------------------------------------------------
         do ii = 1, nzv
            if (iv(ii) .eq. i) goto 100
         enddo
         nzv = nzv + 1
         v(nzv) = vecelt
         iv(nzv) = i
         goto 100
110     continue

      return
      end
c-------end   of sprnvc-----------------------------


c---------------------------------------------------------------------
c---------------------------------------------------------------------
      function icnvrt(x, ipwr2)
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit           none
      double precision   x
      integer            ipwr2, icnvrt

c---------------------------------------------------------------------
c    scale a double precision number x in (0,1) by a power of 2 and chop it
c---------------------------------------------------------------------
      icnvrt = int(ipwr2 * x)

      return
      end
c-------end   of icnvrt-----------------------------


c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine vecset(n, v, iv, nzv, i, val)
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit           none
      integer            n, iv(*), nzv, i, k
      double precision   v(*), val

c---------------------------------------------------------------------
c       set ith element of sparse vector (v, iv) with
c       nzv nonzeros to val
c---------------------------------------------------------------------

      logical set

      set = .false.
      do k = 1, nzv
         if (iv(k) .eq. i) then
            v(k) = val
            set  = .true.
         endif
      enddo
      if (.not. set) then
         nzv     = nzv + 1
         v(nzv)  = val
         iv(nzv) = i
      endif
      return
      end
c-------end   of vecset-----------------------------



