!
! FT verification routine.
!
      subroutine verify(n1, n2, n3, nt, cksum, verified)
        implicit none
        include 'npbparams.h'
!
! Arguments.
!

         integer n1, n2, n3, nt
         double complex cksum(0:nt)
         logical verified

!
! Local variables.
!
         integer kt
         double complex cexpd(25)
         real*8 epsilon, err
!
! Initialize tolerance level and success flag.
!
         epsilon = 1.0d-12
         verified = .true.
!
         if ((n1 .eq. 64) .and. (n2 .eq. 64) .and.                 
     &            (n3 .eq. 64) .and. (nt .eq. 6)) then
!
! Class S reference values.
!
            cexpd(1) = dcmplx(554.6087004964D0, 484.5363331978D0)
            cexpd(2) = dcmplx(554.6385409189D0, 486.5304269511D0)
            cexpd(3) = dcmplx(554.6148406171D0, 488.3910722336D0)
            cexpd(4) = dcmplx(554.5423607415D0, 490.1273169046D0)
            cexpd(5) = dcmplx(554.4255039624D0, 491.7475857993D0)
            cexpd(6) = dcmplx(554.2683411902D0, 493.2597244941D0)
            
         else if ((n1 .eq. 128) .and. (n2 .eq. 128) .and.                 
     &            (n3 .eq. 32) .and. (nt .eq. 6)) then
!
! Class W reference values.
!
            cexpd(1) = dcmplx(567.3612178944D0, 529.3246849175D0)
            cexpd(2) = dcmplx(563.1436885271D0, 528.2149986629D0)
            cexpd(3) = dcmplx(559.4024089970D0, 527.0996558037D0)
            cexpd(4) = dcmplx(556.0698047020D0, 526.0027904925D0)
            cexpd(5) = dcmplx(553.0898991250D0, 524.9400845633D0)
            cexpd(6) = dcmplx(550.4159734538D0, 523.9212247086D0)
!
         else if ((n1 .eq. 256) .and. (n2 .eq. 256) .and.               
     &            (n3 .eq. 128) .and. (nt .eq. 6)) then
!
! Class A reference values.
!
            cexpd(1) = dcmplx(504.6735008193D0, 511.4047905510D0)
            cexpd(2) = dcmplx(505.9412319734D0, 509.8809666433D0)
            cexpd(3) = dcmplx(506.9376896287D0, 509.8144042213D0)
            cexpd(4) = dcmplx(507.7892868474D0, 510.1336130759D0)
            cexpd(5) = dcmplx(508.5233095391D0, 510.4914655194D0)
            cexpd(6) = dcmplx(509.1487099959D0, 510.7917842803D0)
!
         else if ((n1 .eq. 512) .and. (n2 .eq. 256) .and.               
     &            (n3 .eq. 256) .and. (nt .eq. 20)) then
!
! Class B reference values.
!
            cexpd(1)  = dcmplx(517.7643571579D0, 507.7803458597D0)
            cexpd(2)  = dcmplx(515.4521291263D0, 508.8249431599D0)
            cexpd(3)  = dcmplx(514.6409228649D0, 509.6208912659D0)
            cexpd(4)  = dcmplx(514.2378756213D0, 510.1023387619D0)
            cexpd(5)  = dcmplx(513.9626667737D0, 510.3976610617D0)
            cexpd(6)  = dcmplx(513.7423460082D0, 510.5948019802D0)
            cexpd(7)  = dcmplx(513.5547056878D0, 510.7404165783D0)
            cexpd(8)  = dcmplx(513.3910925466D0, 510.8576573661D0)
            cexpd(9)  = dcmplx(513.2470705390D0, 510.9577278523D0)
            cexpd(10) = dcmplx(513.1197729984D0, 511.0460304483D0)
            cexpd(11) = dcmplx(513.0070319283D0, 511.1252433800D0)
            cexpd(12) = dcmplx(512.9070537032D0, 511.1968077718D0)
            cexpd(13) = dcmplx(512.8182883502D0, 511.2616233064D0)
            cexpd(14) = dcmplx(512.7393733383D0, 511.3203605551D0)
            cexpd(15) = dcmplx(512.6691062020D0, 511.3735928093D0)
            cexpd(16) = dcmplx(512.6064276004D0, 511.4218460548D0)
            cexpd(17) = dcmplx(512.5504076570D0, 511.4656139760D0)
            cexpd(18) = dcmplx(512.5002331720D0, 511.5053595966D0)
            cexpd(19) = dcmplx(512.4551951846D0, 511.5415130407D0)
            cexpd(20) = dcmplx(512.4146770029D0, 511.5744692211D0)
!
         else if ((n1 .eq. 512) .and. (n2 .eq. 512) .and.               
     &            (n3 .eq. 512) .and. (nt .eq. 20)) then
!
! Class C reference values.
!
            cexpd(1)  = dcmplx(519.5078707457D0, 514.9019699238D0)
            cexpd(2)  = dcmplx(515.5422171134D0, 512.7578201997D0)
            cexpd(3)  = dcmplx(514.4678022222D0, 512.2251847514D0)
            cexpd(4)  = dcmplx(514.0150594328D0, 512.1090289018D0)
            cexpd(5)  = dcmplx(513.7550426810D0, 512.1143685824D0)
            cexpd(6)  = dcmplx(513.5811056728D0, 512.1496764568D0)
            cexpd(7)  = dcmplx(513.4569343165D0, 512.1870921893D0)
            cexpd(8)  = dcmplx(513.3651975661D0, 512.2193250322D0)
            cexpd(9)  = dcmplx(513.2955192805D0, 512.2454735794D0)
            cexpd(10) = dcmplx(513.2410471738D0, 512.2663649603D0)
            cexpd(11) = dcmplx(513.1971141679D0, 512.2830879827D0)
            cexpd(12) = dcmplx(513.1605205716D0, 512.2965869718D0)
            cexpd(13) = dcmplx(513.1290734194D0, 512.3075927445D0)
            cexpd(14) = dcmplx(513.1012720314D0, 512.3166486553D0)
            cexpd(15) = dcmplx(513.0760908195D0, 512.3241541685D0)
            cexpd(16) = dcmplx(513.0528295923D0, 512.3304037599D0)
            cexpd(17) = dcmplx(513.0310107773D0, 512.3356167976D0)
            cexpd(18) = dcmplx(513.0103090133D0, 512.3399592211D0)
            cexpd(19) = dcmplx(512.9905029333D0, 512.3435588985D0)
            cexpd(20) = dcmplx(512.9714421109D0, 512.3465164008D0)
!
         else if ((n1 .eq. 2048) .and. (n2 .eq. 1024) .and.               
     &            (n3 .eq. 1024) .and. (nt .eq. 25)) then
!
! Class D reference values.
!
            cexpd(1)  = dcmplx(512.2230065252D0, 511.8534037109D0)
            cexpd(2)  = dcmplx(512.0463975765D0, 511.7061181082D0)
            cexpd(3)  = dcmplx(511.9865766760D0, 511.7096364601D0)
            cexpd(4)  = dcmplx(511.9518799488D0, 511.7373863950D0)
            cexpd(5)  = dcmplx(511.9269088223D0, 511.7680347632D0)
            cexpd(6)  = dcmplx(511.9082416858D0, 511.7967875532D0)
            cexpd(7)  = dcmplx(511.8943814638D0, 511.8225281841D0)
            cexpd(8)  = dcmplx(511.8842385057D0, 511.8451629348D0)
            cexpd(9)  = dcmplx(511.8769435632D0, 511.8649119387D0)
            cexpd(10) = dcmplx(511.8718203448D0, 511.8820803844D0)
            cexpd(11) = dcmplx(511.8683569061D0, 511.8969781011D0)
            cexpd(12) = dcmplx(511.8661708593D0, 511.9098918835D0)
            cexpd(13) = dcmplx(511.8649768950D0, 511.9210777066D0)
            cexpd(14) = dcmplx(511.8645605626D0, 511.9307604484D0)
            cexpd(15) = dcmplx(511.8647586618D0, 511.9391362671D0)
            cexpd(16) = dcmplx(511.8654451572D0, 511.9463757241D0)
            cexpd(17) = dcmplx(511.8665212451D0, 511.9526269238D0)
            cexpd(18) = dcmplx(511.8679083821D0, 511.9580184108D0)
            cexpd(19) = dcmplx(511.8695433664D0, 511.9626617538D0)
            cexpd(20) = dcmplx(511.8713748264D0, 511.9666538138D0)
            cexpd(21) = dcmplx(511.8733606701D0, 511.9700787219D0)
            cexpd(22) = dcmplx(511.8754661974D0, 511.9730095953D0)
            cexpd(23) = dcmplx(511.8776626738D0, 511.9755100241D0)
            cexpd(24) = dcmplx(511.8799262314D0, 511.9776353561D0)
            cexpd(25) = dcmplx(511.8822370068D0, 511.9794338060D0)
!
         else if ((n1 .eq. 4096) .and. (n2 .eq. 2048) .and.               
     &            (n3 .eq. 2048) .and. (nt .eq. 25)) then
!
! Class E reference values.
!
            cexpd(1)  = dcmplx(512.1601045346D0, 511.7395998266D0)
            cexpd(2)  = dcmplx(512.0905403678D0, 511.8614716182D0)
            cexpd(3)  = dcmplx(512.0623229306D0, 511.9074203747D0)
            cexpd(4)  = dcmplx(512.0438418997D0, 511.9345900733D0)
            cexpd(5)  = dcmplx(512.0311521872D0, 511.9551325550D0)
            cexpd(6)  = dcmplx(512.0226088809D0, 511.9720179919D0)
            cexpd(7)  = dcmplx(512.0169296534D0, 511.9861371665D0)
            cexpd(8)  = dcmplx(512.0131225172D0, 511.9979364402D0)
            cexpd(9)  = dcmplx(512.0104767108D0, 512.0077674092D0)
            cexpd(10) = dcmplx(512.0085127969D0, 512.0159443121D0)
            cexpd(11) = dcmplx(512.0069224127D0, 512.0227453670D0)
            cexpd(12) = dcmplx(512.0055158164D0, 512.0284096041D0)
            cexpd(13) = dcmplx(512.0041820159D0, 512.0331373793D0)
            cexpd(14) = dcmplx(512.0028605402D0, 512.0370938679D0)
            cexpd(15) = dcmplx(512.0015223011D0, 512.0404138831D0)
            cexpd(16) = dcmplx(512.0001570022D0, 512.0432068837D0)
            cexpd(17) = dcmplx(511.9987650555D0, 512.0455615860D0)
            cexpd(18) = dcmplx(511.9973525091D0, 512.0475499442D0)
            cexpd(19) = dcmplx(511.9959279472D0, 512.0492304629D0)
            cexpd(20) = dcmplx(511.9945006558D0, 512.0506508902D0)
            cexpd(21) = dcmplx(511.9930795911D0, 512.0518503782D0)
            cexpd(22) = dcmplx(511.9916728462D0, 512.0528612016D0)
            cexpd(23) = dcmplx(511.9902874185D0, 512.0537101195D0)
            cexpd(24) = dcmplx(511.9889291565D0, 512.0544194514D0)
            cexpd(25) = dcmplx(511.9876028049D0, 512.0550079284D0)
!
         else
!
            write (*,    120) 'not performed'
            verified = .false.
!
         end if
!
! Verification test for results.
!
         if (verified) then

            do kt = 1, nt
              err = abs((cksum(kt)-cexpd(kt))/cexpd(kt))
              if (.not.(err.le.epsilon)) then
                verified = .false.
                goto 100
              endif     
            end do
  100       continue

            if (verified) then
               write (*,    120) 'successful'
            else
               write (*,    120) 'failed'
            end if

  120       format (' Verification test for FT ', a)
         end if
!
         return
      end
