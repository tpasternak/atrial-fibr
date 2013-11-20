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

function afPoints(set)
    redX = zeros(length(iafdb))
    redY = zeros(length(iafdb))
    for (i,set) in enumerate(iafdb)
        redX[i],redY[i] = afPoint(set)
    end
    return redX, redY
end

function main()
    iafdb = ["iafdb/iaf1_afw" "iafdb/iaf2_afw" "iafdb/iaf3_afw"]
    fantasia = ["fantasia/f1o06"]

    redX, redY = afPoints(iafdb)
    greenX, greenY = afPoints(fantasia)

    plot(redX, redY, "r.", greenX, greenY, "g.")
    file("figure.png")
end

main()

