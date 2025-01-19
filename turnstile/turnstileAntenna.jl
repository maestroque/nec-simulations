# using Plots
# using LaTeXStrings
# using SpecialFunctions

f = 400e6
λ = 3e8 / f

d = λ 
k = 0.05:0.05:3

file = open("nec/turnstileAntenna.nec", "w")
write(file, "CM Turnsti;e Antenna\n")
write(file, "CE\n")
write(file, "GW 1 21 -$(λ/2) 0 0 $(λ/2) 0 0 $(λ/100)\n")
write(file, "GW 2 21 0 -$(λ/2) $(λ/20) 0 $(λ/2) $(λ/20) $(λ/100)\n")
write(file, "GE 0\n")
write(file, "EX 0 1 11 0 1 0\n")
write(file, "EX 0 2 11 0 0 1\n")
write(file, "FR 0 1 0 0 400 0\n")
write(file, "XQ\n")
write(file, "EN\n")
close(file)