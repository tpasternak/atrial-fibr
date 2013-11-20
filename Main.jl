using AtrialFibr
using ArgParse
using DataDownloader
using Algebra
using Winston

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

    println("SET:        " * set)
    print(  "ENTROPY:    ")

    print(  "SIMILARITY: ")
    println(Algebra.divergence(transitionsMatrix+ 0.00000001, pattern))
    println()
end

function afPoint(set)
    const transitionsMatrix = heartRateTransitions(set) +0.000001 |> normalize
    entropy = Algebra.entropy(transitionsMatrix)
    similarity = Algebra.divergence(transitionsMatrix, pattern)
    return entropy, similarity
end

function afPoints(sets)
    x = zeros(length(sets))
    y = zeros(length(sets))
    for (i,set) in enumerate(sets)
        println("Processing set: " * set)
        x[i],y[i] = afPoint(set)
    end
    return x, y
end

function main()
    iafdb = union( map(x -> "iafdb/iaf" *string(x) * "_afw", 1:10), map(x -> "iafdb/iaf" *string(x) * "_afw", 1:10))
    fantasia = ["fantasia/f1o06"]

    redX, redY = afPoints(iafdb)
    greenX, greenY = afPoints(fantasia)
    plot(redX, redY, "r.", greenX, greenY, "g.")
    file("figure.png")

    println("FINISHED")
end

main()

