using MERIT
using BenchmarkTools
using Profile
using PProf
using ProfileView

# function testfnc(signal, frequencies, points, timeDelays)
#     image = abs.(MERIT.Beamform.beamform(signal, frequencies, points, timeDelays))
# end

function testing(n)
    for i = 1:n
        scan = BreastScan{Float32, ComplexF32, UInt32}()
        domain_hemisphere!(scan, 2.5e-3, 7e-2+5e-3)
        load_scans!(scan,"data/B0_P3_p000.csv" , "data/B0_P3_p036.csv", ',')
        load_frequencies!(scan, "data/frequencies.csv", ',')
        load_antennas!(scan, "data/antenna_locations.csv", ',')
        load_channels!(scan, "data/channel_names.csv", ',')
        scan.delayFunc = get_delays(Float32(8.0))
        scan.beamformerFunc = DAS
        imgCom = beamform(scan)
        image = abs.(imgCom)
        imageSlice = get_slice(image, scan, 35e-3)
        println(size(imageSlice))
        plot_scan(imageSlice, scan)
    end
end
testing(1)
# ProfileView.@profview testing(1)
# Profile.Allocs.clear()
# Profile.Allocs.@profile sample_rate=0.1 testing()
# PProf.Allocs.pprof(from_c = false)