using Statistics, Random, Distributions

"""
    hybrid_montecarlo(action, drift, dof, ϵ, Nsample, Ninterval)

Make samples by the hybrid monte carlo algorithm.
"""
function hybrid_montecarlo(action, drift, dof, Nsample)
        ϵ = 0.01
        Ninterval = 10
        conf = []
        x = zeros(dof)

        for isample in 1:Nsample
                println("Make $(isample)-th sample")
                num_of_traj = 1
                num_of_trial = 1
                while num_of_traj < Ninterval
                        println("Make $(num_of_traj)-th trajectory")
                        # Initial condition
                        p = rand(Normal(), dof)

                        # Initial energy
                        Eini = 0.5*sum(p.*p) + action(x)

                        # Molecular dynamics
                        p, x_trial = molecular_dynamics(p, x, ϵ, drift)

                        # Final energy
                        Efin = 0.5*sum(p.*p) + action(x_trial)

                        # Accept / Reject
                        accept, num_of_trial, num_of_traj = metropolis_test(Eini, Efin, num_of_trial, num_of_traj)
                        if accept
                                x = x_trial
                        end
                end
                push!(conf, x)
        end
        return conf
end

"""
    molecular_dynamics(p, x, ϵ, drift)

Solve a Hamilton's EOM by the Leapfrog scheme.
"""
function molecular_dynamics(p, x, ϵ, drift)
        p += ϵ * 0.5 * drift(x)
        for n in 1:Int(1.0/ϵ)
                x += ϵ * p
                p += ϵ * drift(x)
        end
        x += ϵ * p
        p += ϵ * 0.5 * drift(x)
        return p, x
end

"""
    metropolis_test(Eini, Efin, num_of_trial, num_of_traj)

Returns true if ``r < \\mathrm{min}(1, e^{-(E_\\text{fin} - E_\\text{ini})})``,
where ``r`` is a uniform random number in ``(0,1)``.
"""
function metropolis_test(Eini, Efin, num_of_trial, num_of_traj)
        Edif = Efin - Eini
        println("At $(num_of_trial)-th try, Edif=$Edif")

        if rand() < minimum([1.0, exp(-Edif)])
                println("Accepted")
                num_of_traj += 1
                num_of_trial = 1
                return true, num_of_trial, num_of_traj
        else
                println("Rejected")
                num_of_trial += 1
                return false, num_of_trial, num_of_traj
        end
end


action(x) = sum(x.^2/2) # action S(x)
drift(x) = -x # drift term -dS/dx
obs(x) = sum(x.^2) # observable O(x)

dof = 1000 # degrees of freedom
Nsample = 1000 # number of samples

# make samples
conf = hybrid_montecarlo(action, drift, dof, Nsample)

# calculate the observable
println(mean(obs.(conf)))


""" Tips
"""
# Any dotted function can be applied elementwise to any array.
# For example, sin.([a1, a2, ...]) = [sin(a1), sin(a1), ...].
```julia
julia> A = [1.0, 2.0, 3.0]
3-element Array{Float64,1}:
 1.0
 2.0
 3.0

julia> sin.(A)
3-element Array{Float64,1}:
 0.8414709848078965
 0.9092974268256817
 0.1411200080598672

julia> A.^2
3-element Array{Float64,1}:
 1.00
 2.00
 3.00
```
