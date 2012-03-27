c---------------------------------------------------------------------
c---------------------------------------------------------------------
c
c  header.h
c
c---------------------------------------------------------------------
c---------------------------------------------------------------------
c
      double precision fjac(5, 5,    0:problem_size, 0:problem_size),
     >                 njac(5, 5,    0:problem_size, 0:problem_size),
     >                 lhs (5, 5, 3, 0:problem_size, 0:problem_size),
     >                 tmp1, tmp2, tmp3
      common /work_lhs/ fjac, njac, lhs, tmp1, tmp2, tmp3
