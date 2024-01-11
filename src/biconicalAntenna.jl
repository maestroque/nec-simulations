using Printf 

function necBiconicalAntenna(r_w, l, θ, d)
    numSegments = 10
    
    r = l * sin(θ)
    z = l * cos(θ) + d / 2

    x1 = r / 2
    y1 = r * sqrt(3) / 2
    x2 = r
    y2 = 0
    x3 = r / 2
    y3 = - r * sqrt(3) / 2

    @printf("GW 1 %d 0 0 %.4f %.4f %.4f %.4f %.4f\n",
            numSegments, d, x1, y1, z, r_w)
    @printf("GW 2 %d 0 0 %.4f %.4f %.4f %.4f %.4f\n",
            numSegments, d, x2, y2, z, r_w)
    @printf("GW 3 %d 0 0 %.4f %.4f %.4f %.4f %.4f\n",
            numSegments, d, x3, y3, z, r_w)
    println("GX 1 101")
    @printf("GW 4 1 0 0 %.4f 0 0 %.4f %.4f\n",
            -d, d, r_w)   

end

λ = 0.25

necBiconicalAntenna(λ / 200, 0.5λ, π / 6, λ / 20)