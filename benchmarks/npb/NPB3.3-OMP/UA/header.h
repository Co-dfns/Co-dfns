      implicit none

      include 'npbparams.h'

c.....Array dimensions     
      integer lx1, lnje, nsides, nxyz
      parameter(lx1=5, lnje=2, nsides=6,  nxyz=lx1*lx1*lx1)

      integer fre, niter, nmxh
      double precision alpha, dlmin, dtime
      common /usrdati/ fre, niter, nmxh
      common /usrdatr/ alpha, dlmin, dtime

      integer nelt, ntot, nmor, nvertex
      common /dimn/ nelt,ntot, nmor, nvertex

      double precision x0, y0, z0, time
      common /bench1/time, x0, y0, z0

      double precision velx, vely, velz, visc, x00, y00, z00
      parameter(velx=3.d0, vely=3.d0, velz=3.d0)
      parameter(visc=0.005d0)
      parameter(x00=3.d0/7.d0, y00=2.d0/7.d0, z00=2.d0/7.d0)

c.....double precision arrays associated with collocation points
      double precision
     &       ta1  (lx1,lx1,lx1,lelt), ta2   (lx1,lx1,lx1,lelt),
     &       trhs (lx1,lx1,lx1,lelt), t     (lx1,lx1,lx1,lelt), 
     &       tmult(lx1,lx1,lx1,lelt), dpcelm(lx1,lx1,lx1,lelt), 
     &       pdiff(lx1,lx1,lx1,lelt), pdiffp(lx1,lx1,lx1,lelt)
      common /colldp/ ta1, ta2, trhs, t, tmult, dpcelm, pdiff, pdiffp

c.....double precision arays associated with mortar points
      double precision
     &       umor(lmor), mormult(lmor), tmort(lmor), tmmor(lmor), 
     &       rmor(lmor), dpcmor (lmor), pmorx(lmor), ppmor(lmor) 
      common /mortdp/ umor, mormult, tmort,tmmor, rmor, dpcmor, 
     &                pmorx, ppmor

c.... integer arrays associated with element faces
      integer idmo    (lx1,lx1,lnje,lnje,nsides,lelt), 
     &        idel    (lx1,lx1,          nsides,lelt), 
     &        sje     (2,2,              nsides,lelt), 
     &        sje_new (2,2,              nsides,lelt),
     &        ijel    (2,                nsides,lelt), 
     &        ijel_new(2,                nsides,lelt),
     &        cbc     (                  nsides,lelt), 
     &        cbc_new (                  nsides,lelt) 
      common /facein/ idmo, ijel, idel, ijel_new, sje, sje_new, cbc,
     &               cbc_new

c.....integer array associated with vertices
      integer vassign  (8,lelt),      emo(2,8,8*lelt),   
     &        nemo (8*    lelt)
      common /vin/vassign, emo, nemo

c.....integer array associated with element edges
      integer diagn  (2,12,lelt) 
      common /edgein/diagn 

c.... integer arrays associated with elements
      integer tree (      lelt), mt_to_id    (     lelt),                   
     &        newc (      lelt), mt_to_id_old(     lelt),
     &        newi (      lelt), id_to_mt    (     lelt), 
     &        newe (      lelt), ref_front_id(     lelt),
     &        front(      lelt), action      (     lelt), 
     &        ich  (      lelt), size_e      (     lelt),
     &        treenew     (     lelt)
      common /eltin/ tree, treenew,mt_to_id,mt_to_id_old,
     &               id_to_mt, newc, newi, newe, ref_front_id, 
     &               ich, size_e, front, action

c.....logical arrays associated with vertices
      logical ifpcmor  (8* lelt)
      common /vlg/ ifpcmor

c.....logical arrays associated with edge
      logical eassign  (12,lelt),  if_1_edge(12,lelt), 
     &        ncon_edge(12,lelt)
      common /edgelg/ eassign,  ncon_edge, if_1_edge

c.....logical arrays associated with elements
      logical skip (lelt), ifcoa   (lelt), ifcoa_id(lelt)
      common /facelg/ skip, ifcoa, ifcoa_id

c.....logical arrays associated with element faces
      logical fassign(nsides,lelt), edgevis(4,nsides,lelt)      
      common /masonl/ fassign, edgevis

c.....small arrays
      double precision qbnew(lx1-2,lx1,2), bqnew(lx1-2,lx1-2,2)
      common /transr/ qbnew,bqnew

      double precision
     &       pcmor_nc1(lx1,lx1,2,2,refine_max),
     $       pcmor_nc2(lx1,lx1,2,2,refine_max),
     $       pcmor_nc0(lx1,lx1,2,2,refine_max),
     $       pcmor_c(lx1,lx1,refine_max), tcpre(lx1,lx1),
     $       pcmor_cor(8,refine_max)
      common /pcr/ pcmor_nc1,pcmor_c,pcmor_nc0,pcmor_nc2,tcpre, 
     $             pcmor_cor

c.....gauss-labotto and gauss points
      double precision zgm1(lx1)
      common /gauss/ zgm1

c.....weights
      double precision wxm1(lx1),w3m1(lx1,lx1,lx1)
      common /wxyz/ wxm1,w3m1

c.....coordinate of element vertices
      double precision xc(8,lelt),yc(8,lelt),zc(8,lelt),
     $       xc_new(8,lelt),yc_new(8,lelt),zc_new(8,lelt)
      common /coord/ xc,yc,zc,xc_new,yc_new,zc_new

c.....dr/dx, dx/dr  and Jacobian
      double precision jacm1_s(lx1,lx1,lx1,refine_max), 
     $       rxm1_s(lx1,lx1,lx1,refine_max),
     $       xrm1_s(lx1,lx1,lx1,refine_max)
      common /giso/ jacm1_s,xrm1_s, rxm1_s 

c.....mass matrices (diagonal)
      double precision bm1_s(lx1,lx1,lx1,refine_max)
      common /mass/ bm1_s

c.....dertivative matrices d/dr
      double precision dxm1(lx1,lx1), dxtm1(lx1,lx1), wdtdr(lx1,lx1)
      common /dxyz/ dxm1,dxtm1,wdtdr

c.....interpolation operators
      double precision
     $       ixm31(lx1,lx1*2-1), ixtm31(lx1*2-1,lx1), ixmc1(lx1,lx1),  
     $       ixtmc1(lx1,lx1), ixmc2(lx1,lx1),  ixtmc2(lx1,lx1),
     $       map2(lx1),map4(lx1)
      common /ixyz/ ixmc1,ixtmc1,ixmc2,ixtmc2,ixm31,ixtm31,map2,map4

c.....collocation location within an element
      double precision xfrac
      common /xfracs/xfrac(lx1)

c.....used in laplacian operator
      double precision g1m1_s(lx1,lx1,lx1,refine_max), 
     $       g4m1_s(lx1,lx1,lx1,refine_max),
     $       g5m1_s(lx1,lx1,lx1,refine_max),
     $       g6m1_s(lx1,lx1,lx1,refine_max)
      common /gmfact/ g1m1_s,g4m1_s,g5m1_s, g6m1_s
      
c.....We store some tables of useful topological constants
c     These constants are intialized in a block data 'top_constants'
      integer f_e_ef(4,6)
      integer e_c(3,8)
      integer local_corner(8,6)
      integer cal_nnb(3,8)
      integer oplc(4)
      integer cal_iijj(2,4)
      integer cal_intempx(4,6)
      integer c_f(4,6)
      integer le_arr(4,0:1,3)
      integer jjface(6)
      integer e_face2(4,6)
      integer op(4)
      integer localedgenumber(6,12)
      integer edgenumber(4,6)
      integer f_c(3,8)
      integer e1v1(6,6),e2v1(6,6),e1v2(6,6),e2v2(6,6)
      integer children(4,6)
      integer iijj(2,4)
      integer v_end(2)
      integer face_l1(3),face_l2(3),face_ld(3)
      common /top_consts/ f_e_ef,e_c,local_corner,cal_nnb,oplc,
     $       cal_iijj,cal_intempx,c_f,le_arr,jjface,e_face2,op,
     $       localedgenumber,edgenumber,f_c,e1v1,e2v1,e1v2,e2v2,
     $       children,iijj,v_end,face_l1,face_l2,face_ld

c ... Timer parameters
      integer t_total,t_init,t_convect,t_transfb_c,
     &        t_diffusion,t_transf,t_transfb,t_adaptation,
     &        t_transf2,t_add2,t_last
      parameter (t_total=1,t_init=2,t_convect=3,t_transfb_c=4,
     &        t_diffusion=5,t_transf=6,t_transfb=7,t_adaptation=8,
     &        t_transf2=9,t_add2=10,t_last=10)
      logical timeron
      common /timing/timeron

c.....Locks used for atomic updates
cc    integer (kind=omp_lock_kind) tlock(lmor)
c$    integer*8 tlock(lmor)
c$    common /sync_cmn/ tlock
