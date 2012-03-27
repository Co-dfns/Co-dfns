
c---------------------------------------------------------------------
c---------------------------------------------------------------------

      implicit none

c---------------------------------------------------------------------
c The following include file is generated automatically by the
c "setparams" utility. It defines 
c      problem_size:  12, 64, 102, 162 (for class T, A, B, C)
c      dt_default:    default time step for this problem size if no
c                     config file
c      niter_default: default number of iterations for this problem size
c---------------------------------------------------------------------

      include 'npbparams.h'

      integer           grid_points(3), nx2, ny2, nz2
      common /global/   grid_points, nx2, ny2, nz2, timeron

      double precision  tx1, tx2, tx3, ty1, ty2, ty3, tz1, tz2, tz3, 
     >                  dx1, dx2, dx3, dx4, dx5, dy1, dy2, dy3, dy4, 
     >                  dy5, dz1, dz2, dz3, dz4, dz5, dssp, dt, 
     >                  ce(5,13), dxmax, dymax, dzmax, xxcon1, xxcon2, 
     >                  xxcon3, xxcon4, xxcon5, dx1tx1, dx2tx1, dx3tx1,
     >                  dx4tx1, dx5tx1, yycon1, yycon2, yycon3, yycon4,
     >                  yycon5, dy1ty1, dy2ty1, dy3ty1, dy4ty1, dy5ty1,
     >                  zzcon1, zzcon2, zzcon3, zzcon4, zzcon5, dz1tz1, 
     >                  dz2tz1, dz3tz1, dz4tz1, dz5tz1, dnxm1, dnym1, 
     >                  dnzm1, c1c2, c1c5, c3c4, c1345, conz1, c1, c2, 
     >                  c3, c4, c5, c4dssp, c5dssp, dtdssp, dttx1, bt,
     >                  dttx2, dtty1, dtty2, dttz1, dttz2, c2dttx1, 
     >                  c2dtty1, c2dttz1, comz1, comz4, comz5, comz6, 
     >                  c3c4tx3, c3c4ty3, c3c4tz3, c2iv, con43, con16

      common /constants/ tx1, tx2, tx3, ty1, ty2, ty3, tz1, tz2, tz3,
     >                  dx1, dx2, dx3, dx4, dx5, dy1, dy2, dy3, dy4, 
     >                  dy5, dz1, dz2, dz3, dz4, dz5, dssp, dt, 
     >                  ce, dxmax, dymax, dzmax, xxcon1, xxcon2, 
     >                  xxcon3, xxcon4, xxcon5, dx1tx1, dx2tx1, dx3tx1,
     >                  dx4tx1, dx5tx1, yycon1, yycon2, yycon3, yycon4,
     >                  yycon5, dy1ty1, dy2ty1, dy3ty1, dy4ty1, dy5ty1,
     >                  zzcon1, zzcon2, zzcon3, zzcon4, zzcon5, dz1tz1, 
     >                  dz2tz1, dz3tz1, dz4tz1, dz5tz1, dnxm1, dnym1, 
     >                  dnzm1, c1c2, c1c5, c3c4, c1345, conz1, c1, c2, 
     >                  c3, c4, c5, c4dssp, c5dssp, dtdssp, dttx1, bt,
     >                  dttx2, dtty1, dtty2, dttz1, dttz2, c2dttx1, 
     >                  c2dtty1, c2dttz1, comz1, comz4, comz5, comz6, 
     >                  c3c4tx3, c3c4ty3, c3c4tz3, c2iv, con43, con16

      integer IMAX, JMAX, KMAX, IMAXP, JMAXP

      parameter (IMAX=problem_size,JMAX=problem_size,KMAX=problem_size)
      parameter (IMAXP=IMAX/2*2,JMAXP=JMAX/2*2)

c---------------------------------------------------------------------
c   To improve cache performance, first two dimensions padded by 1 
c   for even number sizes only
c---------------------------------------------------------------------
      double precision 
     >   u       (5, 0:IMAXP, 0:JMAXP, 0:KMAX-1),
     >   us      (   0:IMAXP, 0:JMAXP, 0:KMAX-1),
     >   vs      (   0:IMAXP, 0:JMAXP, 0:KMAX-1),
     >   ws      (   0:IMAXP, 0:JMAXP, 0:KMAX-1),
     >   qs      (   0:IMAXP, 0:JMAXP, 0:KMAX-1),
     >   rho_i   (   0:IMAXP, 0:JMAXP, 0:KMAX-1),
     >   speed   (   0:IMAXP, 0:JMAXP, 0:KMAX-1),
     >   square  (   0:IMAXP, 0:JMAXP, 0:KMAX-1),
     >   rhs     (5, 0:IMAXP, 0:JMAXP, 0:KMAX-1),
     >   forcing (5, 0:IMAXP, 0:JMAXP, 0:KMAX-1)

      common /fields/  u, us, vs, ws, qs, rho_i, speed, square, 
     >                 rhs, forcing

      double precision cv(0:problem_size-1),   rhon(0:problem_size-1),
     >                 rhos(0:problem_size-1), rhoq(0:problem_size-1),
     >                 cuf(0:problem_size-1),  q(0:problem_size-1),
     >                 ue(0:problem_size-1,5), buf(0:problem_size-1,5)
      common /work_1d/ cv, rhon, rhos, rhoq, cuf, q, ue, buf
!$omp threadprivate(/work_1d/)

      double precision
     >   lhs (5,0:IMAXP,0:IMAXP),
     >   lhsp(5,0:IMAXP,0:IMAXP),
     >   lhsm(5,0:IMAXP,0:IMAXP)
      common /work_lhs/ lhs, lhsp, lhsm
!$omp threadprivate(/work_lhs/)

c-----------------------------------------------------------------------
c   Timer constants
c-----------------------------------------------------------------------
      integer t_rhsx,t_rhsy,t_rhsz,t_xsolve,t_ysolve,t_zsolve,
     >        t_rdis1,t_rdis2,t_tzetar,t_ninvr,t_pinvr,t_add,
     >        t_rhs,t_txinvr,t_last,t_total
      logical timeron
      parameter (t_total = 1)
      parameter (t_rhsx = 2)
      parameter (t_rhsy = 3)
      parameter (t_rhsz = 4)
      parameter (t_rhs = 5)
      parameter (t_xsolve = 6)
      parameter (t_ysolve = 7)
      parameter (t_zsolve = 8)
      parameter (t_rdis1 = 9)
      parameter (t_rdis2 = 10)
      parameter (t_txinvr = 11)
      parameter (t_pinvr = 12)
      parameter (t_ninvr = 13)
      parameter (t_tzetar = 14)
      parameter (t_add = 15)
      parameter (t_last = 15)

