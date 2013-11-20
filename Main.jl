using AtrialFibr
using ArgParse
using DataDownloader
using Algebra

function execute(set)
    set |>
    heartRateTransitions |>
    showcompact
    println("")
end

function heartRateTransitions(set)
        return set |>
        DataDownloader.heartRateSeries |>
        AtrialFibr.markovChainTransitions
end

const pattern = [0.056 0.114 0.062; 0.101 0.350 0.096; 0.060 0.114 0.035]

function printParameters(set)
    const transitionsMatrix = heartRateTransitions(set)
    println("SET:        " * set)
    print(  "ENTROPY:    ")
    println(Algebra.entropy(normalize(transitionsMatrix + 0.00000001)))
    print(  "SIMILARITY: ")
    println(Algebra.divergence(transitionsMatrix+ 0.00000001, pattern))
    println()
end

printParameters("fantasia/f1o06")
printParameters("iafdb/iaf1_afw")



