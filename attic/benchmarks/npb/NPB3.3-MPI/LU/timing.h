c---------------------------------------------------------------------

      integer t_total, t_rhs, t_blts, t_buts, t_jacld, t_jacu,
     >        t_exch, t_lcomm, t_ucomm, t_rcomm, t_last
      parameter (t_total=1, t_rhs=2, t_blts=3, t_buts=4, t_jacld=5, 
     >        t_jacu=6, t_exch=7, t_lcomm=8, t_ucomm=9, t_rcomm=10, 
     >        t_last=10)

      double precision maxtime
      logical timeron
      common/timer/maxtime, timeron
