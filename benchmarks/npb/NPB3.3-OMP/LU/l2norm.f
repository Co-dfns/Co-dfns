
c---------------------------------------------------------------------
c---------------------------------------------------------------------
      subroutine l2norm ( ldx, ldy, ldz, 
     >                    nx0, ny0, nz0,
     >                    ist, iend, 
     >                    jst, jend,
     >                    v, sum )
c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c   to compute the l2-norm of vector v.
c---------------------------------------------------------------------

      implicit none


c---------------------------------------------------------------------
c  input parameters
c---------------------------------------------------------------------
      integer ldx, ldy, ldz
      integer nx0, ny0, nz0
      integer ist, iend
      integer jst, jend
c---------------------------------------------------------------------
c   To improve cache performance, second two dimensions padded by 1 
c   for even number sizes only.  Only needed in v.
c---------------------------------------------------------------------
      double precision  v(5,ldx/2*2+1,ldy/2*2+1,*), sum(5)

c---------------------------------------------------------------------
c  local variables
c---------------------------------------------------------------------
      double precision  sum_local(5)
      integer i, j, k, m


      do m = 1, 5
         sum(m) = 0.0d+00
      end do

!$omp parallel default(shared) private(i,j,k,m,sum_local)
      do m = 1, 5
         sum_local(m) = 0.0d+00
      end do
!$omp do
      do k = 2, nz0-1
         do j = jst, jend
            do i = ist, iend
               do m = 1, 5
                  sum_local(m) = sum_local(m) + v(m,i,j,k)*v(m,i,j,k)
               end do
            end do
         end do
      end do
!$omp end do nowait
      do m = 1, 5
!$omp atomic
         sum(m) = sum(m) + sum_local(m)
      end do
!$omp end parallel

      do m = 1, 5
         sum(m) = sqrt ( sum(m) / ( (nx0-2)*(ny0-2)*(nz0-2) ) )
      end do

      return
      end
