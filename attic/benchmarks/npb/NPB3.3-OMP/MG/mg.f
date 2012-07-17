!-------------------------------------------------------------------------!
!                                                                         !
!        N  A  S     P A R A L L E L     B E N C H M A R K S  3.3         !
!                                                                         !
!                       O p e n M P     V E R S I O N                     !
!                                                                         !
!                                   M G                                   !
!                                                                         !
!-------------------------------------------------------------------------!
!                                                                         !
!    This benchmark is an OpenMP version of the NPB MG code.              !
!    It is described in NAS Technical Report 99-011.                      !
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
c
c Authors: E. Barszcz
c          P. Frederickson
c          A. Woo
c          M. Yarrow
c          H. Jin
c
c---------------------------------------------------------------------


c---------------------------------------------------------------------
      program mg
c---------------------------------------------------------------------

      implicit none

      include 'globals.h'

c---------------------------------------------------------------------------c
c k is the current level. It is passed down through subroutine args
c and is NOT global. it is the current iteration
c---------------------------------------------------------------------------c

      integer k, it
      
      external timer_read
      double precision t, tinit, mflops, timer_read

c---------------------------------------------------------------------------c
c These arrays are in common because they are quite large
c and probably shouldn't be allocated on the stack. They
c are always passed as subroutine args. 
c---------------------------------------------------------------------------c

      double precision u(nr),v(nv),r(nr),a(0:3),c(0:3)
      common /noautom/ u,v,r   

      double precision rnm2, rnmu, old2, oldu, epsilon
      integer n1, n2, n3, nit
      double precision nn, verify_value, err
      logical verified

      integer i, fstatus
      character t_names(t_last)*8
      double precision tmax
!$    integer  omp_get_max_threads
!$    external omp_get_max_threads


      do i = T_init, T_last
         call timer_clear(i)
      end do

      call timer_start(T_init)

c---------------------------------------------------------------------
c Read in and broadcast input data
c---------------------------------------------------------------------

      open(unit=7,file='timer.flag', status='old', iostat=fstatus)
      if (fstatus .eq. 0) then
         timeron = .true.
         t_names(t_init) = 'init'
         t_names(t_bench) = 'benchmk'
         t_names(t_mg3P) = 'mg3P'
         t_names(t_psinv) = 'psinv'
         t_names(t_resid) = 'resid'
         t_names(t_rprj3) = 'rprj3'
         t_names(t_interp) = 'interp'
         t_names(t_norm2) = 'norm2'
         t_names(t_comm3) = 'comm3'
         close(7)
      else
         timeron = .false.
      endif

      write (*, 1000) 

      open(unit=7,file="mg.input", status="old", iostat=fstatus)
      if (fstatus .eq. 0) then
         write(*,50) 
 50      format(' Reading from input file mg.input')
         read(7,*) lt
         read(7,*) nx(lt), ny(lt), nz(lt)
         read(7,*) nit
         read(7,*) (debug_vec(i),i=0,7)
      else
         write(*,51) 
 51      format(' No input file. Using compiled defaults ')
         lt = lt_default
         nit = nit_default
         nx(lt) = nx_default
         ny(lt) = ny_default
         nz(lt) = nz_default
         do i = 0,7
            debug_vec(i) = debug_default
         end do
      endif


      if ( (nx(lt) .ne. ny(lt)) .or. (nx(lt) .ne. nz(lt)) ) then
         Class = 'U' 
      else if( nx(lt) .eq. 32 .and. nit .eq. 4 ) then
         Class = 'S'
      else if( nx(lt) .eq. 128 .and. nit .eq. 4 ) then
         Class = 'W'
      else if( nx(lt) .eq. 256 .and. nit .eq. 4 ) then  
         Class = 'A'
      else if( nx(lt) .eq. 256 .and. nit .eq. 20 ) then
         Class = 'B'
      else if( nx(lt) .eq. 512 .and. nit .eq. 20 ) then  
         Class = 'C'
      else if( nx(lt) .eq. 1024 .and. nit .eq. 50 ) then  
         Class = 'D'
      else if( nx(lt) .eq. 2048 .and. nit .eq. 50 ) then  
         Class = 'E'
      else
         Class = 'U'
      endif

c---------------------------------------------------------------------
c  Use these for debug info:
c---------------------------------------------------------------------
c     debug_vec(0) = 1 !=> report all norms
c     debug_vec(1) = 1 !=> some setup information
c     debug_vec(1) = 2 !=> more setup information
c     debug_vec(2) = k => at level k or below, show result of resid
c     debug_vec(3) = k => at level k or below, show result of psinv
c     debug_vec(4) = k => at level k or below, show result of rprj
c     debug_vec(5) = k => at level k or below, show result of interp
c     debug_vec(6) = 1 => (unused)
c     debug_vec(7) = 1 => (unused)
c---------------------------------------------------------------------
      a(0) = -8.0D0/3.0D0 
      a(1) =  0.0D0 
      a(2) =  1.0D0/6.0D0 
      a(3) =  1.0D0/12.0D0
      
      if(Class .eq. 'A' .or. Class .eq. 'S'.or. Class .eq.'W') then
c---------------------------------------------------------------------
c     Coefficients for the S(a) smoother
c---------------------------------------------------------------------
         c(0) =  -3.0D0/8.0D0
         c(1) =  +1.0D0/32.0D0
         c(2) =  -1.0D0/64.0D0
         c(3) =   0.0D0
      else
c---------------------------------------------------------------------
c     Coefficients for the S(b) smoother
c---------------------------------------------------------------------
         c(0) =  -3.0D0/17.0D0
         c(1) =  +1.0D0/33.0D0
         c(2) =  -1.0D0/61.0D0
         c(3) =   0.0D0
      endif
      lb = 1
      k  = lt

      call setup(n1,n2,n3,k)
      call zero3(u,n1,n2,n3)
      call zran3(v,n1,n2,n3,nx(lt),ny(lt),k)

      call norm2u3(v,n1,n2,n3,rnm2,rnmu,nx(lt),ny(lt),nz(lt))
c     write(*,*)
c     write(*,*)' norms of random v are'
c     write(*,600) 0, rnm2, rnmu
c     write(*,*)' about to evaluate resid, k=',k

      write (*, 1001) nx(lt),ny(lt),nz(lt), Class
      write (*, 1002) nit
!$    write (*, 1003) omp_get_max_threads()
      write (*, *)

 1000 format(//,' NAS Parallel Benchmarks (NPB3.3-OMP)',
     >          ' - MG Benchmark', /)
 1001 format(' Size: ', i4, 'x', i4, 'x', i4, '  (class ', A, ')' )
 1002 format(' Iterations:                  ', i5)
 1003 format(' Number of available threads: ', i5)


      call resid(u,v,r,n1,n2,n3,a,k)
      call norm2u3(r,n1,n2,n3,rnm2,rnmu,nx(lt),ny(lt),nz(lt))
      old2 = rnm2
      oldu = rnmu

c---------------------------------------------------------------------
c     One iteration for startup
c---------------------------------------------------------------------
      call mg3P(u,v,r,a,c,n1,n2,n3,k)
      call resid(u,v,r,n1,n2,n3,a,k)
      call setup(n1,n2,n3,k)
      call zero3(u,n1,n2,n3)
      call zran3(v,n1,n2,n3,nx(lt),ny(lt),k)

      call timer_stop(T_init)
      tinit = timer_read(T_init)

      write( *,'(A,F15.3,A/)' ) 
     >     ' Initialization time: ',tinit, ' seconds'

      do i = T_bench, T_last
         call timer_clear(i)
      end do

      call timer_start(T_bench)

      if (timeron) call timer_start(T_resid2)
      call resid(u,v,r,n1,n2,n3,a,k)
      if (timeron) call timer_stop(T_resid2)
      call norm2u3(r,n1,n2,n3,rnm2,rnmu,nx(lt),ny(lt),nz(lt))
      old2 = rnm2
      oldu = rnmu

      do  it=1,nit
         if (it.eq.1 .or. it.eq.nit .or. mod(it,5).eq.0) then
            write(*,80) it
   80       format('  iter ',i3)
         endif
         if (timeron) call timer_start(T_mg3P)
         call mg3P(u,v,r,a,c,n1,n2,n3,k)
         if (timeron) call timer_stop(T_mg3P)
         if (timeron) call timer_start(T_resid2)
         call resid(u,v,r,n1,n2,n3,a,k)
         if (timeron) call timer_stop(T_resid2)
      enddo


      call norm2u3(r,n1,n2,n3,rnm2,rnmu,nx(lt),ny(lt),nz(lt))

      call timer_stop(T_bench)

      t = timer_read(T_bench)

      verified = .FALSE.
      verify_value = 0.0

      write(*,100)
 100  format(/' Benchmark completed ')

      epsilon = 1.d-8
      if (Class .ne. 'U') then
         if(Class.eq.'S') then
            verify_value = 0.5307707005734d-04
         elseif(Class.eq.'W') then
            verify_value = 0.6467329375339d-05
         elseif(Class.eq.'A') then
            verify_value = 0.2433365309069d-05
         elseif(Class.eq.'B') then
            verify_value = 0.1800564401355d-05
         elseif(Class.eq.'C') then
            verify_value = 0.5706732285740d-06
         elseif(Class.eq.'D') then
            verify_value = 0.1583275060440d-09
         elseif(Class.eq.'E') then
            verify_value = 0.5630442584711d-10
         endif

         err = abs( rnm2 - verify_value ) / verify_value
         if( err .le. epsilon ) then
            verified = .TRUE.
            write(*, 200)
            write(*, 201) rnm2
            write(*, 202) err
 200        format(' VERIFICATION SUCCESSFUL ')
 201        format(' L2 Norm is ', E20.13)
 202        format(' Error is   ', E20.13)
         else
            verified = .FALSE.
            write(*, 300) 
            write(*, 301) rnm2
            write(*, 302) verify_value
 300        format(' VERIFICATION FAILED')
 301        format(' L2 Norm is             ', E20.13)
 302        format(' The correct L2 Norm is ', E20.13)
         endif
      else
         verified = .FALSE.
         write (*, 400)
         write (*, 401)
         write (*, 201) rnm2
 400     format(' Problem size unknown')
 401     format(' NO VERIFICATION PERFORMED')
      endif

      nn = 1.0d0*nx(lt)*ny(lt)*nz(lt)

      if( t .ne. 0. ) then
         mflops = 58.*nit*nn*1.0D-6 /t
      else
         mflops = 0.0
      endif

      call print_results('MG', class, nx(lt), ny(lt), nz(lt), 
     >                   nit, t,
     >                   mflops, '          floating point', 
     >                   verified, npbversion, compiletime,
     >                   cs1, cs2, cs3, cs4, cs5, cs6, cs7)


 600  format( i4, 2e19.12)

c---------------------------------------------------------------------
c      More timers
c---------------------------------------------------------------------
      if (.not.timeron) goto 999

      tmax = timer_read(t_bench)
      if (tmax .eq. 0.0) tmax = 1.0

      write(*,800)
 800  format('  SECTION   Time (secs)')
      do i=t_bench, t_last
         t = timer_read(i)
         if (i.eq.t_resid2) then
            t = timer_read(T_resid) - t
            write(*,820) 'mg-resid', t, t*100./tmax
         else
            write(*,810) t_names(i), t, t*100./tmax
         endif
 810     format(2x,a8,':',f9.3,'  (',f6.2,'%)')
 820     format('    --> ',a8,':',f9.3,'  (',f6.2,'%)')
      end do

 999  continue

      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine setup(n1,n2,n3,k)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none

      include 'globals.h'

      integer  is1, is2, is3, ie1, ie2, ie3
      common /grid/ is1,is2,is3,ie1,ie2,ie3

      integer n1,n2,n3,k
      integer j

      integer ax, mi(3,maxlevel)
      integer ng(3,maxlevel)


      ng(1,lt) = nx(lt)
      ng(2,lt) = ny(lt)
      ng(3,lt) = nz(lt)
      do  ax=1,3
         do  k=lt-1,1,-1
            ng(ax,k) = ng(ax,k+1)/2
         enddo
      enddo
 61   format(10i4)
      do  k=lt,1,-1
         nx(k) = ng(1,k)
         ny(k) = ng(2,k)
         nz(k) = ng(3,k)
      enddo

      do  k = lt,1,-1
         do  ax = 1,3
            mi(ax,k) = 2 + ng(ax,k) 
         enddo

         m1(k) = mi(1,k)
         m2(k) = mi(2,k)
         m3(k) = mi(3,k)

      enddo

      k = lt
      is1 = 2 + ng(1,k) - ng(1,lt)
      ie1 = 1 + ng(1,k)
      n1 = 3 + ie1 - is1
      is2 = 2 + ng(2,k) - ng(2,lt)
      ie2 = 1 + ng(2,k) 
      n2 = 3 + ie2 - is2
      is3 = 2 + ng(3,k) - ng(3,lt)
      ie3 = 1 + ng(3,k) 
      n3 = 3 + ie3 - is3


      ir(lt)=1
      do  j = lt-1, 1, -1
         ir(j)=ir(j+1)+one*m1(j+1)*m2(j+1)*m3(j+1)
      enddo


      if( debug_vec(1) .ge. 1 )then
         write(*,*)' in setup, '
         write(*,*)' k  lt  nx  ny  nz ',
     >        ' n1  n2  n3 is1 is2 is3 ie1 ie2 ie3'
         write(*,9) k,lt,ng(1,k),ng(2,k),ng(3,k),
     >              n1,n2,n3,is1,is2,is3,ie1,ie2,ie3
 9       format(15i4)
      endif

      k = lt

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine mg3P(u,v,r,a,c,n1,n2,n3,k)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     multigrid V-cycle routine
c---------------------------------------------------------------------
      implicit none

      include 'globals.h'

      integer n1, n2, n3, k
      double precision u(nr),v(nv),r(nr)
      double precision a(0:3),c(0:3)

      integer j

c---------------------------------------------------------------------
c     down cycle.
c     restrict the residual from the find grid to the coarse
c---------------------------------------------------------------------

      do  k= lt, lb+1 , -1
         j = k-1
         call rprj3(r(ir(k)),m1(k),m2(k),m3(k),
     >        r(ir(j)),m1(j),m2(j),m3(j),k)
      enddo

      k = lb
c---------------------------------------------------------------------
c     compute an approximate solution on the coarsest grid
c---------------------------------------------------------------------
      call zero3(u(ir(k)),m1(k),m2(k),m3(k))
      call psinv(r(ir(k)),u(ir(k)),m1(k),m2(k),m3(k),c,k)

      do  k = lb+1, lt-1     
          j = k-1
c---------------------------------------------------------------------
c        prolongate from level k-1  to k
c---------------------------------------------------------------------
         call zero3(u(ir(k)),m1(k),m2(k),m3(k))
         call interp(u(ir(j)),m1(j),m2(j),m3(j),
     >               u(ir(k)),m1(k),m2(k),m3(k),k)
c---------------------------------------------------------------------
c        compute residual for level k
c---------------------------------------------------------------------
         call resid(u(ir(k)),r(ir(k)),r(ir(k)),m1(k),m2(k),m3(k),a,k)
c---------------------------------------------------------------------
c        apply smoother
c---------------------------------------------------------------------
         call psinv(r(ir(k)),u(ir(k)),m1(k),m2(k),m3(k),c,k)
      enddo
 200  continue
      j = lt - 1
      k = lt
      call interp(u(ir(j)),m1(j),m2(j),m3(j),u,n1,n2,n3,k)
      call resid(u,v,r,n1,n2,n3,a,k)
      call psinv(r,u,n1,n2,n3,c,k)

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine psinv( r,u,n1,n2,n3,c,k)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     psinv applies an approximate inverse as smoother:  u = u + Cr
c
c     This  implementation costs  15A + 4M per result, where
c     A and M denote the costs of Addition and Multiplication.  
c     Presuming coefficient c(3) is zero (the NPB assumes this,
c     but it is thus not a general case), 2A + 1M may be eliminated,
c     resulting in 13A + 3M.
c     Note that this vectorizes, and is also fine for cache 
c     based machines.  
c---------------------------------------------------------------------
      implicit none

      include 'globals.h'

      integer n1,n2,n3,k
      double precision u(n1,n2,n3),r(n1,n2,n3),c(0:3)
      integer i3, i2, i1

      double precision r1(m), r2(m)

      if (timeron) call timer_start(T_psinv)
!$omp parallel do default(shared) private(i1,i2,i3,r1,r2)
      do i3=2,n3-1
         do i2=2,n2-1
            do i1=1,n1
               r1(i1) = r(i1,i2-1,i3) + r(i1,i2+1,i3)
     >                + r(i1,i2,i3-1) + r(i1,i2,i3+1)
               r2(i1) = r(i1,i2-1,i3-1) + r(i1,i2+1,i3-1)
     >                + r(i1,i2-1,i3+1) + r(i1,i2+1,i3+1)
            enddo
            do i1=2,n1-1
               u(i1,i2,i3) = u(i1,i2,i3)
     >                     + c(0) * r(i1,i2,i3)
     >                     + c(1) * ( r(i1-1,i2,i3) + r(i1+1,i2,i3)
     >                              + r1(i1) )
     >                     + c(2) * ( r2(i1) + r1(i1-1) + r1(i1+1) )
c---------------------------------------------------------------------
c  Assume c(3) = 0    (Enable line below if c(3) not= 0)
c---------------------------------------------------------------------
c    >                     + c(3) * ( r2(i1-1) + r2(i1+1) )
c---------------------------------------------------------------------
            enddo
         enddo
      enddo
      if (timeron) call timer_stop(T_psinv)

c---------------------------------------------------------------------
c     exchange boundary points
c---------------------------------------------------------------------
      call comm3(u,n1,n2,n3,k)

      if( debug_vec(0) .ge. 1 )then
         call rep_nrm(u,n1,n2,n3,'   psinv',k)
      endif

      if( debug_vec(3) .ge. k )then
         call showall(u,n1,n2,n3)
      endif

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine resid( u,v,r,n1,n2,n3,a,k )

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     resid computes the residual:  r = v - Au
c
c     This  implementation costs  15A + 4M per result, where
c     A and M denote the costs of Addition (or Subtraction) and 
c     Multiplication, respectively. 
c     Presuming coefficient a(1) is zero (the NPB assumes this,
c     but it is thus not a general case), 3A + 1M may be eliminated,
c     resulting in 12A + 3M.
c     Note that this vectorizes, and is also fine for cache 
c     based machines.  
c---------------------------------------------------------------------
      implicit none

      include 'globals.h'

      integer n1,n2,n3,k
      double precision u(n1,n2,n3),v(n1,n2,n3),r(n1,n2,n3),a(0:3)
      integer i3, i2, i1
      double precision u1(m), u2(m)

      if (timeron) call timer_start(T_resid)
!$omp parallel do default(shared) private(i1,i2,i3,u1,u2)
      do i3=2,n3-1
         do i2=2,n2-1
            do i1=1,n1
               u1(i1) = u(i1,i2-1,i3) + u(i1,i2+1,i3)
     >                + u(i1,i2,i3-1) + u(i1,i2,i3+1)
               u2(i1) = u(i1,i2-1,i3-1) + u(i1,i2+1,i3-1)
     >                + u(i1,i2-1,i3+1) + u(i1,i2+1,i3+1)
            enddo
            do i1=2,n1-1
               r(i1,i2,i3) = v(i1,i2,i3)
     >                     - a(0) * u(i1,i2,i3)
c---------------------------------------------------------------------
c  Assume a(1) = 0      (Enable 2 lines below if a(1) not= 0)
c---------------------------------------------------------------------
c    >                     - a(1) * ( u(i1-1,i2,i3) + u(i1+1,i2,i3)
c    >                              + u1(i1) )
c---------------------------------------------------------------------
     >                     - a(2) * ( u2(i1) + u1(i1-1) + u1(i1+1) )
     >                     - a(3) * ( u2(i1-1) + u2(i1+1) )
            enddo
         enddo
      enddo
      if (timeron) call timer_stop(T_resid)

c---------------------------------------------------------------------
c     exchange boundary data
c---------------------------------------------------------------------
      call comm3(r,n1,n2,n3,k)

      if( debug_vec(0) .ge. 1 )then
         call rep_nrm(r,n1,n2,n3,'   resid',k)
      endif

      if( debug_vec(2) .ge. k )then
         call showall(r,n1,n2,n3)
      endif

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine rprj3( r,m1k,m2k,m3k,s,m1j,m2j,m3j,k )

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     rprj3 projects onto the next coarser grid, 
c     using a trilinear Finite Element projection:  s = r' = P r
c     
c     This  implementation costs  20A + 4M per result, where
c     A and M denote the costs of Addition and Multiplication.  
c     Note that this vectorizes, and is also fine for cache 
c     based machines.  
c---------------------------------------------------------------------
      implicit none

      include 'globals.h'

      integer m1k, m2k, m3k, m1j, m2j, m3j,k
      double precision r(m1k,m2k,m3k), s(m1j,m2j,m3j)
      integer j3, j2, j1, i3, i2, i1, d1, d2, d3, j

      double precision x1(m), y1(m), x2,y2

      if (timeron) call timer_start(T_rprj3)
      if(m1k.eq.3)then
        d1 = 2
      else
        d1 = 1
      endif

      if(m2k.eq.3)then
        d2 = 2
      else
        d2 = 1
      endif

      if(m3k.eq.3)then
        d3 = 2
      else
        d3 = 1
      endif

!$omp parallel do default(shared)
!$omp& private(j1,j2,j3,i1,i2,i3,x1,y1,x2,y2)
      do  j3=2,m3j-1
         i3 = 2*j3-d3
         do  j2=2,m2j-1
            i2 = 2*j2-d2

            do j1=2,m1j
              i1 = 2*j1-d1
              x1(i1-1) = r(i1-1,i2-1,i3  ) + r(i1-1,i2+1,i3  )
     >                 + r(i1-1,i2,  i3-1) + r(i1-1,i2,  i3+1)
              y1(i1-1) = r(i1-1,i2-1,i3-1) + r(i1-1,i2-1,i3+1)
     >                 + r(i1-1,i2+1,i3-1) + r(i1-1,i2+1,i3+1)
            enddo

            do  j1=2,m1j-1
              i1 = 2*j1-d1
              y2 = r(i1,  i2-1,i3-1) + r(i1,  i2-1,i3+1)
     >           + r(i1,  i2+1,i3-1) + r(i1,  i2+1,i3+1)
              x2 = r(i1,  i2-1,i3  ) + r(i1,  i2+1,i3  )
     >           + r(i1,  i2,  i3-1) + r(i1,  i2,  i3+1)
              s(j1,j2,j3) =
     >               0.5D0 * r(i1,i2,i3)
     >             + 0.25D0 * ( r(i1-1,i2,i3) + r(i1+1,i2,i3) + x2)
     >             + 0.125D0 * ( x1(i1-1) + x1(i1+1) + y2)
     >             + 0.0625D0 * ( y1(i1-1) + y1(i1+1) )
            enddo

         enddo
      enddo
      if (timeron) call timer_stop(T_rprj3)


      j = k-1
      call comm3(s,m1j,m2j,m3j,j)

      if( debug_vec(0) .ge. 1 )then
         call rep_nrm(s,m1j,m2j,m3j,'   rprj3',k-1)
      endif

      if( debug_vec(4) .ge. k )then
         call showall(s,m1j,m2j,m3j)
      endif

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine interp( z,mm1,mm2,mm3,u,n1,n2,n3,k )

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     interp adds the trilinear interpolation of the correction
c     from the coarser grid to the current approximation:  u = u + Qu'
c     
c     Observe that this  implementation costs  16A + 4M, where
c     A and M denote the costs of Addition and Multiplication.  
c     Note that this vectorizes, and is also fine for cache 
c     based machines.  Vector machines may get slightly better 
c     performance however, with 8 separate "do i1" loops, rather than 4.
c---------------------------------------------------------------------
      implicit none

      include 'globals.h'

      integer mm1, mm2, mm3, n1, n2, n3,k
      double precision z(mm1,mm2,mm3),u(n1,n2,n3)
      integer i3, i2, i1, d1, d2, d3, t1, t2, t3

c note that m = 1037 in globals.h but for this only need to be
c 535 to handle up to 1024^3
c      integer m
c      parameter( m=535 )
      double precision z1(m),z2(m),z3(m)

      if (timeron) call timer_start(T_interp)
      if( n1 .ne. 3 .and. n2 .ne. 3 .and. n3 .ne. 3 ) then

!$omp parallel do default(shared) private(i1,i2,i3,z1,z2,z3)
         do  i3=1,mm3-1
            do  i2=1,mm2-1

               do i1=1,mm1
                  z1(i1) = z(i1,i2+1,i3) + z(i1,i2,i3)
                  z2(i1) = z(i1,i2,i3+1) + z(i1,i2,i3)
                  z3(i1) = z(i1,i2+1,i3+1) + z(i1,i2,i3+1) + z1(i1)
               enddo

               do  i1=1,mm1-1
                  u(2*i1-1,2*i2-1,2*i3-1)=u(2*i1-1,2*i2-1,2*i3-1)
     >                 +z(i1,i2,i3)
                  u(2*i1,2*i2-1,2*i3-1)=u(2*i1,2*i2-1,2*i3-1)
     >                 +0.5d0*(z(i1+1,i2,i3)+z(i1,i2,i3))
               enddo
               do i1=1,mm1-1
                  u(2*i1-1,2*i2,2*i3-1)=u(2*i1-1,2*i2,2*i3-1)
     >                 +0.5d0 * z1(i1)
                  u(2*i1,2*i2,2*i3-1)=u(2*i1,2*i2,2*i3-1)
     >                 +0.25d0*( z1(i1) + z1(i1+1) )
               enddo
               do i1=1,mm1-1
                  u(2*i1-1,2*i2-1,2*i3)=u(2*i1-1,2*i2-1,2*i3)
     >                 +0.5d0 * z2(i1)
                  u(2*i1,2*i2-1,2*i3)=u(2*i1,2*i2-1,2*i3)
     >                 +0.25d0*( z2(i1) + z2(i1+1) )
               enddo
               do i1=1,mm1-1
                  u(2*i1-1,2*i2,2*i3)=u(2*i1-1,2*i2,2*i3)
     >                 +0.25d0* z3(i1)
                  u(2*i1,2*i2,2*i3)=u(2*i1,2*i2,2*i3)
     >                 +0.125d0*( z3(i1) + z3(i1+1) )
               enddo
            enddo
         enddo

      else

         if(n1.eq.3)then
            d1 = 2
            t1 = 1
         else
            d1 = 1
            t1 = 0
         endif
         
         if(n2.eq.3)then
            d2 = 2
            t2 = 1
         else
            d2 = 1
            t2 = 0
         endif
         
         if(n3.eq.3)then
            d3 = 2
            t3 = 1
         else
            d3 = 1
            t3 = 0
         endif
         
!$omp parallel default(shared) private(i1,i2,i3)
!$omp do
         do  i3=d3,mm3-1
            do  i2=d2,mm2-1
               do  i1=d1,mm1-1
                  u(2*i1-d1,2*i2-d2,2*i3-d3)=u(2*i1-d1,2*i2-d2,2*i3-d3)
     >                 +z(i1,i2,i3)
               enddo
               do  i1=1,mm1-1
                  u(2*i1-t1,2*i2-d2,2*i3-d3)=u(2*i1-t1,2*i2-d2,2*i3-d3)
     >                 +0.5D0*(z(i1+1,i2,i3)+z(i1,i2,i3))
               enddo
            enddo
            do  i2=1,mm2-1
               do  i1=d1,mm1-1
                  u(2*i1-d1,2*i2-t2,2*i3-d3)=u(2*i1-d1,2*i2-t2,2*i3-d3)
     >                 +0.5D0*(z(i1,i2+1,i3)+z(i1,i2,i3))
               enddo
               do  i1=1,mm1-1
                  u(2*i1-t1,2*i2-t2,2*i3-d3)=u(2*i1-t1,2*i2-t2,2*i3-d3)
     >                 +0.25D0*(z(i1+1,i2+1,i3)+z(i1+1,i2,i3)
     >                 +z(i1,  i2+1,i3)+z(i1,  i2,i3))
               enddo
            enddo
         enddo

!$omp do
         do  i3=1,mm3-1
            do  i2=d2,mm2-1
               do  i1=d1,mm1-1
                  u(2*i1-d1,2*i2-d2,2*i3-t3)=u(2*i1-d1,2*i2-d2,2*i3-t3)
     >                 +0.5D0*(z(i1,i2,i3+1)+z(i1,i2,i3))
               enddo
               do  i1=1,mm1-1
                  u(2*i1-t1,2*i2-d2,2*i3-t3)=u(2*i1-t1,2*i2-d2,2*i3-t3)
     >                 +0.25D0*(z(i1+1,i2,i3+1)+z(i1,i2,i3+1)
     >                 +z(i1+1,i2,i3  )+z(i1,i2,i3  ))
               enddo
            enddo
            do  i2=1,mm2-1
               do  i1=d1,mm1-1
                  u(2*i1-d1,2*i2-t2,2*i3-t3)=u(2*i1-d1,2*i2-t2,2*i3-t3)
     >                 +0.25D0*(z(i1,i2+1,i3+1)+z(i1,i2,i3+1)
     >                 +z(i1,i2+1,i3  )+z(i1,i2,i3  ))
               enddo
               do  i1=1,mm1-1
                  u(2*i1-t1,2*i2-t2,2*i3-t3)=u(2*i1-t1,2*i2-t2,2*i3-t3)
     >                 +0.125D0*(z(i1+1,i2+1,i3+1)+z(i1+1,i2,i3+1)
     >                 +z(i1  ,i2+1,i3+1)+z(i1  ,i2,i3+1)
     >                 +z(i1+1,i2+1,i3  )+z(i1+1,i2,i3  )
     >                 +z(i1  ,i2+1,i3  )+z(i1  ,i2,i3  ))
               enddo
            enddo
         enddo
!$omp end do nowait
!$omp end parallel

      endif
      if (timeron) call timer_stop(T_interp)

      if( debug_vec(0) .ge. 1 )then
         call rep_nrm(z,mm1,mm2,mm3,'z: inter',k-1)
         call rep_nrm(u,n1,n2,n3,'u: inter',k)
      endif

      if( debug_vec(5) .ge. k )then
         call showall(z,mm1,mm2,mm3)
         call showall(u,n1,n2,n3)
      endif

      return 
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine norm2u3(r,n1,n2,n3,rnm2,rnmu,nx,ny,nz)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     norm2u3 evaluates approximations to the L2 norm and the
c     uniform (or L-infinity or Chebyshev) norm, under the
c     assumption that the boundaries are periodic or zero.  Add the
c     boundaries in with half weight (quarter weight on the edges
c     and eighth weight at the corners) for inhomogeneous boundaries.
c---------------------------------------------------------------------
      implicit none


      integer n1, n2, n3, nx, ny, nz
      double precision rnm2, rnmu, r(n1,n2,n3)
      double precision s, a
      integer i3, i2, i1

      double precision dn

      logical timeron
      common /timers/ timeron
      integer T_norm2
      parameter (T_norm2=9)

      if (timeron) call timer_start(T_norm2)
      dn = 1.0d0*nx*ny*nz

      s=0.0D0
      rnmu = 0.0D0
!$omp parallel do default(shared) private(i1,i2,i3,a)
!$omp& reduction(+:s) reduction(max:rnmu)
      do  i3=2,n3-1
         do  i2=2,n2-1
            do  i1=2,n1-1
               s=s+r(i1,i2,i3)**2
               a=abs(r(i1,i2,i3))
               rnmu=dmax1(rnmu,a)
            enddo
         enddo
      enddo

      rnm2=sqrt( s / dn )
      if (timeron) call timer_stop(T_norm2)

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine rep_nrm(u,n1,n2,n3,title,kk)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     report on norm
c---------------------------------------------------------------------
      implicit none

      include 'globals.h'

      integer n1, n2, n3, kk
      double precision u(n1,n2,n3)
      character*8 title

      double precision rnm2, rnmu


      call norm2u3(u,n1,n2,n3,rnm2,rnmu,nx(kk),ny(kk),nz(kk))
      write(*,7)kk,title,rnm2,rnmu
 7    format(' Level',i2,' in ',a8,': norms =',D21.14,D21.14)

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine comm3(u,n1,n2,n3,kk)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     comm3 organizes the communication on all borders 
c---------------------------------------------------------------------
      implicit none

      include 'globals.h'

      integer n1, n2, n3, kk
      double precision u(n1,n2,n3)
      integer i1, i2, i3

      if (timeron) call timer_start(T_comm3)
!$omp parallel default(shared) private(i1,i2,i3)
!$omp do
      do  i3=2,n3-1
         do  i2=2,n2-1
            u( 1,i2,i3) = u(n1-1,i2,i3)
            u(n1,i2,i3) = u(   2,i2,i3)
         enddo
c      enddo

c      do  i3=2,n3-1
         do  i1=1,n1
            u(i1, 1,i3) = u(i1,n2-1,i3)
            u(i1,n2,i3) = u(i1,   2,i3)
         enddo
      enddo

!$omp do
      do  i2=1,n2
         do  i1=1,n1
            u(i1,i2, 1) = u(i1,i2,n3-1)
            u(i1,i2,n3) = u(i1,i2,   2)
         enddo
      enddo
!$omp end do nowait
!$omp end parallel
      if (timeron) call timer_stop(T_comm3)

      return
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine zran3(z,n1,n2,n3,nx1,ny1,k)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     zran3  loads +1 at ten randomly chosen points,
c     loads -1 at a different ten random points,
c     and zero elsewhere.
c---------------------------------------------------------------------
      implicit none

      include 'globals.h'

      integer  is1, is2, is3, ie1, ie2, ie3
      common /grid/ is1,is2,is3,ie1,ie2,ie3

      integer n1, n2, n3, k, nx1, ny1, i0, mm0, mm1
      double precision z(n1,n2,n3)

      integer mm, i1, i2, i3, d1, e1, e2, e3
      double precision x, a
      double precision xx, x0, x1, a1, a2, ai, power
      parameter( mm = 10,  a = 5.D0 ** 13, x = 314159265.D0)
      double precision ten( mm, 0:1 ), best0, best1
      integer i, j1( mm, 0:1 ), j2( mm, 0:1 ), j3( mm, 0:1 )
      integer jg( 0:3, mm, 0:1 )

      double precision starts(nm)
      common /rans_save/ starts

      external randlc
      double precision randlc, rdummy
!$    integer  omp_get_thread_num, omp_get_num_threads
!$    external omp_get_thread_num, omp_get_num_threads
      integer myid, num_threads

      a1 = power( a, nx1 )
      a2 = power( a, nx1*ny1 )

      call zero3(z,n1,n2,n3)

      i = is1-2+nx1*(is2-2+ny1*(is3-2))

      ai = power( a, i )
      d1 = ie1 - is1 + 1
      e1 = ie1 - is1 + 2
      e2 = ie2 - is2 + 2
      e3 = ie3 - is3 + 2
      x0 = x
      rdummy = randlc( x0, ai )

c---------------------------------------------------------------------
c     save the starting seeds for the following loop
c---------------------------------------------------------------------
      do  i3 = 2, e3
         starts(i3) = x0
         rdummy = randlc( x0, a2 )
      end do

c---------------------------------------------------------------------
c     fill array
c---------------------------------------------------------------------
!$omp parallel do default(shared) private(i2,i3,x1,xx,rdummy)
!$omp&  shared(e2,e3,d1,a1)
      do  i3 = 2, e3
         x1 = starts(i3)
         do  i2 = 2, e2
            xx = x1
            call vranlc( d1, xx, a, z( 2, i2, i3 ))
            rdummy = randlc( x1, a1 )
         enddo
      enddo
!$omp end parallel do

c---------------------------------------------------------------------
c       call comm3(z,n1,n2,n3)
c       call showall(z,n1,n2,n3)
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     each thread looks for twenty candidates
c---------------------------------------------------------------------
!$omp parallel default(shared) private(i,i0,i1,i2,i3,j1,j2,j3,ten,
!$omp&  myid,num_threads) shared(best0,best1,n1,n2,n3)
      do  i=1,mm
         ten( i, 1 ) = 0.0D0
         j1( i, 1 ) = 0
         j2( i, 1 ) = 0
         j3( i, 1 ) = 0
         ten( i, 0 ) = 1.0D0
         j1( i, 0 ) = 0
         j2( i, 0 ) = 0
         j3( i, 0 ) = 0
      enddo

!$omp do
      do  i3=2,n3-1
         do  i2=2,n2-1
            do  i1=2,n1-1
               if( z(i1,i2,i3) .gt. ten( 1, 1 ) )then
                  ten(1,1) = z(i1,i2,i3) 
                  j1(1,1) = i1
                  j2(1,1) = i2
                  j3(1,1) = i3
                  call bubble( ten, j1, j2, j3, mm, 1 )
               endif
               if( z(i1,i2,i3) .lt. ten( 1, 0 ) )then
                  ten(1,0) = z(i1,i2,i3) 
                  j1(1,0) = i1
                  j2(1,0) = i2
                  j3(1,0) = i3
                  call bubble( ten, j1, j2, j3, mm, 0 )
               endif
            enddo
         enddo
      enddo
!$omp end do


c---------------------------------------------------------------------
c     Now which of these are globally best?
c---------------------------------------------------------------------
      i1 = mm
      i0 = mm
      myid = 0
!$    myid = omp_get_thread_num()
!$    num_threads = omp_get_num_threads()
      do  i=mm,1,-1

c ... ORDERED access is required here for sequential consistency
c ... in case that two values are identical.
c ... Since an "ORDERED" section is only defined in OpenMP 2,
c ... we use a dummy loop to emulate ordered access in OpenMP 1.x.
!$omp master
         best1 = 0.0D0
         best0 = 1.0D0
!$omp end master

!$omp do ordered schedule(static)
!$       do i2=1,num_threads
!$omp ordered
         if (ten(i1,1) .gt. best1) then
            best1 = ten(i1,1)
            jg( 0, i, 1 ) = myid
         endif
         if (ten(i0,0) .lt. best0) then
            best0 = ten(i0,0)
            jg( 0, i, 0 ) = myid
         endif
!$omp end ordered
!$       end do

         if (myid .eq. jg( 0, i, 1 )) then
            jg( 1, i, 1 ) = j1( i1, 1 )
            jg( 2, i, 1 ) = j2( i1, 1 )
            jg( 3, i, 1 ) = j3( i1, 1 )
            i1 = i1-1
         endif

         if (myid .eq. jg( 0, i, 0 )) then
            jg( 1, i, 0 ) = j1( i0, 0 )
            jg( 2, i, 0 ) = j2( i0, 0 )
            jg( 3, i, 0 ) = j3( i0, 0 )
            i0 = i0-1
         endif

      enddo
!$omp end parallel

c      mm1 = i1+1
c      mm0 = i0+1
      mm1 = 1
      mm0 = 1

c     write(*,*)' '
c     write(*,*)' negative charges at'
c     write(*,9)(jg(1,i,0),jg(2,i,0),jg(3,i,0),i=1,mm)
c     write(*,*)' positive charges at'
c     write(*,9)(jg(1,i,1),jg(2,i,1),jg(3,i,1),i=1,mm)
c     write(*,*)' small random numbers were'
c     write(*,8)(ten( i,0),i=mm,1,-1)
c     write(*,*)' and they were found on processor number'
c     write(*,7)(jg(0,i,0),i=mm,1,-1)
c     write(*,*)' large random numbers were'
c     write(*,8)(ten( i,1),i=mm,1,-1)
c     write(*,*)' and they were found on processor number'
c     write(*,7)(jg(0,i,1),i=mm,1,-1)
c 9    format(5(' (',i3,2(',',i3),')'))
c 8    format(5D15.8)
c 7    format(10i4)

!$omp parallel do default(shared) private(i1,i2,i3)
      do  i3=1,n3
         do  i2=1,n2
            do  i1=1,n1
               z(i1,i2,i3) = 0.0D0
            enddo
         enddo
      enddo
!$omp end parallel do

      do  i=mm,mm0,-1
         z( jg(1,i,0), jg(2,i,0), jg(3,i,0) ) = -1.0D0
      enddo
      do  i=mm,mm1,-1
         z( jg(1,i,1), jg(2,i,1), jg(3,i,1) ) = +1.0D0
      enddo

      call comm3(z,n1,n2,n3,k)

c---------------------------------------------------------------------
c          call showall(z,n1,n2,n3)
c---------------------------------------------------------------------

      return 
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine showall(z,n1,n2,n3)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none


      integer n1,n2,n3,i1,i2,i3
      double precision z(n1,n2,n3)
      integer m1, m2, m3

      m1 = min(n1,18)
      m2 = min(n2,14)
      m3 = min(n3,18)

      write(*,*)'  '
      do  i3=1,m3
         do  i1=1,m1
            write(*,6)(z(i1,i2,i3),i2=1,m2)
         enddo
         write(*,*)' - - - - - - - '
      enddo
      write(*,*)'  '
 6    format(15f6.3)

      return 
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------

      double precision function power( a, n )

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     power  raises an integer, disguised as a double
c     precision real, to an integer power
c---------------------------------------------------------------------
      implicit none

      double precision a, aj
      integer n, nj
      external randlc
      double precision randlc, rdummy

      power = 1.0D0
      nj = n
      aj = a
 100  continue

      if( nj .eq. 0 ) goto 200
      if( mod(nj,2) .eq. 1 ) rdummy =  randlc( power, aj )
      rdummy = randlc( aj, aj )
      nj = nj/2
      go to 100

 200  continue
      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine bubble( ten, j1, j2, j3, m, ind )

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c     bubble        does a bubble sort in direction dir
c---------------------------------------------------------------------
      implicit none


      integer m, ind, j1( m, 0:1 ), j2( m, 0:1 ), j3( m, 0:1 )
      double precision ten( m, 0:1 )
      double precision temp
      integer i, j_temp

      if( ind .eq. 1 )then

         do  i=1,m-1
            if( ten(i,ind) .gt. ten(i+1,ind) )then

               temp = ten( i+1, ind )
               ten( i+1, ind ) = ten( i, ind )
               ten( i, ind ) = temp

               j_temp           = j1( i+1, ind )
               j1( i+1, ind ) = j1( i,   ind )
               j1( i,   ind ) = j_temp

               j_temp           = j2( i+1, ind )
               j2( i+1, ind ) = j2( i,   ind )
               j2( i,   ind ) = j_temp

               j_temp           = j3( i+1, ind )
               j3( i+1, ind ) = j3( i,   ind )
               j3( i,   ind ) = j_temp

            else 
               return
            endif
         enddo

      else

         do  i=1,m-1
            if( ten(i,ind) .lt. ten(i+1,ind) )then

               temp = ten( i+1, ind )
               ten( i+1, ind ) = ten( i, ind )
               ten( i, ind ) = temp

               j_temp           = j1( i+1, ind )
               j1( i+1, ind ) = j1( i,   ind )
               j1( i,   ind ) = j_temp

               j_temp           = j2( i+1, ind )
               j2( i+1, ind ) = j2( i,   ind )
               j2( i,   ind ) = j_temp

               j_temp           = j3( i+1, ind )
               j3( i+1, ind ) = j3( i,   ind )
               j3( i,   ind ) = j_temp

            else 
               return
            endif
         enddo

      endif

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine zero3(z,n1,n2,n3)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none


      integer n1, n2, n3
      double precision z(n1,n2,n3)
      integer i1, i2, i3

!$omp parallel do default(shared) private(i1,i2,i3)
      do  i3=1,n3
         do  i2=1,n2
            do  i1=1,n1
               z(i1,i2,i3)=0.0D0
            enddo
         enddo
      enddo

      return
      end


c----- end of program ------------------------------------------------
