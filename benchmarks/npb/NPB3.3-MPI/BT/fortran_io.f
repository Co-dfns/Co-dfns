
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine setup_btio

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      include 'header.h'
      include 'mpinpb.h'

      character*(128) newfilenm
      integer m, ierr

      if (node.eq.root) record_length = 40/fortran_rec_sz
      call mpi_bcast(record_length, 1, MPI_INTEGER,
     >                root, comm_setup, ierr)

      open (unit=99, file=filenm,
     $      form='unformatted', access='direct',
     $      recl=record_length)

      do m = 1, 5
         xce_sub(m) = 0.d0
      end do

      idump_sub = 0

      return
      end


c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine output_timestep

c---------------------------------------------------------------------
c---------------------------------------------------------------------
      include 'header.h'
      include 'mpinpb.h'

      integer ix, jio, kio, cio

      do cio=1,ncells
          do kio=0, cell_size(3,cio)-1
              do jio=0, cell_size(2,cio)-1
                  iseek=(cell_low(1,cio) +
     $                   PROBLEM_SIZE*((cell_low(2,cio)+jio) +
     $                   PROBLEM_SIZE*((cell_low(3,cio)+kio) +
     $                   PROBLEM_SIZE*idump_sub)))

                  do ix=0,cell_size(1,cio)-1
                      write(99, rec=iseek+ix+1)
     $                      u(1,ix, jio,kio,cio),
     $                      u(2,ix, jio,kio,cio),
     $                      u(3,ix, jio,kio,cio),
     $                      u(4,ix, jio,kio,cio),
     $                      u(5,ix, jio,kio,cio)
                  enddo
              enddo
          enddo
      enddo

      idump_sub = idump_sub + 1
      if (rd_interval .gt. 0) then
         if (idump_sub .ge. rd_interval) then

            call acc_sub_norms(idump+1)

            idump_sub = 0
         endif
      endif

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine acc_sub_norms(idump_cur)

      include 'header.h'
      include 'mpinpb.h'

      integer idump_cur

      integer ix, jio, kio, cio, ii, m, ichunk
      double precision xce_single(5)

      ichunk = idump_cur - idump_sub + 1
      do ii=0, idump_sub-1
        do cio=1,ncells
          do kio=0, cell_size(3,cio)-1
              do jio=0, cell_size(2,cio)-1
                  iseek=(cell_low(1,cio) +
     $                   PROBLEM_SIZE*((cell_low(2,cio)+jio) +
     $                   PROBLEM_SIZE*((cell_low(3,cio)+kio) +
     $                   PROBLEM_SIZE*ii)))


                  do ix=0,cell_size(1,cio)-1
                      read(99, rec=iseek+ix+1)
     $                      u(1,ix, jio,kio,cio),
     $                      u(2,ix, jio,kio,cio),
     $                      u(3,ix, jio,kio,cio),
     $                      u(4,ix, jio,kio,cio),
     $                      u(5,ix, jio,kio,cio)
                  enddo
              enddo
          enddo
        enddo

        if (node .eq. root) print *, 'Reading data set ', ii+ichunk

        call error_norm(xce_single)
        do m = 1, 5
           xce_sub(m) = xce_sub(m) + xce_single(m)
        end do
      enddo

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine btio_cleanup

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      close(unit=99)

      return
      end

c---------------------------------------------------------------------
c---------------------------------------------------------------------

      subroutine accumulate_norms(xce_acc)

c---------------------------------------------------------------------
c---------------------------------------------------------------------
      include 'header.h'
      include 'mpinpb.h'

      double precision xce_acc(5)
      integer m

      if (rd_interval .gt. 0) goto 20

      open (unit=99, file=filenm,
     $      form='unformatted', access='direct',
     $      recl=record_length)

c     clear the last time step

      call clear_timestep

c     read back the time steps and accumulate norms

      call acc_sub_norms(idump)

      close(unit=99)

 20   continue
      do m = 1, 5
         xce_acc(m) = xce_sub(m) / dble(idump)
      end do

      return
      end
