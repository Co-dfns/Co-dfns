
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      include 'mpif.h'

      integer           node, no_nodes, total_nodes, root, comm_setup, 
     >                  comm_solve, comm_rhs, dp_type
      logical           active
      common /mpistuff/ node, no_nodes, total_nodes, root, comm_setup, 
     >                  comm_solve, comm_rhs, dp_type, active

