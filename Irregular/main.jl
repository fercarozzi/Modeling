using SeisMain, SeisProcessing, FFTW
 
include("src/read_data_param.jl")
include("src/linear.jl")
include("src/linear_irreg.jl")

include("src/coord.jl")
include("src/decimate.jl")

#>>>>>>>>>> Define Coordinates <<<<<<<<<<<<<<<<<<<<<<<<<

file_input = "in/grid_initial.txt"
file_output = "in/grid_output.txt"


# >> Initial grid 

data_param = read_data_param(file_input)

xreg = coord(data_param);

# >> Desired output grid 

output_param = read_data_param(file_output)

xo = coord(output_param);

# Observed grid = jitter + dec

dec = 60

xi = decimate(xreg,dec,output_param) 

#>>>>>>>>>>>>>>> Model Linear Events <<<<<<<<<<<<<<<<<<<<<<<<<

fileirr = "out/xs"

filereg = "out/reg_xs"

p1=[+0.0003,-0.0001,+0.0000]
p2=[+0.0003,-0.0001,+0.0000]
p3=[+0.0000,+0.0000,+0.0000]
p4=[+0.0000,+0.0000,+0.0000]
amp=[+1.0,-1.0,+0.0]
f0=20.0
tau=[0.30,0.60,0.00]
nt=500
dt=0.002

model_param = Dict(:p1=>p1,:p2=>p2,:p3=>p3,:p4=>p4,:amp=>amp,:f0=>f0,:tau=>tau,:nt=>nt,:dt=>dt)


# 1) Model ideal, regular events. Writes to file

LinearEvents(output_param,model_param,filereg);

# 2) Model observed data (linear events in the irregular coordinates)

di0,hi,extent,dt = LinearEventsIrr( xi, model_param);

di = SeisAddNoise(di0,1.2);

# 3) Write data to file

SeisWrite(fileirr, di,hi,extent)




