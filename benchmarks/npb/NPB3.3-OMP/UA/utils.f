c------------------------------------------------------------------
      subroutine reciprocal (a, n)
c------------------------------------------------------------------
c     initialize double precision array a with length of n
c------------------------------------------------------------------

      implicit none

      integer n, i
      double precision a(n)

c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(I)
      do i = 1, n
        a(i) = 1.d0/a(i)
      end do
c$OMP END PARALLEL DO

      return
      end
c------------------------------------------------------------------
      subroutine r_init_omp (a, n, const)
c------------------------------------------------------------------
c     initialize double precision array a with length of n
c------------------------------------------------------------------

      implicit none

      integer n, i
      double precision a(n), const

c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(I)
      do i = 1, n
        a(i) = const
      end do
c$OMP END PARALLEL DO

      return
      end
c------------------------------------------------------------------
      subroutine r_init (a, n, const)
c------------------------------------------------------------------
c     initialize double precision array a with length of n
c------------------------------------------------------------------

      implicit none

      integer n, i
      double precision a(n), const

      do i = 1, n
        a(i) = const
      end do

      return
      end
c------------------------------------------------------------------
      subroutine nr_init_omp (a, n, const)
c------------------------------------------------------------------
c     initialize integer array a with length of n
c------------------------------------------------------------------

      implicit none

      integer n, i, a(n), const

c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(I)
      do i = 1, n
        a(i) = const
      end do
c$OMP END PARALLEL DO

      return
      end

c------------------------------------------------------------------
      subroutine nr_init (a, n, const)
c------------------------------------------------------------------
c     initialize integer array a with length of n
c------------------------------------------------------------------

      implicit none

      integer n, i, a(n), const

      do i = 1, n
        a(i) = const
      end do

      return
      end
c------------------------------------------------------------------
      subroutine l_init_omp (a, n, const)
c------------------------------------------------------------------
c     initialize integer array a with length of n
c------------------------------------------------------------------

      implicit none
      integer n, i
      logical a(n), const

c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(I)
      do i = 1, n
        a(i) = const
      end do
c$OMP END PARALLEL DO

      return
      end

c-----------------------------------------------------------------
      subroutine ncopy (a,b,n)
c------------------------------------------------------------------
c     copy array of integers b to a, the length of array is n
c------------------------------------------------------------------

      implicit none

      integer n,i
      integer a(n), b(n)

      do i = 1, n
        a(i) = b(i)
      end do

      return
      end

c-----------------------------------------------------------------
      subroutine copy (a,b,n)
c------------------------------------------------------------------
c     copy double precision array b to a, the length of array is n
c------------------------------------------------------------------

      implicit none

      integer n,i
      double precision a(n), b(n)

      do i = 1, n
         a(i) = b(i)
      end do

      return
      end

c-----------------------------------------------------------------
      subroutine adds2m1(a,b,c1,n)
c-----------------------------------------------------------------
c     a=b*c1
c-----------------------------------------------------------------
      implicit none

      integer n,i
      double precision a(n),b(n),c1
c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(i)
      do i=1,n
        a(i)=a(i)+c1*b(i)
      end do
c$OMP END PARALLEL DO

      return
      end

c-----------------------------------------------------------------
      subroutine adds1m1(a,b,c1,n )
c-----------------------------------------------------------------
c     a=c1*a+b
c-----------------------------------------------------------------

      implicit none

      integer n,i
      double precision a(n),b(n),c1
c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(i)
      do i=1,n
        a(i)=c1*a(i)+b(i)
      end do
c$OMP END PARALLEL DO

      return
      end

c-----------------------------------------------------------------
      subroutine col2(a,b,n)
c------------------------------------------------------------------
c     a=a*b
c------------------------------------------------------------------

      implicit none

      integer n,i
      double precision a(n),b(n)

c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(i)
      do i=1,n
        a(i)=a(i)*b(i)
      end do
c$OMP END PARALLEL DO

      return
      end

c-----------------------------------------------------------------
      subroutine nrzero (na,n)
c------------------------------------------------------------------
c     zero out array of integers 
c------------------------------------------------------------------

      implicit none

      integer n,i,na(n)

      do i = 1, n
        na(i ) = 0
      end do

      return
      end

c-----------------------------------------------------------------
      subroutine add2(a,b,n)
c------------------------------------------------------------------
c     a=a+b
c------------------------------------------------------------------

      implicit none

      integer n,i
      double precision  a(n),b(n)
c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(i)
      do i=1,n
        a(i)=a(i)+b(i)
      end do
c$OMP END PARALLEL DO

      return
      end

c-----------------------------------------------------------------
      double precision function calc_norm()
c------------------------------------------------------------------
c     calculate the integral of ta1 over the whole domain
c------------------------------------------------------------------

      include 'header.h'

      double precision total,ieltotal
      integer iel,k,j,i,isize

      total=0.d0
c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(i,j,k,isize,ieltotal,iel)
c$OMP& REDUCTION(+:total)

      do iel=1,nelt
        ieltotal=0.d0
        isize=size_e(iel)
        do k=1,lx1
          do j=1,lx1
            do i=1,lx1
              ieltotal=ieltotal+ta1(i,j,k,iel)*w3m1(i,j,k)
     &                               *jacm1_s(i,j,k,isize)
            end do
          end do
        end do
      total=total+ieltotal
      end do
c$OMP END PARALLEL DO

      calc_norm = total

      return
      end
c-----------------------------------------------------------------
      subroutine parallel_add(frontier)
c-----------------------------------------------------------------
c     input array frontier, perform (potentially) parallel add so that
c     the output frontier(i) has sum of frontier(1)+frontier(2)+...+frontier(i)
c-----------------------------------------------------------------
      include 'header.h'
      integer nellog,i,ahead,ii,ntemp,n1,ntemp1,frontier(lelt),iel

      nellog=0
      iel=1
   10 iel=iel*2
      nellog=nellog+1
      if (iel.lt.nelt) goto 10

      ntemp=1
      do i=1,nellog
        n1=ntemp*2
c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(ahead,ii,iel)
        do iel=n1, nelt,n1
          ahead=frontier(iel-ntemp)
          do ii=ntemp-1,0,-1
            frontier(iel-ii)=frontier(iel-ii)+ahead
          end do
        end do
c$OMP END PARALLEL DO

        iel=(nelt/n1+1)*n1
        ntemp1=iel-nelt
        if(ntemp1.lt.ntemp)then
          ahead=frontier(iel-ntemp)
c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(ii)
          do ii=ntemp-1,ntemp1,-1
            frontier(iel-ii)=frontier(iel-ii)+ahead
          end do
c$OMP END PARALLEL DO
        end if

        ntemp=n1
      end do

      return
      end 

c------------------------------------------------------------------
      subroutine dssum

c------------------------------------------------------------------
c     Perform stiffness summation: element-mortar-element mapping
c------------------------------------------------------------------

      include 'header.h'

      call transfb(dpcmor,dpcelm)
      call transf (dpcmor,dpcelm)

      return
      end

c------------------------------------------------------------------
      subroutine facev(a,iface,val)
c------------------------------------------------------------------
c     assign the value val to face(iface,iel) of array a.
c------------------------------------------------------------------
      include 'header.h'

      double precision a(lx1,lx1,lx1), val
      integer iface, kx1, kx2, ky1, ky2, kz1, kz2, ix, iy, iz

      kx1=1
      ky1=1
      kz1=1
      kx2=lx1
      ky2=lx1
      kz2=lx1
      if (iface.eq.1) kx1=lx1
      if (iface.eq.2) kx2=1
      if (iface.eq.3) ky1=lx1
      if (iface.eq.4) ky2=1
      if (iface.eq.5) kz1=lx1
      if (iface.eq.6) kz2=1

      do ix = kx1, kx2
        do iy = ky1, ky2
          do iz = kz1, kz2
            a(ix,iy,iz)=val
          end do
        end do
      end do

      return
      end


