abstract type Verbose end
abstract type VerboseRun <: Verbose end
abstract type VerboseRestart <: VerboseRun end
abstract type VerboseReturn <: VerboseRestart end

struct ReturnLevel <: VerboseReturn end
struct RestartLevel <: VerboseRestart end
struct RunLevel <: VerboseRun end
struct NotVerbose <: Verbose end

isverbose(v::Verbose) = true
isverbose(nv::NotVerbose) = false

atlevel(verbose::Verbose, level::Type) = (supertype(level) <: supertype(typeof(verbose)))

#-----------------------------------------------
#  default EA println() routines used for verbose mode


function println(returnInfo::ReturnInfo)
	state = returnInfo.state
	(bestChr, bestFit) = best(state)
	(bestChr_shadow, bestFit_shadow) = best_(state)
	println("\n$(state.status): gen = $(gen(state)),  evals = $(evals(state)), evals_shadow = $(evals_(state))")
	println("best: fit[$bestFit]")
	println("best: shadow_fit[$bestFit_shadow]")
	println("best chr$bestChr")
	println("best shadow chr$bestChr_shadow")
end

function println(returnInfo::ReReturnInfo, restart::RestartState)
    state = finalstate(returnInfo)
    (bestChr, bestFit, bestRep) = returnInfo.best
	(bestChr_shadow, bestFit_shadow) = returnInfo.best_shadow
    currentRep = reps(returnInfo)
    println("\n$(state.status): after $(evals(restart)) evals and evals_shadow = $(evals_(restart)), at gen = $(gen(state)) within rep = $(reps(returnInfo))")
    print("best: ")
    if currentRep == bestRep
    	println("fit[$bestFit]")
		println("shadow fit[$bestFit_shadow]")
    else
    	println("found during rep = $bestRep")
    	println("      fit[$bestFit]")
		println("  shadow fit[$bestFit_shadow]")
    end
    println("      chr$bestChr")
	println("  shadow chr$bestChr_shadow")
end
