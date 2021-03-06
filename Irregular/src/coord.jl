"""
	coord(output_param)
Model regular mesh according to given parameters
"""
function coord(pm)  

 #Define coordinates for initial grid

 x1 = collect(pm.minx:pm.dx:pm.maxx) 
 x2 = collect(pm.miny:pm.dy:pm.maxy)
 
 nx1 = length(x1)
 nx2 = length(x2)

println("nx1= ",nx1," nx2= ",nx2)

 x = zeros(nx1*nx2,2);

 for i=1:nx1
     x[(i-1)*nx2+1:i*nx2,2]=x2;
     x[(i-1)*nx2+1:i*nx2,1].=x1[i];
 end


return x

end
