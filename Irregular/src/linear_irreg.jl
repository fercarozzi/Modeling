"""
	LinearEventsIrr(xi,model_param;<Keyword args>)
Generate traces with irregular coordinates 

# Keyword arguments
* `ot`: First sample for the time axis. 
"""
function LinearEventsIrr(xi,pb;ot=0.0)

dt = pb[:dt]
nt = pb[:nt]

ni = convert(Int32,size(xi,1))

tau = pb[:tau]
p1 = pb[:p1]
p2 = pb[:p2]
amp = pb[:amp]
f0 = pb[:f0]

println("Model Irregular data...")

    w = SeisProcessing.Ricker(dt=dt,f0=f0);
    nf = nextpow(2,nt);
    nw = length(w);
    t_delay = (nw-1)*dt/2;
    w = vcat(w, zeros(nf-nw));
    W = fft(w);

     
    n_events = length(p1);
    d = zeros(Float64, nt, ni);
    D = zeros(Complex{Float64}, nf, ni);
    nfh = round(Int, floor(nf/2)) + 1
    wrs = collect(0:1:nfh-1)*2*pi/(nf*dt)     # Frequency in rad/sec


    for ie = 1:n_events
       for ix = 1:ni
          for iw = 2:nfh-1
              phase = wrs[iw]*(tau[ie] + p1[ie]*xi[ix,1] + p2[ie]*xi[ix,2] - t_delay)
              D[iw:iw, ix] .+= W[iw]*amp[ie]*exp(-im*phase)
	      D[nf-iw+2,ix] = conj(D[iw,ix])


	   end
      end
     end
    
    d = ifft(D,1)
    d = real(d[1:nt,:,]);
    # Add extent header 
    extent = SeisMain.Extent(convert(Int32, nt), convert(Int32, ni),
                            convert(Int32, 1), convert(Int32, 1),
                            convert(Int32, 1)  , convert(Float32, ot),
                            convert(Float32, 0), convert(Float32, 0),
                            convert(Float32, 0), convert(Float32, 0),
                            convert(Float32, dt), convert(Float32,0),
                            convert(Float32, 0), convert(Float32, 0),
                            convert(Float32,0), "Time", "ix1", "ix2", "ix3",
                            "ix4", "s", "index", "index", "index", "index", "")
   d = reshape(d, round(Int, extent.n1), round(Int, extent.n2))

println("and create headers.")


h = Array{Header}(undef,ni);
for ix = 1:ni
    h[ix] = SeisMain.InitSeisHeader();
    h[ix].tracenum = ix;
    h[ix].d1 = dt;
    h[ix].n1 = nt;

    h[ix].sx = xi[ix,1]
    h[ix].sy = xi[ix,2]
end

 


return d,h,extent,dt

end
