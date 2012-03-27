c-----------------------------------------------------------------
      subroutine create_initial_grid        
c------------------------------------------------------------------
    
      include 'header.h'

      integer i

      nelt=1
      ntot=nelt*lx1*lx1*lx1 
      tree(1)=1
      mt_to_id(1)=1
      do i=1,7,2
        xc(i,1)=0.d0
        xc(i+1,1)=1.d0
      end do

      do i=1,2
        yc(i,1)=0.d0
        yc(2+i,1)=1.d0
        yc(4+i,1)=0.d0
        yc(6+i,1)=1.d0
      end do
     
      do i=1,4
        zc(i,1)=0.d0
        zc(4+i,1)=1.d0
      end do
  
      do i=1,6
        cbc(i,1)=0
      end do

      return

      end

c-----------------------------------------------------------------
      subroutine coef
c-----------------------------------------------------------------
c
c     generate 
c
c            - collocation points
c            - weights
c            - derivative matrices 
c            - projection matrices
c            - interpolation matrices 
c
c     associated with the 
c
c            - gauss-legendre lobatto mesh (suffix m1)
c
c----------------------------------------------------------------

      include 'header.h'

      integer i,j,k

c.....for gauss-legendre lobatto mesh (suffix m1)
c.....generate collocation points and weights 

      zgm1(1)=-1.d0
      zgm1(2)=-0.6546536707079771d0
      zgm1(3)=0.d0
      zgm1(4)= 0.6546536707079771d0
      zgm1(5)=1.d0
      wxm1(1)=0.1d0
      wxm1(2)=49.d0/90.d0
      wxm1(3)=32.d0/45.d0
      wxm1(4)=wxm1(2)
      wxm1(5)=0.1d0 

      do k=1,lx1
        do j=1,lx1
          do i=1,lx1
            w3m1(i,j,k)=wxm1(i)*wxm1(j)*wxm1(k)
          end do
        end do
      end do

c.....generate derivative matrices

      dxm1(1,1)=-5.0d0
      dxm1(2,1)=-1.240990253030982d0
      dxm1(3,1)= 0.375d0
      dxm1(4,1)=-0.2590097469690172d0
      dxm1(5,1)= 0.5d0
      dxm1(1,2)= 6.756502488724238d0
      dxm1(2,2)= 0.d0
      dxm1(3,2)=-1.336584577695453d0
      dxm1(4,2)= 0.7637626158259734d0
      dxm1(5,2)=-1.410164177942427d0
      dxm1(1,3)=-2.666666666666667d0
      dxm1(2,3)= 1.745743121887939d0
      dxm1(3,3)= 0.d0
      dxm1(4,3)=-dxm1(2,3)
      dxm1(5,3)=-dxm1(1,3)
      do j=4,lx1
        do i=1,lx1
          dxm1(i,j)=-dxm1(lx1+1-i,lx1+1-j)
        end do
      end do
      do j=1,lx1
        do i=1,lx1
          dxtm1(i,j)=dxm1(j,i)
        end do
      end do

c.....generate projection (mapping) matrices

      qbnew(1,1,1)=-0.1772843218615690d0
      qbnew(2,1,1)=9.375d-02
      qbnew(3,1,1)=-3.700139242414530d-02
      qbnew(1,2,1)= 0.7152146412463197d0
      qbnew(2,2,1)=-0.2285757930375471d0
      qbnew(3,2,1)= 8.333333333333333d-02
      qbnew(1,3,1)= 0.4398680650316104d0
      qbnew(2,3,1)= 0.2083333333333333d0
      qbnew(3,3,1)=-5.891568407922938d-02
      qbnew(1,4,1)= 8.333333333333333d-02
      qbnew(2,4,1)= 0.3561799597042137d0
      qbnew(3,4,1)=-4.854797457965334d-02
      qbnew(1,5,1)= 0.d0
      qbnew(2,5,1)=7.03125d-02
      qbnew(3,5,1)=0.d0
      
      do j=1,lx1
        do i=1,3
          qbnew(i,j,2)=qbnew(4-i,lx1+1-j,1)
        end do
      end do 

c.....generate interpolation matrices for mesh refinement

      ixtmc1(1,1)=1.d0
      ixtmc1(2,1)=0.d0
      ixtmc1(3,1)=0.d0
      ixtmc1(4,1)=0.d0
      ixtmc1(5,1)=0.d0 
      ixtmc1(1,2)= 0.3385078435248143d0
      ixtmc1(2,2)= 0.7898516348912331d0
      ixtmc1(3,2)=-0.1884018684471238d0
      ixtmc1(4,2)= 9.202967302175333d-02
      ixtmc1(5,2)=-3.198728299067715d-02
      ixtmc1(1,3)=-0.1171875d0
      ixtmc1(2,3)= 0.8840317166357952d0
      ixtmc1(3,3)= 0.3125d0    
      ixtmc1(4,3)=-0.118406716635795d0 
      ixtmc1(5,3)= 0.0390625d0   
      ixtmc1(1,4)=-7.065070066767144d-02
      ixtmc1(2,4)= 0.2829703269782467d0 
      ixtmc1(3,4)= 0.902687582732838d0
      ixtmc1(4,4)=-0.1648516348912333d0 
      ixtmc1(5,4)= 4.984442584781999d-02
      ixtmc1(1,5)=0.d0
      ixtmc1(2,5)=0.d0
      ixtmc1(3,5)=1.d0 
      ixtmc1(4,5)=0.d0
      ixtmc1(5,5)=0.d0  
      do j=1,lx1
        do i=1,lx1
          ixmc1(i,j)=ixtmc1(j,i)
        end do
      end do

      do j=1,lx1
        do i=1,lx1
          ixtmc2(i,j)=ixtmc1(lx1+1-i,lx1+1-j)
        end do
      end do

      do j=1,lx1
        do i=1,lx1
          ixmc2(i,j)=ixtmc2(j,i)
        end do
      end do

c.....solution interpolation matrix for mesh coarsening

      map2(1)=-0.1179652785083428d0
      map2(2)= 0.5505046330389332d0
      map2(3)= 0.7024534364259963d0
      map2(4)=-0.1972224518285866d0
      map2(5)= 6.222966087199998d-02

      do i=1,lx1
        map4(i)=map2(lx1+1-i)
      end do

      return
      end

c-------------------------------------------------------------------
      subroutine geom1
c-------------------------------------------------------------------
c
c     routine to generate elemental geometry information on mesh m1,
c     (gauss-legendre lobatto mesh).
c
c         xrm1_s   -   dx/dr, dy/dr, dz/dr
c         rxm1_s   -   dr/dx, dr/dy, dr/dz
c         g1m1_s  geometric factors used in preconditioner computation
c         g4m1_s  g5m1_s  g6m1_s :
c         geometric factors used in lapacian opertor
c         jacm1    -   jacobian
c         bm1      -   mass matrix
c         xfrac    -   will be used in prepwork for calculating collocation
c                      coordinates
c         idel     -   collocation points index on element boundaries 
c------------------------------------------------------------------

      include 'header.h'

      double precision temp,temp1,temp2,dtemp
      integer isize,i,j,k,ntemp,iel
 
      do i=1,lx1
        xfrac(i)=zgm1(i)*0.5d0 + 0.5d0
      end do

c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(ISIZE,TEMP,TEMP1,TEMP2,
c$OMP&  K,J,I,dtemp)
      do isize=1,refine_max
        temp=2.d0**(-isize-1)
        dtemp=1.d0/temp
        temp1=temp**3
        temp2=temp**2
        do k=1,lx1
          do j=1,lx1
            do i=1,lx1
              xrm1_s(i,j,k,isize)=dtemp
              jacm1_s(i,j,k,isize)=temp1
              rxm1_s(i,j,k,isize)=temp2
              g1m1_s(i,j,k,isize)=w3m1(i,j,k)*temp
              bm1_s(i,j,k,isize)=w3m1(i,j,k)*temp1
              g4m1_s(i,j,k,isize)=g1m1_s(i,j,k,isize)/wxm1(i)
              g5m1_s(i,j,k,isize)=g1m1_s(i,j,k,isize)/wxm1(j)
              g6m1_s(i,j,k,isize)=g1m1_s(i,j,k,isize)/wxm1(k)
            end do
          end do
        end do
      end do
c$OMP END PARALLEL DO

c$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(ntemp,i,j,iel)
      do iel = 1, lelt
        ntemp=lx1*lx1*lx1*(iel-1)
        do j = 1, lx1
          do i = 1, lx1
            idel(i,j,1,iel)=ntemp+(i-1)*lx1 + (j-1)*lx1*lx1+lx1
            idel(i,j,2,iel)=ntemp+(i-1)*lx1 + (j-1)*lx1*lx1+1
            idel(i,j,3,iel)=ntemp+(i-1)*1 + (j-1)*lx1*lx1+lx1*(lx1-1)+1
            idel(i,j,4,iel)=ntemp+(i-1)*1 + (j-1)*lx1*lx1+1
            idel(i,j,5,iel)=ntemp+(i-1)*1 + (j-1)*lx1+lx1*lx1*(lx1-1)+1
            idel(i,j,6,iel)=ntemp+(i-1)*1 + (j-1)*lx1+1
          end do
        end do
      end do
c$OMP END PARALLEL DO

      return
      end

c------------------------------------------------------------------
      subroutine setdef
c------------------------------------------------------------------
c     compute the discrete laplacian operators
c------------------------------------------------------------------

      include 'header.h'

      integer i,j,ip
 
      call r_init(wdtdr(1,1),lx1*lx1,0.d0)

      do i=1,lx1
        do j=1,lx1
          do ip=1,lx1
            wdtdr(i,j) = wdtdr(i,j) + wxm1(ip)*dxm1(ip,i)*dxm1(ip,j)
          end do
        end do
      end do

      return 
      end


c------------------------------------------------------------------
      subroutine prepwork
c------------------------------------------------------------------
c     mesh information preparations: calculate refinement levels of
c     each element, mask matrix for domain boundary and element 
c     boundaries
c------------------------------------------------------------------

      include 'header.h'

      integer i, j, iel, iface, cb
      double precision rdlog2

      ntot = nelt*nxyz
      rdlog2 = 1.d0/dlog(2.d0)

c$OMP PARALLEL DEFAULT(SHARED) PRIVATE(I,J,IEL,IFACE,CB)

c.....calculate the refinement levels of each element

c$OMP DO 
      do iel = 1, nelt
        size_e(iel)=-dlog(xc(2,iel)-xc(1,iel))*rdlog2+1.d-8
      end do
c$OMP END DO nowait

c.....mask matrix for element boundary

c$OMP DO
      do iel = 1, nelt
        call r_init(tmult(1,1,1,iel),nxyz,1.d0)   
        do iface=1,nsides
          call facev(tmult(1,1,1,iel),iface,0.0d0)
        end do
      end do
c$OMP END DO nowait

c.....masks for domain boundary at mortar 

c$OMP DO
      do iel=1,nmor
        tmmor(iel)=1.d0
      end do
c$OMP END DO

c$OMP DO
      do iel = 1, nelt
        do iface = 1,nsides
          cb=cbc(iface,iel)
          if(cb.eq.0) then
            do j=2,lx1-1
              do i=2,lx1-1
               tmmor(idmo(i,j,1,1,iface,iel))=0.d0
              end do
            end do

            j=1
            do i = 1, lx1-1
               tmmor(idmo(i,j,1,1,iface,iel))=0.d0
            end do

            if(idmo(lx1,1,1,1,iface,iel).eq.0)then
              tmmor(idmo(lx1,1,1,2,iface,iel))=0.d0
            else
              tmmor(idmo(lx1,1,1,1,iface,iel))=0.d0
              do i=1,lx1
                tmmor(idmo(i,j,1,2,iface,iel))=0.d0
              end do
            end if

            i=lx1
            if(idmo(lx1,2,1,2,iface,iel).eq.0)then
              do j=2,lx1-1
                tmmor(idmo(i,j,1,1,iface,iel))=0.d0
              end do
              tmmor(idmo(lx1,lx1,2,2,iface,iel))=0.d0
            else
              do j=2,lx1
                tmmor(idmo(i,j,1,2,iface,iel))=0.d0
              end do
              do j=1,lx1
                tmmor(idmo(i,j,2,2,iface,iel))=0.d0
              end do
            end if
            
            j=lx1
            tmmor(idmo(1,lx1,2,1,iface,iel))=0.d0
            if(idmo(2,lx1,2,1,iface,iel).eq.0)then
              do i=2,lx1-1
                tmmor(idmo(i,j,1,1,iface,iel))=0.d0
              end do
            else
              do i=2,lx1
                tmmor(idmo(i,j,2,1,iface,iel))=0.d0
              end do
              do i=1,lx1-1
                tmmor(idmo(i,j,2,2,iface,iel))=0.d0
              end do
            end if

            i=1
            do j=2,lx1-1
             tmmor(idmo(i,j,1,1,iface,iel))=0.d0
            end do
            if(idmo(1,lx1,1,1,iface,iel).ne.0)then
              tmmor(idmo(i,lx1,1,1,iface,iel))=0.d0
              do j=1,lx1-1
               tmmor(idmo(i,j,2,1,iface,iel))=0.d0
              end do
            end if

          endif
        end do
       end do
c$OMP END DO nowait
            
c$OMP END PARALLEL
      return
      end 
    

c------------------------------------------------------------------
      block data top_constants

c------------------------------------------------------------------
c.....We store some tables of useful topological constants
c------------------------------------------------------------------
      include 'header.h'

c     f_e_ef(e,f) returns the other face sharing the e'th local edge of face f.
      data f_e_ef/6,3,5,4, 6,3,5,4, 6,1,5,2, 6,1,5,2, 4,1,3,2, 4,1,3,2/

c.....e_c(n,j) returns n'th edge sharing the vertex j of an element
      data e_c /5,8,11, 1,4,11,  5,6,9, 1,2,9,
     &          7,8,12, 3,4,12, 6,7,10, 2,3,10/

c.....local_corner(n,i) returns the local corner index of vertex n on face i
      data local_corner /0,1,0,2,0,3,0,4, 1,0,2,0,3,0,4,0,
     &                   0,0,1,2,0,0,3,4, 1,2,0,0,3,4,0,0,
     &                   0,0,0,0,1,2,3,4, 1,2,3,4,0,0,0,0/

c.....cal_nnb(n,i) returns the neighbor elements neighbored by n'th edge
c     among the three edges sharing vertex i
c     the elements are the eight children elements ordered as 1 to 8.
      data cal_nnb/5,2,3, 6,1,4, 7,4,1, 8,3,2,
     &             1,6,7, 2,5,8, 3,8,5, 4,7,6/

c.....returns the opposite local corner index: 1-4,2-3
      data oplc /4,3,2,1/

c.....cal_iijj(i,n) returns the location of local corner number n on a face 
c     i =1  to get ii, i=2 to get jj
c     (ii,jj) is defined the same as in mortar location (ii,jj)
      data cal_iijj /1,1, 1,2, 2,1, 2,2/

c.....returns the adjacent(neighbored by a face) element's children,
c     assumming a vertex is shared by eight child elements 1-8. 
c     index n is local corner number on the face which is being 
c     assigned the mortar index number
      data cal_intempx /8,6,4,2, 7,5,3,1, 8,7,4,3, 
     $                  6,5,2,1, 8,7,6,5, 4,3,2,1/

c.....c_f(i,f) returns the vertex number of i'th local corner on face f
      data c_f /2,4,6,8, 1,3,5,7, 3,4,7,8, 1,2,5,6, 5,6,7,8, 1,2,3,4/

c.....on each face of the parent element, there are four children element.
c     le_arr(i,j,n) returns the i'th elements among the four children elements 
c     n refers to the direction: 1 for x, 2 for y and 3 for z direction. 
c     j refers to positive(0) or negative(1) direction on x, y or z direction.
c     n=1,j=0 refers to face 1 and n=1, j=1 refers to face 2, n=2,j=0 refers to
c     face 3.... 
c     The current eight children are ordered as 8,1,2,3,4,5,6,7 
      data    le_arr/8,2,4,6, 1,3,5,7, 
     $               8,1,4,5, 2,3,6,7, 
     $               8,1,2,3, 4,5,6,7/

c.....jjface(n) returns the face opposite to face n
      data jjface /2,1,4,3,6,5/

cc.....edgeface(n,f) returns OTHER face which shares local edge n on face f
c      integer edgeface(4,6)
c      data edgeface /6,3,5,4, 6,3,5,4, 6,1,5,2, 
c     $               6,1,5,2, 4,1,3,2, 4,1,3,2/

c.....e_face2(n,f) returns the local edge number of edge n on the
c     other face sharing local edge n on face f
      data e_face2 /2,2,2,2, 4,4,4,4, 3,2,3,2, 
     $              1,4,1,4, 3,3,3,3, 1,1,1,1/

c.....op(n) returns the local edge number of the edge which 
c     is opposite to local edge n on the same face
      data op /3,4,1,2/

c.....localedgenumber(f,e) returns the local edge number for edge e
c     on face f. A zero result value signifies illegal input
      data localedgenumber /1,0,0,0,0,2, 2,0,2,0,0,0, 3,0,0,0,2,0, 
     $                      4,0,0,2,0,0, 0,1,0,0,0,4, 0,2,4,0,0,0, 
     $                      0,3,0,0,4,0, 0,4,0,4,0,0, 0,0,1,0,0,3, 
     $                      0,0,3,0,3,0, 0,0,0,1,0,1, 0,0,0,3,1,0/

c.....edgenumber(e,f) returns the edge index of local edge e on face f
      data edgenumber / 1,2, 3,4,  5,6, 7,8,  9,2,10,6, 
     $                 11,4,12,8, 12,3,10,7, 11,1, 9,5/

c.....f_c(c,n) returns the face index of i'th face sharing vertex n 
      data f_c /2,4,6, 1,4,6, 2,3,6, 1,3,6,
     &          2,4,5, 1,4,5, 2,3,5, 1,3,5/

c.....if two elements are neighbor by one edge, 
c     e1v1(f1,f2) returns the smaller index of the two vertices on this 
c     edge on one element
c     e1v2 returns the larger index of the two vertices of this edge on 
c     on element. exfor a vertex on element 
c     e2v1 returns the smaller index of the two vertices on this edge on 
c     another element
c     e2v2 returns the larger index of the two vertiex on this edge on
c     another element
      data e1v1/0,0,4,2,6,2, 0,0,3,1,5,1, 4,3,0,0,7,3,
     &          2,1,0,0,5,1, 6,5,7,5,0,0, 2,1,3,1,0,0/
      data e2v1/0,0,1,3,1,5, 0,0,2,4,2,6, 1,2,0,0,1,5,
     &          3,4,0,0,3,7, 1,2,1,3,0,0, 5,6,5,7,0,0/
      data e1v2/0,0,8,6,8,4, 0,0,7,5,7,3, 8,7,0,0,8,4,
     &          6,5,0,0,6,2, 8,7,8,6,0,0, 4,3,4,2,0,0/
      data e2v2/0,0,5,7,3,7, 0,0,6,8,4,8, 5,6,0,0,2,6,
     &          7,8,0,0,4,8, 3,4,2,4,0,0, 7,8,6,8,0,0/

c.....children(n1,n)returns the four elements among the eight children 
c     elements to be merged on face n of the parent element
c     the IDs for the eight children are 1,2,3,4,5,6,7,8
      data children/2,4,6,8, 1,3,5,7, 3,4,7,8, 
     &              1,2,5,6, 5,6,7,8, 1,2,3,4/

c.....iijj(n1,n) returns the location of n's mortar on an element face
c     n1=1 refers to x direction location and n1=2 refers to y direction
      data iijj/1,1,1,2,2,1,2,2/

c.....v_end(n) returns the index of collocation points at two ends of each
c     direction
      data v_end /1,lx1/

c.....face_l1,face_l2,face_ld return for start,end,stride for a loop over faces 
c     used on subroutine  mortar_vertex
      data face_l1 /2,3,1/, face_l2 /3,1,2/, face_ld /1,-2,1/

      end
