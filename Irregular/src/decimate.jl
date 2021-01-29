"""
	decimate(xreg,dec,output_param)
Randomly decimate traces

"""
function decimate(x,dec,pm)

  nx1 = convert(Int,floor((pm.maxx - pm.minx)/pm.dx))
  nx2 = convert(Int,floor((pm.maxy - pm.miny)/pm.dy))  

  nreg = size(x,1)

   ntr = nx1 * nx2  # number of traces, nominal grid
   av_in = 100 - dec
   p = av_in * ntr /(nreg)
   perc = 100 - p
 
   mask = rand(size(x,1));

   mask[findall(mask .< perc/100)] .= 0;
   mask[findall(mask .>= perc/100)] .= 1;

   j=1
   nn= convert(Int,floor(av_in * ntr/100.0))

   xi = zeros(nn,2);

   for i = 1:size(x,1)
       if mask[i]>0.9 && j<= nn
       	  xi[j,:] = x[i,:]
       	  j +=1
	end
   end

   aux1 = rand(-4:0.5:3,size(xi,1));
   aux2 = rand(-4:0.5:3,size(xi,1));

   for i = 1:nn
        xi[i,1] = xi[i,1] + aux1[i] > pm.ox ? xi[i,1] + aux1[i] : xi[i,1]
    	xi[i,2] = xi[i,2] + aux2[i] > pm.oy ? xi[i,2] + aux2[i] : xi[i,2]
   end

return xi 
end
