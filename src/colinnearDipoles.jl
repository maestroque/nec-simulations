using Plots
using LaTeXStrings
using SpecialFunctions

function colinnearMutualImpedanceAnalytic(f, lλ, dλ)
    η = 120π
    λ = 3e8 / f
    k = 2π / λ
    d = dλ * λ
    l = lλ * λ
    h = l + d
    
    v0 = k * h
    v1 = 2k * (h + l)
    v2 = 2k * (h - l)
    v3 = (h^2 - l^2) / h^2

    Rm = - η / (8π) * cos(v0) * (-2cosint(2v0) + cosint(v2) + cosint(v1) - log(v3)) +
           η / (8π) * sin(v0) * (2sinint(2v0) - sinint(v2) - sinint(v1))
    Xm = - η / (8π) * cos(v0) * (2sinint(2v0) - sinint(v2) - sinint(v1)) + 
           η / (8π) * sin(v0) * (2cosint(2v0) - cosint(v2) - cosint(v1) - log(v3))

    return Rm, Xm
end

f = 100e6
λ = 3e8 / f

d = λ 
k = 0.05:0.05:3

z_s = 73.1 + 42.5 * im
Z_m_10 = []
Z_m_40 = []

for i in k

    if isfile("out/collinearDipoles.out")
        rm("out/collinearDipoles.out")        
    end

    file = open("nec/colinnearDipoles.nec", "w")
    write(file, "CM Dipole Antenna\n")
    write(file, "CE\n")
    write(file, "GW 1 5 $(-i*d/2 - λ/2) 0 0 -$(i*d/2) 0 0 $(λ/100)\n")
    write(file, "GW 2 5 $(i*d/2) 0 0 $(i*d/2 + λ/2) 0 0 $(λ/100)\n")
    write(file, "GE 0\n")
    write(file, "EX 0 1 5 0 1 0\n")
    write(file, "FR 0 1 0 0 100 0\n")
    write(file, "XQ\n")
    write(file, "EN\n")
    close(file)

    run(`nec2++ -i nec/colinnearDipoles.nec -o out/colinnearDipoles.out`)

    I_1r = parse(Float64, split(readlines("out/colinnearDipoles.out")[98])[7])
    I_1i = parse(Float64, split(readlines("out/colinnearDipoles.out")[98])[8])

    I_2r = parse(Float64, split(readlines("out/colinnearDipoles.out")[103])[7])
    I_2i = parse(Float64, split(readlines("out/colinnearDipoles.out")[103])[8])

    I_1 = I_1r + I_1i * im
    I_2 = I_2r + I_2i * im

    z_m = - I_2 / I_1 * z_s
    push!(Z_m_10, z_m)    
end

for i in k

    if isfile("out/collinearDipoles.out")
        rm("out/collinearDipoles.out")        
    end

    file = open("nec/colinnearDipoles.nec", "w")
    write(file, "CM Dipole Antenna\n")
    write(file, "CE\n")
    write(file, "GW 1 21 $(-i*d/2 - λ/2) 0 0 -$(i*d/2) 0 0 $(λ/100)\n")
    write(file, "GW 2 21 $(i*d/2) 0 0 $(i*d/2 + λ/2) 0 0 $(λ/100)\n")
    write(file, "GE 0\n")
    write(file, "EX 0 1 5 0 1 0\n")
    write(file, "FR 0 1 0 0 100 0\n")
    write(file, "XQ\n")
    write(file, "EN\n")
    close(file)

    run(`nec2++ -i nec/colinnearDipoles.nec -o out/colinnearDipoles.out`)

    I_1r = parse(Float64, split(readlines("out/colinnearDipoles.out")[137])[7])
    I_1i = parse(Float64, split(readlines("out/colinnearDipoles.out")[137])[8])

    I_2r = parse(Float64, split(readlines("out/colinnearDipoles.out")[159])[7])
    I_2i = parse(Float64, split(readlines("out/colinnearDipoles.out")[159])[8])

    I_1 = I_1r + I_1i * im
    I_2 = I_2r + I_2i * im

    z_m = - I_2 / I_1 * z_s
    push!(Z_m_40, z_m)    
end

Z_m_theoretic = @. colinnearMutualImpedanceAnalytic(f, 0.5, k)

gr()
Plots.plot(k, real(Z_m_10), title="Colinnear Dipoles - Mutual Impedance", label=L"R_{m, 10}", 
           xlabel="Horizontal Distance"*L"(d/λ)", ylabel="Mutual Impedance "*L"(Z_m) - Ω", linestyle=:dot, seriescolor = :blue)
Plots.plot!(k, imag(Z_m_10), label=L"X_{m, 10}", linestyle=:dot, seriescolor = :red)
Plots.plot!(k, real(Z_m_40), label=L"R_{m, 40}", linestyle=:dash, seriescolor = :blue)
Plots.plot!(k, imag(Z_m_40), label=L"X_{m, 40}", linestyle=:dash, seriescolor = :red)
Plots.plot!(k, first.(Z_m_theoretic), label=L"R_{m, theoretic}", seriescolor = :blue)
Plots.plot!(k, last.(Z_m_theoretic), label=L"X_{m, theoretic}", seriescolor = :red)
