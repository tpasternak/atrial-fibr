function extractSignal(set, signalName)
    set = "iaf4_ivc"
    signalName = "I"
    command = `rdsamp -r $set -s $signalName -c`
    stream,null = readsfrom(command)
    return [ split(strip(line),',')[2] for line in readlines(stream)] |> int
end

using Winston
function plotSignal(signal, name, range)
        plot(range, signal[range])
        file(name)
end

function extractAndPlot(set,signalName, range)
    d = extractSignal(set,signalName)
    plotSignal(d, set * "_" * signalName * ".png", range)

end

extractAndPlot("iaf4_ivc", "V1", 10000:25000)
