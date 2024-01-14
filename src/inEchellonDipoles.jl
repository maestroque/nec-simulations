using Plots
using LaTeXStrings

f = 100e6
λ = 3e8 / f

d = λ 
k1 = 0.05:0.05:2
k2 = 0.05:0.05:1

z_s = 73.1 + 42.5 * im
Z_m = []

for horizontalDistance in k1 * λ
    zHor = []
    for verticalDistance in k2 * λ
        if isfile("out/inEchellonDipoles.out")
            rm("out/inEchellonDipoles.out")        
        end

        file = open("nec/inEchellonDipoles.nec", "w")
        write(file, "CM Dipole Antenna\n")
        write(file, "CE\n")
        write(file, "GW 1 9 0 0 0 0 0 $(λ/2) $(λ/100)\n")
        write(file, "GW 2 9 $(horizontalDistance) 0 $(verticalDistance) $(horizontalDistance) 0 $(verticalDistance + λ/2) $(λ/100)\n")
        write(file, "GE 0\n")
        write(file, "EX 0 1 5 0 1 0\n")
        write(file, "FR 0 1 0 0 100 0\n")
        write(file, "XQ\n")
        write(file, "EN\n")
        close(file)
    
        run(`nec2++ -i nec/inEchellonDipoles.nec -o out/inEchellonDipoles.out`)
    
        I_1r = parse(Float64, split(readlines("out/inEchellonDipoles.out")[108])[7])
        I_1i = parse(Float64, split(readlines("out/inEchellonDipoles.out")[108])[8])
    
        I_2r = parse(Float64, split(readlines("out/inEchellonDipoles.out")[117])[7])
        I_2i = parse(Float64, split(readlines("out/inEchellonDipoles.out")[117])[8])
    
        I_1 = I_1r + I_1i * im
        I_2 = I_2r + I_2i * im
    
        z_m = - I_2 / I_1 * z_s
        push!(zHor, z_m)    
    end
    push!(Z_m, zHor)
end

println(real(hcat(Z_m...)))
println(size(real.(hcat(Z_m...))))
println(size(k1 * λ))
println(size(k2 * λ))

gr()
contourf(k1 * λ, k2 * λ, real.(hcat(Z_m...)), title=L"R_m", xlabel="Horizontal Distance "*L"(d/λ)", ylabel="Vertical Distance "*L"(b/λ)")
contourf(k1 * λ, k2 * λ, imag.(hcat(Z_m...)), title=L"X_m", xlabel="Horizontal Distance "*L"(d/λ)", ylabel="Vertical Distance "*L"(b/λ)")
