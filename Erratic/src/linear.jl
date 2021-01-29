"""
	LinearEvents(param,fileout)

Generate a synthetic volume consisting of linear events with SeismicJulia format, including header and extent. Writes to fileout

"""
function LinearEvents(pm,filereg)

println("Model regular data...")

    d=SeisLinearEvents(nt=pm[:nt],dt=pm[:dt],
	dx1=pm[:dx1],dx2=pm[:dx2],dx3=pm[:dx3],dx4=pm[:dx4],
	p1=pm[:p1],p2=pm[:p2],p3=pm[:p3],p4=pm[:p4],
	nx1=pm[:nx1],nx2=pm[:nx2],nx3=pm[:nx3],nx4=pm[:nx4],
	tau=pm[:tau],amp=pm[:amp],f0=pm[:f0]); 


    ext = SeisMain.Extent(convert(Int32,pm[:nt]),
    convert(Int32,pm[:nx1]),convert(Int32,pm[:nx2]),convert(Int32,pm[:nx3]),convert(Int32,pm[:nx4]),
		   convert(Float32,0),convert(Float32,0),convert(Float32,0),convert(Float32,0),convert(Float32,0),
		   convert(Float32,pm[:dt]),convert(Float32,pm[:dx1]),convert(Float32,pm[:dx2]),convert(Float32,pm[:dx3]),convert(Float32,pm[:dx4]),
		   "Time","Trace Number","","","","s","index","","","","")
 
    
    nt  = convert(Int64,pm[:nt])
    dt  = pm[:dt]


    println("and create headers.")
    ntrace=pm[:nx1]*pm[:nx2]*pm[:nx3]*pm[:nx4]

    h = Array{Header}(undef,ntrace);
    j=1


    for ix1 = 1:pm[:nx1]
     for ix2 = 1:pm[:nx2]
      for ix3 = 1:pm[:nx3]
       for ix4 = 1:pm[:nx4]
     
        h[j] = SeisMain.InitSeisHeader();
        h[j].tracenum = j;
        h[j].d1 = pm[:dt];
        h[j].n1 = pm[:nt];
        h[j].sx = pm[:dx1]*(ix1-1);
        h[j].sy = pm[:dx2]*(ix2-1);
        h[j].gx = pm[:dx3]*(ix3-1);
        h[j].gy = pm[:dx4]*(ix4-1);
      
        j +=1
      end
     end
    end
   end

SeisWrite(filereg,d,h,ext)

end
 
