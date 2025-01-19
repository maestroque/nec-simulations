# using Plots
# using LaTeXStrings
# using SpecialFunctions

f = 3e6
λ = 3e8 / f

d = λ 
w = 0.02
h = λ / 4
l = 5λ
Z_L = round(138 * log10(4 * h / w), digits=2)

file = open("nec/wireAntennaPerfectGround.nec", "w")
write(file, "CM Wire Antenna\n")
write(file, "CE\n")
write(file, "GW 1 100 0 0 $(λ/4) $(5λ) 0 $(λ/4) $(w)\n")
write(file, "GW 2 3 0 0 0 0 0 $(λ/4) $(w)\n")
write(file, "GW 3 3 $(5λ) 0 $(λ/4) $(5λ) 0 0 $(w)\n")
write(file, "GE 0\n")
write(file, "LD	0 3 1 3 $(Z_L)\n")
write(file, "GN 1\n")
write(file, "EK\n")
write(file, "EX 0 1 1 0 1 0\n")
write(file, "FR 0 0 0 0 3 0\n")
write(file, "EN\n")
close(file)

file = open("nec/wireAntennaFastGround.nec", "w")
write(file, "CM Wire Antenna\n")
write(file, "CE\n")
write(file, "GW 1 100 0 0 $(λ/4) $(5λ) 0 $(λ/4) $(w)\n")
write(file, "GW 2 3 0 0 0 0 0 $(λ/4) $(w)\n")
write(file, "GW 3 3 $(5λ) 0 $(λ/4) $(5λ) 0 0 $(w)\n")
write(file, "GE 0\n")
write(file, "LD	0 3 1 3 $(Z_L)\n")
write(file, "GN 0 0 0 0 13 .005\n")
write(file, "EK\n")
write(file, "EX 0 1 1 0 1 0\n")
write(file, "FR 0 0 0 0 3 0\n")
write(file, "EN\n")
close(file)