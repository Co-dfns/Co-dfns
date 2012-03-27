c---------------------------------------------------------------
      subroutine move
c---------------------------------------------------------------
c     move element to proper location in morton space filling curve
c---------------------------------------------------------------

      include 'header.h'

      integer i,iside,jface,iel,ntemp,ii1,ii2,n1,n2,cb


      n2=2*6*nelt
      n1=n2*2
      call nr_init(sje_new,n1,0)
      call nr_init(ijel_new,n2,0)

      do iel=1,nelt
        i=mt_to_id(iel)
        treenew(iel)=tree(i)
        call copy(xc_new(1,iel),xc(1,i),8)
        call copy(yc_new(1,iel),yc(1,i),8)
        call copy(zc_new(1,iel),zc(1,i),8)

        do iside=1,nsides
          jface = jjface(iside)
          cb=cbc(iside,i)
          xc_new(iside,iel)=xc(iside,i)
          yc_new(iside,iel)=yc(iside,i)
          zc_new(iside,iel)=zc(iside,i)
          cbc_new(iside,iel)=cb

          if(cb.eq.2)then
            ntemp=sje(1,1,iside,i)
            ijel_new(1,iside,iel)=1
            ijel_new(2,iside,iel)=1
            sje_new(1,1,iside,iel)=id_to_mt(ntemp)

          else if(cb.eq.1) then
            ntemp=sje(1,1,iside,i)
            ijel_new(1,iside,iel)=ijel(1,iside,i)
            ijel_new(2,iside,iel)=ijel(2,iside,i)
            sje_new(1,1,iside,iel)=id_to_mt(ntemp)
         
          else if(cb.eq.3) then
            do ii2=1,2
              do ii1=1,2
                ntemp=sje(ii1,ii2,iside,i)
                ijel_new(1,iside,iel)=1
                ijel_new(2,iside,iel)=1
                sje_new(ii1,ii2,iside,iel)=id_to_mt(ntemp)
              end do
            end do

          else if(cb.eq.0)then
            sje_new(1,1,iside,iel)=0
            sje_new(1,2,iside,iel)=0
            sje_new(2,1,iside,iel)=0
            sje_new(2,2,iside,iel)=0       
          end if 

        end do

        call copy(ta2(1,1,1,iel),ta1(1,1,1,i),nxyz)

      end do

      call copy(xc,xc_new,8*nelt)
      call copy(yc,yc_new,8*nelt)
      call copy(zc,zc_new,8*nelt)
      call ncopy(sje,sje_new,4*6*nelt)
      call ncopy(ijel,ijel_new,2*6*nelt)
      call ncopy(cbc,cbc_new,6*nelt)
      call ncopy(tree,treenew,nelt)
      call copy(ta1,ta2,nxyz*nelt)

      do iel=1,nelt
        mt_to_id(iel)=iel
        id_to_mt(iel)=iel
      end do

      return
      end 
