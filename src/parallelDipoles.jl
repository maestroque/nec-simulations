using Plots
using LaTeXStrings
using SpecialFunctions

function parallelMutualImpedanceAnalytic(f, lλ, dλ)
    η = 120π
    λ = 3e8 / f
    k = 2π / λ
    d = dλ * λ
    l = lλ * λ
    
    u0 = k * d
    u1 = k * (sqrt(d^2 + l^2) + l)
    u2 = k * (sqrt(d^2 + l^2) - l)

    Rm = η / 4π * (2 * cosint(u0) - cosint(u1) - cosint(u2))
    Xm = - η / 4π * (2 * sinint(u0) - sinint(u1) - sinint(u2))

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

    if isfile("out/parallelDipoles.out")
        rm("out/parallelDipoles.out")        
    end

    file = open("nec/parallelDipoles.nec", "w")
    write(file, "CM Dipole Antenna\n")
    write(file, "CE\n")
    write(file, "GW 1 5 -$(i*d/2) 0 -$(λ/4) -$(i*d/2) 0 $(λ/4) $(λ/100)\n")
    write(file, "GW 2 5 $(i*d/2) 0 -$(λ/4) $(i*d/2) 0 $(λ/4) $(λ/100)\n")
    write(file, "GE 0\n")
    write(file, "EX 0 1 5 0 1 0\n")
    write(file, "FR 0 1 0 0 100 0\n")
    write(file, "XQ\n")
    write(file, "EN\n")
    close(file)

    run(`nec2++ -i nec/parallelDipoles.nec -o out/parallelDipoles.out`)

    I_1r = parse(Float64, split(readlines("out/parallelDipoles.out")[98])[7])
    I_1i = parse(Float64, split(readlines("out/parallelDipoles.out")[98])[8])

    I_2r = parse(Float64, split(readlines("out/parallelDipoles.out")[103])[7])
    I_2i = parse(Float64, split(readlines("out/parallelDipoles.out")[103])[8])

    I_1 = I_1r + I_1i * im
    I_2 = I_2r + I_2i * im

    z_m = - I_2 / I_1 * z_s
    push!(Z_m_10, z_m)    
end

for i in k

    if isfile("out/parallelDipoles40.out")
        rm("out/parallelDipoles40.out")        
    end

    file = open("nec/parallelDipoles.nec", "w")
    write(file, "CM Dipole Antenna\n")
    write(file, "CE\n")
    write(file, "GW 1 21 -$(i*d/2) 0 -$(λ/4) -$(i*d/2) 0 $(λ/4) $(λ/100)\n")
    write(file, "GW 2 21 $(i*d/2) 0 -$(λ/4) $(i*d/2) 0 $(λ/4) $(λ/100)\n")
    write(file, "GE 0\n")
    write(file, "EX 0 1 5 0 1 0\n")
    write(file, "FR 0 1 0 0 100 0\n")
    write(file, "XQ\n")
    write(file, "EN\n")
    close(file)

    run(`nec2++ -i nec/parallelDipoles.nec -o out/parallelDipoles40.out`)

    I_1r = parse(Float64, split(readlines("out/parallelDipoles40.out")[137])[7])
    I_1i = parse(Float64, split(readlines("out/parallelDipoles40.out")[137])[8])

    I_2r = parse(Float64, split(readlines("out/parallelDipoles40.out")[159])[7])
    I_2i = parse(Float64, split(readlines("out/parallelDipoles40.out")[159])[8])

    I_1 = I_1r + I_1i * im
    I_2 = I_2r + I_2i * im

    z_m = - I_2 / I_1 * z_s
    push!(Z_m_40, z_m)    
end

Z_m_theoretic = @. parallelMutualImpedanceAnalytic(f, 0.5, k)

gr()
Plots.plot(k, real(Z_m_10), title="Parallel Dipoles - Mutual Impedance", label=L"R_{m, 10}", 
           xlabel="Horizontal Distance"*L"(d/λ)", ylabel="Mutual Impedance "*L"(Z_m)- Ω", linestyle=:dot, seriescolor = :blue)
Plots.plot!(k, imag(Z_m_10), label=L"X_{m, 10}", linestyle=:dot, seriescolor = :red)
Plots.plot!(k, real(Z_m_40), label=L"R_{m, 40}", linestyle=:dash, seriescolor = :blue)
Plots.plot!(k, imag(Z_m_40), label=L"X_{m, 40}", linestyle=:dash, seriescolor = :red)
Plots.plot!(k, first.(Z_m_theoretic), label=L"R_{m, theoretic}", seriescolor = :blue)
Plots.plot!(k, last.(Z_m_theoretic), label=L"X_{m, theoretic}", seriescolor = :red)





