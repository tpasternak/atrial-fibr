using AtrialFibr
using ArgParse
using DataDownloader

function execute(set)
    set |>
    DataDownloader.heartRateSeries |>
    AtrialFibr.markovChainTransitions |>
    showcompact
    println("")
end

function main(args)
    s = ArgParseSettings()
    @add_arg_table s begin
        "dataset"
            nargs = 1
    end
    parsed_args = parse_args(s)
    execute(parsed_args["dataset"][1])
end

execute("fantasia/f1o06")
