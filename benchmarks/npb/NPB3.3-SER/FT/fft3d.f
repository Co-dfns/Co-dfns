c---------------------------------------------------------------------   
      subroutine Swarztrauber(is,m,vlen,n,x,xd1,exponent)

      implicit none
      include 'global.h'
c---------------------------------------------------------------------
c   Computes NY N-point complex-to-complex FFTs of X using an algorithm due
c   to Swarztrauber.  X is both the input and the output array, while Y is a 
c   scratch array.  It is assumed that N = 2^M.  Before calling 
c   Swarztrauber to 
c   perform FFTs
c---------------------------------------------------------------------
      integer is,m,vlen,n,xd1
      double complex x(xd1,n), exponent(n)      

      integer i,j,l
      double complex u1,x11,x21
      integer k, n1,li,lj,lk,ku,i11,i12,i21,i22
      
      if (timers_enabled) call timer_start(4)
c---------------------------------------------------------------------
c   Perform one variant of the Stockham FFT.
c---------------------------------------------------------------------
      n1 = n / 2
      lj = 1
      li = 2 ** m
      do l = 1, m, 2
        lk = lj
        lj = 2 * lk
        li = li / 2
        ku = li + 1

        do i = 0, li - 1
          i11 = i * lk + 1
          i12 = i11 + n1
          i21 = i * lj + 1
          i22 = i21 + lk
        
          if (is .ge. 1) then
            u1 = exponent(ku+i)
          else
            u1 = dconjg (exponent(ku+i))
          endif
          do k = 0, lk - 1
            do j = 1, vlen
              x11 = x(j,i11+k)
              x21 = x(j,i12+k)
              scr(j,i21+k) = x11 + x21
              scr(j,i22+k) = u1 * (x11 - x21)
            end do
          end do
        end do

        if (l .eq. m) then
          do k = 1, n
            do j = 1, vlen
              x(j,k) = scr(j,k)
            enddo
          enddo
        else
          lk = lj
          lj = 2 * lk
          li = li / 2
          ku = li + 1

          do i = 0, li - 1
            i11 = i * lk + 1
            i12 = i11 + n1
            i21 = i * lj + 1
            i22 = i21 + lk
        
            if (is .ge. 1) then
              u1 = exponent(ku+i)
            else
              u1 = dconjg (exponent(ku+i))
            endif
            do k = 0, lk - 1
              do j = 1, vlen
                x11 = scr(j,i11+k)
                x21 = scr(j,i12+k)
                x(j,i21+k) = x11 + x21
                x(j,i22+k) = u1 * (x11 - x21)
              end do
            end do
          end do
        endif
      end do
      if (timers_enabled) call timer_stop(4)

      return
      end

c---------------------------------------------------------------------
      subroutine fftXYZ(sign,x,xout,exp1,exp2,exp3,n1,n2,n3)
        implicit none
        include 'global.h'
        integer sign,n1,n2,n3
        double complex x(n1+1,n2,n3)
        double complex xout((n1+1)*n2*n3)
        double complex exp1(n1), exp2(n2), exp3(n3)
        integer i, j, k, log
        integer bls,ble
        integer len
        integer blkp

        if (timers_enabled) call timer_start(3)

        fftblock=CacheSize/n1
        if(fftblock.ge.BlockMax) fftblock=BlockMax
        blkp=fftblock+1
        log = ilog2( n1)
        if (timers_enabled) call timer_start(7)
        do k = 1, n3
          do bls = 1, n2, fftblock
            ble = bls + fftblock - 1
            if ( ble .gt. n2) ble = n2
            len=ble-bls+1
            do j = bls, ble
            do i = 1, n1
              plane(j-bls+1+blkp*(i-1)) = x(i,j,k)
            end do
            end do
            call Swarztrauber(sign,log,len,n1,plane,blkp,exp1)     
            do j = bls, ble
            do i = 1, n1
              x(i,j,k)=plane(j-bls+1+blkp*(i-1))
            end do
            end do
          end do
        end do
        if (timers_enabled) call timer_stop(7)

        fftblock=CacheSize/n2
        if(fftblock.ge.BlockMax) fftblock=BlockMax
        blkp=fftblock+1
        log = ilog2( n2 )
        if (timers_enabled) call timer_start(8)
        do k = 1, n3
          do bls = 1, n1, fftblock
            ble = bls + fftblock - 1
            if ( ble .gt. n1) ble = n1
            len=ble-bls+1
            call Swarztrauber(sign,log,len,n2,x(bls,1,k),n1+1,exp2)
          enddo
        end do
        if (timers_enabled) call timer_stop(8)

        fftblock=CacheSize/n3
        if(fftblock.ge.BlockMax) fftblock=BlockMax
        blkp=fftblock+1
        log = ilog2(n3)
        if (timers_enabled) call timer_start(9)
        do k = 1, n2
          do bls = 1, n1, fftblock
            ble = bls + fftblock - 1
            if ( ble .gt. n1) ble = n1
            len=ble-bls+1
            do i = 1,n3
            do j = bls, ble
              plane(j-bls+1+blkp*(i-1)) = x(j,k,i)
            end do
            end do
            call Swarztrauber(sign,log,len,n3,plane,blkp,exp3)
            do i = 0,n3-1
            do j = bls, ble
              xout(j+(n1+1)*(k-1+n2*i)) = plane(j-bls+1+blkp*i)
            end do
            end do
          end do
        end do
        if (timers_enabled) call timer_stop(9)
        if (timers_enabled) call timer_stop(3)
        return
      end
