import AtrialFibr
using ArgParse

function execute(set)
    stream = AtrialFibr.downloadAllFiles(set)
    lines = readlines(stream)
    distances = map ((x) -> int(strip(x)), lines)[2:]
    markovTransitions = AtrialFibr.markovChainTransitions(distances)
    showcompact(markovTransitions)
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

main(ARGS)
