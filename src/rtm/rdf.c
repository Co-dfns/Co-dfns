NM(rdf,"rdf",0,0,DID,MT ,DFD,MT,DAD)
ID(rdf,1,s32)
OM(rdf,"rdf",0,0,MFD,DFD,MAD,DAD)
DEFN(rdf)
DA(rdf_f){red_c(z,l,r,e,ax);}
DF(rdf_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(0)));}
MA(rdf_o){red_o mfn_c(llp);mfn_c(z,r,e,ax);}
MF(rdf_o){A x=r;if(!rnk(r))cat_c(x,r,e);this_c(z,x,e,scl(scl(0)));}
DA(rdf_o){red_o mfn_c(llp);mfn_c(z,l,r,e,ax);}
DF(rdf_o){if(!rnk(r))err(4);red_o mfn_c(llp);mfn_c(z,l,r,e,scl(scl(0)));}
