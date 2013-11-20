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

const fantasia = [
	"fantasia/f1o01"
	"fantasia/f1o02"
	"fantasia/f1o03"
	"fantasia/f1o04"
	"fantasia/f1o05"
	"fantasia/f1o06"
	"fantasia/f1o07"
	"fantasia/f1o08"
	"fantasia/f1o09"
	"fantasia/f1o10"
	"fantasia/f1y01"
	"fantasia/f1y02"
	"fantasia/f1y03"
	"fantasia/f1y04"
	"fantasia/f1y05"
	"fantasia/f1y06"
	"fantasia/f1y07"
	"fantasia/f1y08"
	"fantasia/f1y09"
	"fantasia/f1y10"
	"fantasia/f2o01"
	"fantasia/f2o02"
	"fantasia/f2o03"
	"fantasia/f2o04"
	"fantasia/f2o05"
	"fantasia/f2o06"
	"fantasia/f2o07"
	"fantasia/f2o08"
	"fantasia/f2o09"
	"fantasia/f2o10"
	"fantasia/f2y01"
	"fantasia/f2y02"
	"fantasia/f2y03"
	"fantasia/f2y04"
	"fantasia/f2y05"
	"fantasia/f2y06"
	"fantasia/f2y07"
	"fantasia/f2y08"
	"fantasia/f2y09"
	"fantasia/f2y10"]
const iafdb = union( map(x -> "iafdb/iaf" *string(x) * "_afw", 1:8), map(x -> "iafdb/iaf" *string(x) * "_afw", 1:8))

function main()
    redX, redY = afPoints(iafdb)
    greenX, greenY = afPoints(fantasia)
    plot(redX, redY, "r.", greenX, greenY, "g.")
    file("figure.png")

    println("FINISHED")
end

main()

