
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine exchange_5(g,ibeg,ifin1)

c---------------------------------------------------------------------
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c   compute the right hand side based on exact solution
c---------------------------------------------------------------------

      implicit none

      include 'mpinpb.h'
      include 'applu.incl'

c---------------------------------------------------------------------
c  input parameters
c---------------------------------------------------------------------
      double precision  g(0:isiz2+1,0:isiz3+1)
      integer ibeg, ifin1

c---------------------------------------------------------------------
c  local variables
c---------------------------------------------------------------------
      integer k
      double precision  dum(1024)

      integer msgid1
      integer STATUS(MPI_STATUS_SIZE)
      integer IERROR



c---------------------------------------------------------------------
c   communicate in the south and north directions
c---------------------------------------------------------------------

c---------------------------------------------------------------------
c   receive from south
c---------------------------------------------------------------------
      if (ifin1.eq.nx) then
        call MPI_IRECV( dum,
     >                  nz,
     >                  dp_type,
     >                  south,
     >                  from_s,
     >                  MPI_COMM_WORLD,
     >                  msgid1,
     >                  IERROR )

        call MPI_WAIT( msgid1, STATUS, IERROR )

        do k = 1,nz
          g(nx+1,k) = dum(k)
        end do

      end if

c---------------------------------------------------------------------
c   send north
c---------------------------------------------------------------------
      if (ibeg.eq.1) then
        do k = 1,nz
          dum(k) = g(1,k)
        end do

        call MPI_SEND( dum,
     >                 nz,
     >                 dp_type,
     >                 north,
     >                 from_s,
     >                 MPI_COMM_WORLD,
     >                 IERROR )

      end if

      return
      end     
