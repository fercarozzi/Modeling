#Generate synthetic data to test RPMF.

using SeisMain, SeisProcessing, FFTW, LinearAlgebra,Distributions
 
include("src/linear.jl")
include("src/gauss_mixture.jl")
include("src/sinusoidal_noise.jl")


#>>>>>>>>>>>>>>> Model Linear Events <<<<<<<<<<<<<<<<<<<<<<<<<

dt=0.002
nt=1000
Tmax=(nt-1)*dt

nx1=30
nx2=30
nx3=10 
nx4=10
dx1=5
dx2=5
dx3=5
dx4=5
  
ox1=0
ox2=0
ox3=0
ox4=0

tau=[ Tmax/3,Tmax/2.,Tmax/1.4]
p1=[-.001,0.002,-0.003]
p2=[-.0005,0.001,0.0001]
p3=[-0.001,0.001,0.0001]
p4=[0.002,-0.0005,0.001]
amp=[1.0,-0.7,0.5]
f0=20.0

param = Dict(:nx1=>nx1,:nx2=>nx2,:nx3=>nx3,:nx4=>nx4,:dx1=>dx1,:dx2=>dx2,:dx3=>dx3,:dx4=>dx4,:p1=>p1,:p2=>p2,:p3=>p3,:p4=>p4,:amp=>amp,:f0=>f0,:tau=>tau,:nt=>nt,:dt=>dt)


perc = 10  #Decimation percentage


fileclean="out/linear"  # clean traces
filedata="out/test1" # noisy traces


#>>>>>>>>>>>>>>> Include noise <<<<<<<<<<<<<<<<<<<<<<<<<

# 1) Model ideal, regular events. Writes to file

LinearEvents(param,fileclean);

# 2) Model mixture noise

di0,hi,extent = SeisRead(fileclean);

# Define parameters, SNR, sigma1,sigma2,calculate p

a = 10.
p = 0.9

   noise = gauss_mixture(di0,0.1;sigma1=0.001,sigma2=a,p=p)
   n=reshape(noise,size(di0))
   dn = di0+n

#add sinusoidal (noise) traces
dn=sinusoidal_noise(dn;a=1,p=5);

# 4 ) Decimate volume

  dec = SeisDecimate(dn,perc=perc)

# 3) Write data to file

  SeisWrite(filedata, dec,hi,extent)


