
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      include 'mpif.h'

      integer           node, no_nodes, root, comm_setup, 
     >                  comm_solve, comm_rhs, dp_type
      common /mpistuff/ node, no_nodes, root, comm_setup, 
     >                  comm_solve, comm_rhs, dp_type

