using Plots, LinearAlgebra, ForwardDiff, Random

# make a function with two basins, the deeper basin is really narrow
x1 = [ 0.03603987006772491
 0.20167519711419302
 0.916780784611773
 0.9961531457527353
 0.8308386822798601
 0.48010604707790083
 0.27326359868026096
 0.37353751782867883
 0.2997264154064785
 0.1735286249535044
 0.22928165622986163
 0.8418849350500255
 0.003031242290423286
 0.1246140519014316]
f(x) = -0.5*prod(sin.(π*x))-exp(-50*sum((x.-x1).^2))

nw = 1000 # Number of walkers
α = .1 # step size
w = rand(nw,14) # Initialize walkers
ns = round(Int,.99*nw) # Number of survivors
e = [f(w[i,:]) for i ∈ 1:nw] # Get energies of walkers

#for j ∈ 1:2 # iteration loop
    p = sortperm(e) # Get sorted order
    w = w[p,:]  # Re-order walkers by energy
    e = e[p] # List the energies in sorted order
    clones = randperm(ns)[1:nw-ns] # Select some walkers to clone (don't select one more than once)
    for iw = ns+1:nw # Loop over cloned walkers
        println("iw: ",iw)
        x = w[clones[iw-ns],:] # Position of cloned malker
        # Get the step direction
        n̂ = ForwardDiff.gradient(f,x)/norm(ForwardDiff.gradient(f,x))
        iter = 0
        while true
            xtry = x-α*n̂ # move in the direction of the gradient
            if f(xtry) > e[iw]
                println("step too big")
                α *= .3
    #         else
    #             w[iw] = x
    #             e[iw] = f(x)
                 break
             end
    #         iter+=1
    #         if iter >3 
    #             println("Got stuck")
    #             println(iw)
    #             error("couldn't step downhill")
    #             break
    #         end
        break
    #     end
    end
end
#histogram(e,nbins=20,size=(500,250))




