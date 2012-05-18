c---------------------------------------------------------------------
c---------------------------------------------------------------------
c
c  work_lhs_vec.h
c
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      double precision fjac(5, 5, -2:MAX_CELL_DIM+1, -2:MAX_CELL_DIM+1),
     >                 njac(5, 5, -2:MAX_CELL_DIM+1, -2:MAX_CELL_DIM+1),
     >                 lhsa(5, 5, -1:MAX_CELL_DIM,   -1:MAX_CELL_DIM),
     >                 lhsb(5, 5, -1:MAX_CELL_DIM,   -1:MAX_CELL_DIM),
     >                 tmp1, tmp2, tmp3
      common /work_lhs/ fjac, njac, lhsa, lhsb, tmp1, tmp2, tmp3
