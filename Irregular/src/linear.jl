"""
	LinearEvents(output_param,model_param,filereg)

Generate a synthetic volume consisting of linear events with SeismicJulia format, including header and extent

"""
function LinearEvents(pm,pb,filereg)

println("Model regular data...")

nx1 = convert(Int,floor((pm.maxx - pm.minx)/pm.dx))+1
nx2 = convert(Int,floor((pm.maxy - pm.miny)/pm.dy))+1


    d=SeisLinearEvents(nt=pb[:nt],dt=pb[:dt],dx1=pm.dx,dx2=pm.dy,
	p1=pb[:p1],p2=pb[:p2],p3=pb[:p3],p4=pb[:p4],nx1=nx1,nx2=nx2,
	ox1=pm.ox,ox2=pm.oy,tau=pb[:tau],amp=pb[:amp],f0=pb[:f0]); 


    ext = SeisMain.Extent(convert(Int32,pb[:nt]),convert(Int32,nx1),convert(Int32,nx2),convert(Int32,1),convert(Int32,1),
		   convert(Float32,0),convert(Float32,pm.ox),convert(Float32,pm.oy),convert(Float32,0),convert(Float32,0),
		   convert(Float32,pb[:dt]),convert(Float32,pm.dx),convert(Float32,pm.dy),convert(Float32,1),convert(Float32,1),
		   "Time","Trace Number","","","","s","index","","","","")
 
    ox1 = pm.ox
    ox2 = pm.oy

    nt  = convert(Int64,pb[:nt])
    dt  = pb[:dt]


    println("and create headers.")
    ntrace=nx1*nx2

    h = Array{Header}(undef,ntrace);
    j=1


    for ix1 = 1:nx1
     for ix2 = 1:nx2
      h[j] = SeisMain.InitSeisHeader();
      h[j].tracenum = j;
      h[j].d1 = pb[:dt];
      h[j].n1 = pb[:nt];
      h[j].sx = pm.ox+pm.dx*(ix1-1);
      h[j].sy = pm.oy+pm.dy*(ix2-1);
      j +=1
     end
    end

#get regular coordinates
    a1=zeros(nx1);
    for ix = 1:nx1
        a1[ix]=pm.ox+pm.dx*(ix-1);
    end
    a2=zeros(nx2);
    for ix = 1:nx2
        a2[ix]=pm.oy+pm.dy*(ix-1);
    end

SeisWrite(filereg,d,h,ext)

end
 
