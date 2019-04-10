#-----------------------------------------------------------------------
#  Restart Criteria
#-----------------------------------------------------------------------

# equalfunvalhist
# The best fitness values of the last histWindow = 10 + ceil(30n/λ) generations
#	have a difference between their maximum and minimum values smaller than T_x
function equalfunvalhist(state::CMAES_State, restart::RestartState)
	currentFit = fitness(state.nOffspring)
	equalfunvalhist(currentFit, restart)
end

# TolX
# For each dimentsion, the complete (after multiplying by the step-size σ) covariance path value is less than a tolerance value
tolx(m::CMAES_Model, tol_x::Float64) = (m.σ < tol_x && all(m.σ * m.p_c .< tol_x))

# noeffectaxis
# Takes changes with respect to the main coordinate axes induced by C into account. 
#     Eigenvectors are found in the columns of matrix B and the eigenvalues from the diagonal values of D

# The following noeffectaxis criteria is always performed because it would cause an exception to occur if left alone
#    There is a third complexeigenerror that gets caught when an exception is thrown when producing the eigenvalues
#    They are defined in CMAES_Model.jl

# zeroeigenval(m::CMAES_Model) = any(m.γ .== 0.0)
# negeigenval(m::CMAES_Model) = any(m.γ .< 0.0)

# The second noeffectaxis criterion does not check all main axes at once,
#   but in generation t it takes the axis i = t mod n into account.
function noeffectaxis(m::CMAES_Model, gen::Int64)
	n = m.parms.N
	i = gen % n + 1
	m.center == m.center + (m.σ / 10.0 * m.D[i,i] * m[:eigvec, i])
end

# noeffectcoord
# Analyzes changes with respect to the coordinate axes.
# Note: using Hansen's original definition,  not Back's
noeffectcoord(m::CMAES_Model) = (m.center == m.σ * m.center / 5.0)

# Criterion conditioncov
# The condition number of the matrix C is very large
# cond(C) is max(eigenvalues) / min(eigenvalues)
conditioncov(m::CMAES_Model) = (maximum(m.γ)/minimum(m.γ) > 10.0^14)
