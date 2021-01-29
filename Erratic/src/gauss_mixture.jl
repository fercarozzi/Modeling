"""
	gauss_mixture(d,snr;<Keyword args>)
Compute the noisy component of the traces using a Gauss mixture model

# Keyword arguments
* `sigma1`: variance of distribution with probability p
* `sigma2`: variance of distribution with probability 1-p
* `p`: mixing parameter (0,1)

"""
function gauss_mixture(d,snr;sigma1=0,sigma2=0,p=0)

 N = length(d)

 r1 = randn(N,1)*sqrt(sigma1);
 r2 = randn(N,1)*sqrt(sigma2);

r=zeros(N)

 for k=1:N
   if rand(1)[1] < p
      r[k]=r1[k]
   else
      r[k]=r2[k]
   end
 end

noise= r/sum(r[:]) * sum(d[:])/snr
return noise
end
