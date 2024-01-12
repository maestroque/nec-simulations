using Plots

f = 100e6
λ = 3e8 / f

d = λ 
k = 0.05:0.05:3

z_s = 73.1 + 42.5 * im
Z_m = []

for i in k
    rm("out/colinnearDipoles.out")

    file = open("nec/colinnearDipoles.nec", "w")
    write(file, "CM Dipole Antenna\n")
    write(file, "CE\n")
    write(file, "GW 1 9 $(-i*d/2 - λ/2) 0 0 -$(i*d/2) 0 0 $(λ/100)\n")
    write(file, "GW 2 9 $(i*d/2) 0 0 $(i*d/2 + λ/2) 0 0 $(λ/100)\n")
    write(file, "GE 0\n")
    write(file, "EX 0 1 5 0 1 0\n")
    write(file, "FR 0 1 0 0 100 0\n")
    write(file, "XQ\n")
    write(file, "EN\n")
    close(file)

    run(`nec2++ -i nec/colinnearDipoles.nec -o out/colinnearDipoles.out`)

    I_1r = parse(Float64, split(readlines("out/colinnearDipoles.out")[108])[7])
    I_1i = parse(Float64, split(readlines("out/colinnearDipoles.out")[108])[8])

    I_2r = parse(Float64, split(readlines("out/colinnearDipoles.out")[117])[7])
    I_2i = parse(Float64, split(readlines("out/colinnearDipoles.out")[117])[8])

    I_1 = I_1r + I_1i * im
    I_2 = I_2r + I_2i * im

    z_m = - I_2 / I_1 * z_s
    push!(Z_m, z_m)    
end

println(Z_m)

plot(k, real(Z_m))
plot!(k, imag(Z_m))
