using Printf 

function necHelicalAntenna(r_w, N, C, S)
    numSegments = 100
    l = S * N
    r = C / (2π)
    @printf("GH 1 %d %.4f %.4f %.4f %.4f %.4f %.4f %.4f\n",
            numSegments, S, l, r, r, r, r, r_w)  

end

λ = 3e8 / 6e8

necHelicalAntenna(λ / 100, 15, λ , λ / 4)