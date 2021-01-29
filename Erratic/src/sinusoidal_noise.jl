"""
	sinusoidal_noise(d;<Keyword args>)
Include noise in the form of monochromatic traces 

# Keyword arguments
* `a`: relative amplitude of the sinusoidal wave
* `p`: percentage of corrupted traces
"""
function sinusoidal_noise(d;a=1.0,p=0)


dout=copy(d)
dout=reshape(dout,size(dout,1),size(dout,2)*size(dout,3)*size(dout,4)*size(dout,5))

mask = rand(1,size(d,2)*size(d,3)*size(d,4)*size(d,5));

aux=(LinearIndices(mask))[findall(mask .< p/100)] #find(mask .< p/100) 

for i=1:length(aux)
    for it=1:size(dout,1)
    	dout[it,aux[i]]=sin(pi*it/10.0)*a
    end
end

dout=reshape(dout,size(d))

return dout
end
