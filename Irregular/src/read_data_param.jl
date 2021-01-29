mutable struct data_parameters

    ox::Float32
    oy::Float32
    dx::Float32
    dy::Float32
    
    miny::Float32
    maxy::Float32
    minx::Float32
    maxx::Float32

    nx1::Int64
    nx2::Int64

    dt::Float32
    nt::Int64

end
 

function read_data_param(filename)

f = open(filename,"r")
fstring = read(f,String);
close(f)

ini = first(something(findlast("dx=",fstring),0:-1))
dx = parse(Float32, fstring[something(findnext(r"dx=.*",fstring,ini))][4:end])

ini = first(something(findlast("ox=",fstring),0:-1))
ox = parse(Float32, fstring[something(findnext(r"ox=.*",fstring,ini))][4:end])

ini = first(something(findlast("dy=",fstring),0:-1))
dy = parse(Float32, fstring[something(findnext(r"dy=.*",fstring,ini))][4:end])

ini = first(something(findlast("oy=",fstring),0:-1))
oy = parse(Float32, fstring[something(findnext(r"oy=.*",fstring,ini))][4:end])

ini = first(something(findlast("miny=",fstring),0:-1))
miny = parse(Float32,fstring[something(findnext(r"miny=.*",fstring,ini))][6:end])

ini = first(something(findlast("maxy=",fstring),0:-1))
maxy = parse(Float32,fstring[something(findnext(r"maxy=.*",fstring,ini))][6:end])

ini = first(something(findlast("minx=",fstring),0:-1))
minx = parse(Float32,fstring[something(findnext(r"minx=.*",fstring,ini))][6:end])

ini = first(something(findlast("maxx=",fstring),0:-1))
maxx = parse(Float32,fstring[something(findnext(r"maxx=.*",fstring,ini))][6:end])

nx1=0
nx2=0
dt=0.0
nt=0
data_params = data_parameters(ox,oy,dx,dy,miny,maxy,minx,maxx,nx1,nx2,dt,nt)

return data_params
end