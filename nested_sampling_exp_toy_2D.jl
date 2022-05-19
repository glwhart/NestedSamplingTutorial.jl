using Plots, LinearAlgebra, ForwardDiff, Random

function move_along_contour(x,f)
    xrand = rand(length(x))
    ∇f = ForwardDiff.gradient(f,x) # Uphill direction
    xrand = xrand - xrand⋅∇f*∇f/(∇f⋅∇f) # Find a direction ⟂ ∇f
    xrand = xrand/norm(xrand)/norm(∇f)/10 # Scale the length by steepness
    # for istep = 1:3
    #     xnew = x - xrand
    #     ∇f = ForwardDiff.gradient(f,xrand)
    #     x2 = xrand - xrand⋅∇f*∇f/(∇f⋅∇f)
    #     x2 = xrand/norm(xrand)
    #     xrand = xrand - .05*xrand
    # end
    #println(xrand)
    return xrand
end
x1 = [ 0.03603987006772491, 0.20167519711419302]
f(x) = -0.5*prod(sin.(π*x))-exp(-50*sum((x.-x1).^2))

xp = 0:.01:1  
yp = 0:.01:1
contour(xp,yp,(x,y)->f([x,y]),size=(1000,1000)
,fill=true,legend=false, axis=nothing)
Nw = 2
w = rand(Nw,2)
scatter!(w[:,1],w[:,2],msw=3,ms=3,mc=:cyan)
#xnew = move_along_contour(w[1,:],f)
#plot!([w[1,1]-xnew[1],w[1,1]+xnew[1]],[w[1,2]-xnew[2],w[1,2]+xnew[2]],lc=:cyan,lw=3)
# Make a plot of the gradient descent paths. Show that the usually end in the shallow basin.
# Also show what moving along the contour will do.
# Ask Gabor's group about phase space volume in a typical case...
[w[i,:]+=move_along_contour(w[i,:],f) for i in 1:Nw]
scatter!(w[:,1],w[:,2],msw=0,ms=10,mc=:red)
#survivors=sortperm([f(w[i,:]) for i in 1:Nw])[1:convert(Int,Nw/2)]
# clones=w[survivors,:]
# scatter!(clones[:,1],clones[:,2],msw=3,ms=6,mc=:yellow)

