using Plots, LinearAlgebra, ForwardDiff, Random

""" Move a point along the countour, ⟂ to gradient """
function move_along_contour(x,f,maxNs=15)
    xrand = rand(length(x))
    xnew = x
    minNs = 5
    for i ∈ minNs:rand(minNs:max(minNs,maxNs))
        ∇f = ForwardDiff.gradient(f,xnew) # Uphill direction
        nf = max(norm(∇f),.2) # keep |∇f| big near minima (avoid big steps) 
        xrand = xrand - xrand⋅∇f*∇f/nf^2 # Find a direction ⟂ ∇f
        xrand = xrand/norm(xrand)/nf/10 # Scale the length by steepness
        xnew = xnew+xrand
    end
    bounce_back_to_unit_square(xnew)
    return xnew
end

""" If a point is outside the unit square, reflect it back """
function bounce_back_to_unit_square(p)
# Bounce back into unit square if necessary.
   p[1] > 1.0 ? p[1] = mod(p[1],1) : true 
   p[1] < 0.0 ? p[1] = 1-mod(p[1],1) : true
   p[2] > 1.0 ? p[2] = mod(p[2],1) : true 
   p[2] < 0.0 ? p[2] = 1-mod(p[2],1) : true
end

""" Move x along gradient to height `e` """
function restore_height(e,x,f)
    ∇f = ForwardDiff.gradient(f,x)
    for i ∈ 1:5
        x = x + ∇f*(e-f(x))/norm(∇f) 
    end
    bounce_back_to_unit_square(x)
    return x
end

""" Move walker downhill very slightly """
function step_downhill(x,f)
    ∇f = ForwardDiff.gradient(f,x)
    return x -= ∇f/norm(∇f)*.01       
end

x1 = [0.3, 0.201]
f(x) = -0.5*(sin(π*x[1])*sin(π*x[2]))-exp(-100*((x[1]-x1[1])^2+(x[2]-x1[2])^2))
xp = 0:.01:1 
yp = 0:.01:1

contour(xp,yp,(x,y)->f([x,y]),size=(1000,1000)
,fill=true,legend=false, axis=nothing)
Nw = 2
w = rand(Nw,2)
scatter!(w[:,1],w[:,2],msw=3,ms=3,mc=:cyan)
nS = 10
x = move_along_contour(w[1,:],f)
e = f(w[1,:])
xnew = move_along_contour(x,f)
x2 = restore_height(e,xnew,f)

begin
x2=rand(2)
@gif for i ∈ 1:10
    global x2
    #println("1: ",f(x2)," ",x2)
    contour(xp,yp,(x,y)->f([x,y]),size=(1000,1000)
,fill=true,legend=false, axis=nothing)
    scatter!([x2[1]],[x2[2]],xrange=(0,1),yrange=(0,1),aspect_ratio=1,legend=:false)
    e = f(x2)
    #println(x)
    x = move_along_contour(x2,f)
    #println("2: ",f(x)," ",x)
    x2 = restore_height(e,x,f)
    #println("3: ",f(x)," ",x)
end
end

anim = Animation()
Nw = 20 # Number of walkers
Ns = Int(Nw/2) # Number of survivors
contour(xp,yp,(x,y)->f([x,y]),size=(1000,1000)
,fill=true,legend=false, axis=nothing)
w = rand(Nw,2)
scatter!(w[:,1],w[:,2],msw=2,ms=8,mc=:cyan)
e = [f(i) for i ∈ eachrow(w)]
w = w[sortperm(e),:]
scatter!(w[Ns+1:Nw,1],w[Ns+1:Nw,2],msw=2,ms=8,mc=:red)
for i ∈ 1:Ns
    h = f(w[i,:])
    w[i+Ns,:] = move_along_contour(w[i,:],f)
    w[i+Ns,:] = restore_height(h,w[i+Ns,:],f)
end
scatter!(w[Ns+1:Nw,1],w[Ns+1:Nw,2],msw=2,ms=8,mc=:green)
contour(xp,yp,(x,y)->f([x,y]),size=(1000,1000)
,fill=true,legend=false, axis=nothing)
scatter!(w[:,1],w[:,2],msw=2,ms=8,mc=:cyan)
scatter!(w[Int(Nw/2)+1:Nw,1],w[Int(Nw/2)+1:Nw,2],msw=2,ms=8,mc=:green)
scatter!(w[:,1],w[:,2],msw=2,ms=8,mc=:cyan)
for i ∈ 1:Nw
    w[i,:] = step_downhill(w[i,:],f)
end
scatter!(w[:,1],w[:,2],msw=2,ms=8,mc=:green)
