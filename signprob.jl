using Plots, Statistics, Random, Distributions

deno(x, p) = exp(im*p*x)
nume(x, p) = x^2 * exp(im*p*x)
Obs(x, p) = abs(nume(x, p) / deno(x, p) / (1-p^2))

Nsample = 10000
list_p = 0:2:100
list_obs = [mean(Obs.(rand(Normal(), Nsample), p)) for p in list_p]

plot(list_p, list_obs, yaxis=:log, seriestype=:scatter)
