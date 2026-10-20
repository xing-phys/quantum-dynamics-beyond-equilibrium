using Random, LinearAlgebra, Statistics
# Original figures, Julia 1.10+, standard libraries only. Seed is fixed.
const OUT=normpath(joinpath(@__DIR__,"..","figs")); mkpath(OUT)
const BLUE="#27627c"; const RED="#c2654b"; const GREEN="#488b76"
const INK="#273946"; const GRAY="#78858b"
esc(s)=replace(string(s),"&"=>"&amp;","<"=>"&lt;",">"=>"&gt;")
txt(x,y,s;size=18,color=INK,anchor="start")="""<text x="$x" y="$y" font-size="$size" fill="$color" text-anchor="$anchor">$(esc(s))</text>"""
line(x1,y1,x2,y2;color=GRAY,width=1.5,dash="")="""<line x1="$x1" y1="$y1" x2="$x2" y2="$y2" stroke="$color" stroke-width="$width" stroke-dasharray="$dash"/>"""
circle(x,y,r;color=BLUE,opacity=1)= """<circle cx="$x" cy="$y" r="$r" fill="$color" opacity="$opacity"/>"""
function svg(name,w,h,b)
    write(joinpath(OUT,name*".svg"),"""<svg xmlns="http://www.w3.org/2000/svg" width="$w" height="$h" viewBox="0 0 $w $h"><rect width="100%" height="100%" fill="#fffdf9"/><g font-family="DejaVu Sans,Arial,sans-serif" fill="$INK">$b</g></svg>""")
end
function box(x,y,w,h,title,sub)
    """<rect x="$x" y="$y" width="$w" height="$h" rx="9" fill="#f0f5f5" stroke="$BLUE" stroke-width="1.5"/>"""*txt(x+w/2,y+32,title;size=19,anchor="middle",color=BLUE)*txt(x+w/2,y+60,sub;size=13,anchor="middle")
end
function poly(xs,ys;color=BLUE,width=2.5)
    pts=join(["$(round(x;digits=3)),$(round(y;digits=3))" for (x,y) in zip(xs,ys)]," ")
    """<polyline points="$pts" fill="none" stroke="$color" stroke-width="$width"/>"""
end
axes(x,y,w,h,xlabel,ylabel;title="")=line(x,y,x+w,y)*line(x,y,x,y-h)*txt(x+w/2,y+45,xlabel;size=16,anchor="middle")*txt(x,y-h-16,ylabel;size=15)*txt(x+w/2,y-h-48,title;size=20,anchor="middle")

function conceptual_figures(rng)
    b=txt(45,38,"ONE EVOLUTION · DIFFERENT QUESTIONS";size=24,color=BLUE)
    b*=box(330,65,340,85,"Global state and unitary dynamics","Specify initial state, Hamiltonian, and record")
    b*=line(390,150,165,215)*line(500,150,500,215)*line(610,150,835,215)
    b*=txt(110,195,"measure bath";size=14)*txt(435,195,"sample times";size=14)*txt(750,195,"retain input/output";size=14)
    for (x,title,sub,title2,sub2) in [(30,"Projected ensemble","Conditional states and Born weights","Average over outcomes","Reduced density matrix"),(365,"Temporal ensemble","States along one trajectory","Average over time","Time-averaged density matrix"),(700,"Channels and processes","Maps and multi-time memory","Discard record or history","Coarser dynamical description")]
        b*=box(x,215,270,85,title,sub)*line(x+135,300,x+135,357)*box(x,357,270,85,title2,sub2)
    end
    b*=txt(500,490,"Higher moments reveal information lost by averaging.";size=18,anchor="middle")
    svg("concept-map",1000,520,b)
    b=txt(30,35,"SAME MEAN STATE · DIFFERENT FLUCTUATIONS";size=23,color=BLUE)
    for (j,label) in enumerate(["Two poles","Equatorial circle","Uniform sphere"])
        cx=170+330*(j-1); cy=190; r=105
        b*="""<circle cx="$cx" cy="$cy" r="$r" fill="#f5f5ef" stroke="#a4b1b4"/><ellipse cx="$cx" cy="$cy" rx="$r" ry="30" fill="none" stroke="#b9c3c5" stroke-dasharray="5 4"/>"""
        b*=line(cx-r,cy,cx+r,cy)*line(cx,cy-r,cx,cy+r)
        states=j==1 ? [[0.,0,1],[0.,0,-1]] : j==2 ? [[cos(t),sin(t),0.] for t in range(0,2π;length=29)[1:end-1]] : [normalize(randn(rng,3)) for _ in 1:90]
        for v in states
            b*=circle(cx+r*(.88v[1]+.32v[2]),cy-r*(v[3]-.2v[2]),j==1 ? 7 : 3.5;color=[BLUE,RED,GREEN][j],opacity=.8)
        end
        b*=txt(cx,325,label;size=19,anchor="middle")*txt(cx,357,["E[z²] = 1","E[z²] = 0","E[z²] = 1/3"][j];size=17,anchor="middle")*txt(cx,385,"E[r] = 0 → mean state I/2";size=14,anchor="middle")
    end
    svg("ensemble-geometry",1000,415,b)
    b=txt(40,38,"MEMORY RETAINED BY THE SAME ENVIRONMENT";size=23,color=BLUE)
    for (y,label) in [(125,"System S"),(245,"Bath E")]
        b*=txt(30,y+5,label;size=18)*line(150,y,900,y;color=INK,width=2)
    end
    for x in [350,650]
        b*=line(x,125,x,245;color=BLUE,width=3)*txt(x,95,"SWAP";size=16,anchor="middle",color=BLUE)
        for y in [125,245]
            b*=line(x-9,y-9,x+9,y+9;color=BLUE,width=3)*line(x-9,y+9,x+9,y-9;color=BLUE,width=3)
        end
    end
    for (x,st,bt) in [(220,"ρ","|0⟩"),(485,"|0⟩","ρ"),(805,"ρ","|0⟩")]
        b*=txt(x,155,st;size=22,anchor="middle")*txt(x,275,bt;size=22,anchor="middle")
    end
    b*=txt(500,330,"One SWAP: replacer channel. Two SWAPs: identity channel.";size=17,anchor="middle")*txt(500,362,"Resetting the bath changes the physical process.";size=17,anchor="middle")
    svg("swap-memory",1000,395,b)
end
haar(d,rng)=normalize(randn(rng,d).+im*randn(rng,d))
function haar_moment_qubit(k)
    D=2^k; M=zeros(ComplexF64,D,D)
    for i in 0:D-1,j in 0:D-1
        a=count_ones(i)
        if a==count_ones(j); M[i+1,j+1]=1/((k+1)*binomial(k,a)); end
    end
    M
end
function moment(C,k)
    dA,dB=size(C); M=zeros(ComplexF64,dA^k,dA^k)
    for z in 1:dB
        v=C[:,z]; p=real(dot(v,v))
        if p>0
            v/=sqrt(p); vk=v
            for _ in 2:k; vk=kron(vk,v); end
            M .+= p.*(vk*vk')
        end
    end
    M
end
function projected_figure(rng)
    dbs=2 .^ (1:10); reps=48; means=zeros(10,3); sem=zeros(10,3)
    open(joinpath(OUT,"projected-convergence.csv"),"w") do io
        println(io,"dA,dB,k,replicates,mean_trace_distance,standard_error")
        for (i,db) in enumerate(dbs)
            vals=zeros(reps,3)
            for q in 1:reps
                C=reshape(haar(2db,rng),2,db)
                for k in 1:3; vals[q,k]=sum(abs,eigvals(Hermitian(moment(C,k)-haar_moment_qubit(k))))/2; end
            end
            for k in 1:3
                means[i,k]=mean(vals[:,k]); sem[i,k]=std(vals[:,k])/sqrt(reps)
                println(io,"2,$db,$k,$reps,$(means[i,k]),$(sem[i,k])")
            end
        end
    end
    xmap(db)=90+710*(log2(db)-1)/9
    ymap(v)=430-320*(log10(max(v,.005))-log10(.005))/(log10(.8)-log10(.005))
    b=axes(90,430,710,320,"Bath dimension dB (log scale)","Trace distance (log scale)";title="Finite Haar bath: projected-moment convergence")
    for db in [2,8,32,128,512]; x=xmap(db); b*=line(x,430,x,436)*txt(x,455,string(db);size=13,anchor="middle"); end
    for v in [.01,.03,.1,.3]; y=ymap(v); b*=line(90,y,800,y;color="#e6e7e1")*txt(78,y+5,string(v);size=13,anchor="end"); end
    for k in 1:3
        col=[BLUE,RED,GREEN][k]; b*=poly(xmap.(dbs),ymap.(means[:,k]);color=col)
        for i in 1:10
            x=xmap(dbs[i]); b*=circle(x,ymap(means[i,k]),4;color=col)*line(x,ymap(means[i,k]+sem[i,k]),x,ymap(means[i,k]-sem[i,k]);color=col)
        end
        b*=line(835,170+45k,870,170+45k;color=col,width=3)*txt(880,176+45k,"k = $k";size=17)
    end
    b*=txt(500,520,"dA = 2 · 48 independent global Haar draws per size · seed 20261020";size=14,anchor="middle")
    svg("projected-convergence",1000,550,b)
end
function scrooge_figure(rng)
    λ=.8; N=40000; ys=Float64[]
    while length(ys)<N
        x=rand(rng); a=λ*x+(1-λ)*(1-x)
        if rand(rng)<a/max(λ,1-λ); push!(ys,λ*x/a); end
    end
    @assert abs(mean(ys)-λ)<.015
    bins=40; hist=zeros(Int,bins)
    for y in ys; hist[min(floor(Int,y*bins)+1,bins)]+=1; end
    density(y)=2/(λ*(1-λ))*(y/λ+(1-y)/(1-λ))^(-3)
    b=axes(85,420,780,310,"Conditional probability |⟨0|ψ⟩|²","Probability density";title="A biased mean requires a constrained ensemble")
    for i in 1:bins
        x=85+(i-1)*780/bins; h=(hist[i]/N*bins)/8*310
        b*="""<rect x="$x" y="$(420-h)" width="$(780/bins-1)" height="$h" fill="#c7dce4"/>"""
    end
    xx=range(0,1;length=300); b*=poly(85 .+780 .*xx,420 .-310 .*density.(xx)./8)*line(85,420-310/8,865,420-310/8;color=RED,dash="7 5")
    for x in [0,.25,.5,.75,1.]; b*=txt(85+780x,445,string(x);size=14,anchor="middle"); end
    for y in [0,2,4,6,8]; b*=txt(73,425-310y/8,string(y);size=14,anchor="end"); end
    b*=txt(120,150,"Scrooge mean λ = 0.8";size=17,color=BLUE)*txt(120,180,"Haar density = 1";size=17,color=RED)*txt(475,510,"40,000 adjusted samples · original Monte Carlo illustration";size=14,anchor="middle")
    svg("scrooge-qubit",950,540,b)
    println("Scrooge empirical mean: ",mean(ys)," (target ",λ,")")
end
function constrained_figures(rng)
    L=8; bits(s)=[(s>>(j-1))&1 for j in 1:L]
    states=[s for s in 0:2^L-1 if sum(bits(s))==4 && sum((1:L).*bits(s))==18]
    edges=Tuple{Int,Int}[]
    for (i,s) in enumerate(states),j in 1:L-3
        v=bits(s); p=v[j:j+3]
        if p==[0,1,1,0] || p==[1,0,0,1]
            w=copy(v); w[j:j+3]=1 .-p; t=sum(w[a]<<(a-1) for a in 1:L); q=findfirst(==(t),states)
            if q!==nothing && i<q; push!(edges,(i,q)); end
        end
    end
    n=length(states); θ=range(0,2π;length=n+1)[1:end-1]; xs=500 .+335 .*cos.(θ); yy=290 .+190 .*sin.(θ)
    b=txt(30,35,"A FIXED CHARGE AND DIPOLE SECTOR CAN STILL SPLIT";size=23,color=BLUE)
    for (i,j) in edges; b*=line(xs[i],yy[i],xs[j],yy[j];color=BLUE,width=3); end
    for (i,s) in enumerate(states); b*=circle(xs[i],yy[i],9;color=RED)*txt(xs[i],yy[i]-18,join(bits(s));size=15,anchor="middle"); end
    b*=txt(500,555,"L = 8 · Q = 4 · P = 18 · local move 0110 ↔ 1001";size=17,anchor="middle"); svg("fragmentation-graph",1000,590,b)
    open(joinpath(OUT,"fragmentation-graph.csv"),"w") do io
        println(io,"source,target")
        for (i,j) in edges; println(io,"$(join(bits(states[i]))),$(join(bits(states[j])))"); end
    end
    println("Fragmentation sector: ",n," vertices, ",length(edges)," edges")
    L=10; allowed=[s for s in 0:2^L-1 if s & (s>>1)==0]
    idx=Dict(s=>i for (i,s) in enumerate(allowed)); H=zeros(length(allowed),length(allowed))
    for (i,s) in enumerate(allowed),j in 0:L-1
        t=xor(s,1<<j)
        if haskey(idx,t); H[idx[t],i]=1; end
    end
    E,V=eigen(Symmetric(H)); z2=sum(1<<j for j in 0:2:L-1)
    v=zeros(ComplexF64,length(allowed)); v[idx[z2]]=1; w=haar(length(allowed),rng)
    ts=collect(range(0,25;length=501))
    fid=[[abs2(sum(abs2.(V'*u).*exp.(-im.*E.*t))) for t in ts] for u in [v,w]]
    b=axes(85,420,790,310,"Time (inverse PXP flip amplitude)","Return probability";title="Constrained dynamics: initial-state-dependent revivals")
    for (f,c) in zip(fid,[BLUE,RED]); b*=poly(85 .+790 .*ts./25,420 .-310 .*f;color=c); end
    for t in [0,5,10,15,20,25]; b*=txt(85+790t/25,445,string(t);size=14,anchor="middle"); end
    for y in [0,.25,.5,.75,1.]; b*=txt(72,425-310y,string(y);size=14,anchor="end"); end
    b*=txt(540,155,"Alternating product state";size=17,color=BLUE)*txt(540,183,"Random allowed-space state";size=17,color=RED)*txt(480,510,"Open chain · L = 10 · exact diagonalization · finite-size illustration";size=14,anchor="middle")
    svg("pxp-revivals",950,540,b)
    open(joinpath(OUT,"pxp-revivals.csv"),"w") do io
        println(io,"time,alternating_return,random_return")
        for i in eachindex(ts); println(io,"$(ts[i]),$(fid[1][i]),$(fid[2][i])"); end
    end
end
function extra_figures(rng)
    b=txt(35,38,"A THERMAL GAUSSIAN STATE AS A COHERENT-STATE ENSEMBLE";size=22,color=BLUE)
    cx=290; cy=280; scale=80; nbar=2.
    b*=line(65,cy,515,cy)*line(cx,65,cx,490)
    b*=txt(507,305,"q";size=17)*txt(305,80,"p";size=17)
    b*="""<defs><clipPath id="phase-panel"><rect x="65" y="65" width="450" height="425"/></clipPath></defs><g clip-path="url(#phase-panel)">"""
    for _ in 1:180
        q,p=sqrt(nbar).*randn(rng,2)
        b*=circle(cx+scale*q,cy-scale*p,3;color=BLUE,opacity=.55)
    end
    b*="</g>"
    b*="""<circle cx="350" cy="215" r="$(scale/sqrt(2))" fill="#f3c8b6" fill-opacity=".3" stroke="$RED" stroke-width="2"/>"""
    b*=txt(535,165,"Each point: one coherent state";size=18,color=BLUE)
    b*=txt(535,205,"Quantum covariance: I/2";size=18,color=RED)
    b*=txt(535,245,"Displacement covariance: n̄ I";size=18,color=BLUE)
    b*=txt(535,305,"Total covariance: (n̄ + 1/2) I";size=19)
    b*=txt(535,355,"Here n̄ = 2; points are finite samples.";size=15)
    b*=txt(535,390,"The red circle shows one state's";size=15)*txt(535,414,"one-standard-deviation quadrature width.";size=15)
    b*=txt(500,535,"Quadratures obey [q,p] = i. Classical spread and quantum uncertainty add.";size=16,anchor="middle")
    svg("gaussian-ensemble",1000,565,b)
    b=txt(35,38,"FOLDED HISTORY SPACE · A SPECIFIED PAST/FUTURE CUT";size=23,color=BLUE)
    for j in 1:6
        x=100+150*(j-1)
        b*=box(x-55,170,110,80,"a$j","(s$j, s′$j)")
        b*=line(x,100,x,170;color=BLUE)*line(x,250,x,320;color=RED)
        b*=txt(x,90,"s$j";size=19,anchor="middle",color=BLUE)*txt(x,350,"s′$j";size=19,anchor="middle",color=RED)
        if j<6; b*=line(x+55,210,x+95,210;color=INK,width=3); end
    end
    b*=line(475,70,475,375;color=RED,width=2,dash="8 5")
    b*=txt(265,410,"PAST: a1,a2,a3";size=18,anchor="middle")*txt(710,410,"FUTURE: a4,a5,a6";size=18,anchor="middle")
    b*=txt(500,465,"Schmidt coefficients across this cut define the temporal entropy.";size=17,anchor="middle")
    b*=txt(500,500,"Forward/backward indices at one time are grouped into one site.";size=17,anchor="middle")
    svg("temporal-cut",1000,535,b)
    b=txt(35,38,"DETERMINISTIC APERIODIC WORDS AND THEIR PHYSICAL CLOCK";size=22,color=BLUE)
    b*=txt(45,100,"Fibonacci: A → AB, B → A";size=21,color=BLUE)
    for (i,w) in enumerate(["A","AB","ABA","ABAAB","ABAABABA"])
        b*=txt(60,130+34i,w;size=20)
    end
    b*=txt(540,100,"Thue–Morse: A → AB, B → BA";size=21,color=RED)
    for (i,w) in enumerate(["A","AB","ABBA","ABBABAAB","ABBABAABBAABABBA"])
        b*=txt(555,130+34i,w;size=20)
    end
    b*=txt(500,365,"One symbol = one microscopic gate interval";size=19,anchor="middle")
    b*=txt(500,410,"Substitution level n counts a growing block, not one unit of time.";size=18,anchor="middle")
    b*=txt(500,448,"Uniform-time moments must include the intermediate prefixes.";size=18,anchor="middle")
    svg("aperiodic-words",1000,485,b)
end
function main()
    rng=MersenneTwister(20261020)
    conceptual_figures(rng); projected_figure(rng); scrooge_figure(rng); constrained_figures(rng); extra_figures(rng)
    println("Generated 10 original SVG figures and 3 CSV files in ",OUT)
end
main()
