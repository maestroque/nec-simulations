# using Plots
# using LaTeXStrings
# using SpecialFunctions

f = 100e6
λ = 3e8 / f

d = λ 

lengths = [1/50, 1/10, 1/5]

for s in lengths
    segment_ratio = round(1 / (2 * s))
    segment_increase = 5
    segment_num = Int(segment_increase * segment_ratio) % 2 == 0 ? Int(segment_increase * segment_ratio) + 1 : Int(segment_increase * segment_ratio)
    file = open("nec/foldedDipole_$(Int(round(1/s))).nec", "w")
    write(file, "CM Folded Dipole Antenna\n")
    write(file, "CE\n")
    write(file, "GW 1 $(segment_num) -$(λ/4) 0 0 $(λ/4) 0 0 $(λ/200)\n")
    write(file, "GW 2 $(segment_increase) $(λ/4) 0 0 $(λ/4) $(s*λ) 0 $(λ/200)\n")
    write(file, "GW 3 $(segment_num) $(λ/4) $(s*λ) 0 -$(λ/4) $(s*λ) 0 $(λ/200)\n")
    write(file, "GW 4 $(segment_increase) -$(λ/4) $(s*λ) 0 -$(λ/4) 0 0 $(λ/200)\n")
    write(file, "GE 0\n")
    write(file, "EX 0 1 $(Int(round(segment_increase * segment_ratio/2) + 1)) 0 1 0\n")
    write(file, "FR 0 1 0 0 100 0\n")
    write(file, "EK\n")
    write(file, "XQ\n")
    write(file, "EN\n")
    close(file)
end

