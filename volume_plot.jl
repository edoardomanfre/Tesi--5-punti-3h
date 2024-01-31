using Statistics
using Plots
pyplot()
using DataFrames
using XLSX
using DelimitedFiles

function savePlots(InputParameters::InputParam, ResultsSim::Results)

    @unpack NSeg, NStage, NStates, MaxIt, conv, StepFranc, NHoursStep, NStep, LimitPump = InputParameters
    @unpack Salto, Coefficiente = ResultsSim

    scenarios = collect(1:100)
    println("Plots for scenarios $scenarios")

    NStep = InputParameters.NStep
    concatenation_production_turbines = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_production_pump = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_inflows = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_reservoir = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_price = zeros(HY.NMod, NSimScen, NStep * NStage)
    #concatenation_waterLevel_variations = zeros(HY.NMod, NSimScen, NStep * NStage)
    #concatenation_waterLevel = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_by_pass = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_u_pump = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_u_turb_1 = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_u_turb_2 = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_u_turb_3 = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_u_turb_4 = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_spillage = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_dischrge_turbine = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_discharge_pump = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_disSeg_1 = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_disSeg_2 = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_disSeg_3 = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_disSeg_4 = zeros(HY.NMod, NSimScen, NStep * NStage)
    concatenation_head = zeros(HY.NMod, NSimScen, NStep * NStage)
    #concatenation_coeff = zeros(HY.NMod, NSimScen, NStage * (HY.NDSeg[1]-1))
    
    for iMod = 1:HY.NMod
        for iScen = 1:NSimScen
            concatenation_production_turbines[iMod, iScen, :] = ResultsSim.Production[iMod, iScen, :] * InputParameters.NHoursStep
            concatenation_production_pump[iMod, iScen, :] = ResultsSim.Pumping[iMod, iScen, :] * InputParameters.NHoursStep
            concatenation_inflows[iMod, iScen, :] = ResultsSim.inflow[iMod, iScen, :]
            concatenation_reservoir[iMod, iScen, :] = ResultsSim.Reservoir[iMod, iScen, :]
            concatenation_price[iMod, iScen, :] = ResultsSim.price[iMod, iScen, :]
            #concatenation_waterLevel_variations[iMod, iScen, :] = Results_Water_levels.water_level_variations[iMod, iScen, :]
            #concatenation_waterLevel[iMod, iScen, :] = Results_Water_levels.Water_levels_Simulation[iMod, iScen, :]
            concatenation_by_pass[iMod, iScen, :] = ResultsSim.By_pass[iMod, iScen, :]
            concatenation_u_pump[iMod, iScen, :] = ResultsSim.u_pump[iScen, :]
            concatenation_u_turb_1[iMod, iScen, :] = ResultsSim.u_turb_1[iMod, iScen, :]
            concatenation_u_turb_2[iMod, iScen, :] = ResultsSim.u_turb_2[iMod, iScen, :]
            concatenation_u_turb_3[iMod, iScen, :] = ResultsSim.u_turb_3[iMod, iScen, :]
            concatenation_u_turb_4[iMod, iScen, :] = ResultsSim.u_turb_4[iMod, iScen, :]
            concatenation_spillage[iMod, iScen, :] = ResultsSim.Spillage[iMod, iScen, :]
            concatenation_dischrge_turbine[iMod, iScen, :] = ResultsSim.totDischarge[iMod, iScen, :]
            concatenation_discharge_pump[iMod, iScen, :] = ResultsSim.totPumped[iScen, :]
            concatenation_disSeg_1[iMod, iScen, :] = ResultsSim.disSeg[iMod][iScen, :, 1]
            concatenation_disSeg_2[iMod, iScen, :] = ResultsSim.disSeg[iMod][iScen, :, 2]
            concatenation_disSeg_3[iMod, iScen, :] = ResultsSim.disSeg[iMod][iScen, :, 3]
            concatenation_disSeg_4[iMod, iScen, :] = ResultsSim.disSeg[iMod][iScen, :, 4]
            concatenation_head[iMod, iScen, :] = ResultsSim.Salto[iMod, iScen, :]
        end
    end

#=    for iMod = 1:HY.NMod
        for iScen = 1:NSimScen
            concatenation_head[iMod, iScen, :] .= ResultsSim.Salto[iMod, iScen, :]

            for iSeg = 1:(HY.NDSeg[1]-1)
                concatenation_coeff[iMod, iScen, :] .= ResultsSim.Coefficiente[iMod, iScen, :, iSeg]
            end         
        end
    end=#
 

    folder = "Scenarios"
    mkdir(folder)
    cd(folder)

    for i in scenarios 
        Prod_Turbines = DataFrame()
        Prod_Pump = DataFrame()
        Prices = DataFrame()
        Inflow = DataFrame()
        Reservoir_volume = DataFrame()
        #Reservoir_level = DataFrame()
        #Variations_water = DataFrame()
        Bypass = DataFrame()
        U_pump = DataFrame()
        U_turb_1 = DataFrame()
        U_turb_2 = DataFrame()
        U_turb_3 = DataFrame()
        U_turb_4 = DataFrame()
        Spillage = DataFrame()
        Discharge_turbine = DataFrame()
        Discharge_pump = DataFrame()
        DisSeg_1 = DataFrame()
        DisSeg_2 = DataFrame()
        DisSeg_3 = DataFrame()
        DisSeg_4 = DataFrame()
        Head = DataFrame()
        #Coeff = DataFrame()

        for iStep = NStage * NStep
            for iMod = 1:HY.NMod
                Prod_Turbines[!, "Reservoir_$iMod"] = concatenation_production_turbines[iMod, i, :]
                Prod_Pump[!, "Reservoir_$iMod"] = concatenation_production_pump[iMod, i, :]
                Prices[!, "Reservoir_$iMod"] = concatenation_price[iMod, i, :]
                Inflow[!, "Reservoir_$iMod"] = concatenation_inflows[iMod, i, :]
                Reservoir_volume[!, "Reservoir_$iMod"] = concatenation_reservoir[iMod, i, :]
                #Reservoir_level[!, "Reservoir_$iMod"] = concatenation_waterLevel[iMod, i, :]
                #Variations_water[!, "Reservoir_$iMod"] = concatenation_waterLevel_variations[iMod, i, :]
                Bypass[!, "Reservoir_$iMod"] = concatenation_by_pass[iMod, i, :]
                U_pump[!, "Reservoir_$iMod"] = concatenation_u_pump[iMod, i, :]
                U_turb_1[!, "Reservoir_$iMod"] = concatenation_u_turb_1[iMod, i, :]
                U_turb_2[!, "Reservoir_$iMod"] = concatenation_u_turb_2[iMod, i, :]
                U_turb_3[!, "Reservoir_$iMod"] = concatenation_u_turb_3[iMod, i, :]
                U_turb_4[!, "Reservoir_$iMod"] = concatenation_u_turb_4[iMod, i, :]
                Spillage[!, "Reservoir_$iMod"] = concatenation_spillage[iMod, i, :]
                Discharge_turbine[!, "Reservoir_$iMod"] = concatenation_dischrge_turbine[iMod, i, :]
                Discharge_pump[!, "Reservoir_$iMod"] = concatenation_discharge_pump[iMod, i, :]
                DisSeg_1[!, "Reservoir_$iMod"] = concatenation_disSeg_1[iMod, i, :]
                DisSeg_2[!, "Reservoir_$iMod"] = concatenation_disSeg_2[iMod, i, :]
                DisSeg_3[!, "Reservoir_$iMod"] = concatenation_disSeg_3[iMod, i, :]
                DisSeg_4[!, "Reservoir_$iMod"] = concatenation_disSeg_4[iMod, i, :]
                Head[!, "Salto_$iMod"] = concatenation_head[iMod, i, :]
                #Coeff[!, "Salto_$iMod"] = concatenation_coeff[iMod, i, :]
            end
        end

        XLSX.writetable("Scenario $i.xlsx", overwrite = true,
            Prod_Turbines_MWh = (collect(DataFrames.eachcol(Prod_Turbines)), DataFrames.names(Prod_Turbines)),
            Prod_Pump_MWh = (collect(DataFrames.eachcol(Prod_Pump)), DataFrames.names(Prod_Pump)),
            Prices_€ = (collect(DataFrames.eachcol(Prices)), DataFrames.names(Prices)),
            Reservoir_volume_Mm3 = (collect(DataFrames.eachcol(Reservoir_volume)), DataFrames.names(Reservoir_volume)),
            #Reservoir_level_Mm3 = (collect(DataFrames.eachcol(Reservoir_level)), DataFrames.names(Reservoir_level)),
            #Variations_water = (collect(DataFrames.eachcol(Variations_water)), DataFrames.names(Variations_water)),
            Inflow_Mm3 = (collect(DataFrames.eachcol(Inflow)), DataFrames.names(Inflow)),
            Bypass = (collect(DataFrames.eachcol(Bypass)), DataFrames.names(Bypass)),
            U_pump = (collect(DataFrames.eachcol(U_pump)), DataFrames.names(U_pump)),
            U_turb_1 = (collect(DataFrames.eachcol(U_turb_1)), DataFrames.names(U_turb_1)),
            U_turb_2 = (collect(DataFrames.eachcol(U_turb_2)), DataFrames.names(U_turb_2)),
            U_turb_3 = (collect(DataFrames.eachcol(U_turb_3)), DataFrames.names(U_turb_3)),
            U_turb_4 = (collect(DataFrames.eachcol(U_turb_4)), DataFrames.names(U_turb_4)),
            Spillage = (collect(DataFrames.eachcol(Spillage)), DataFrames.names(Spillage)),
            Discharge_turbine_m3s = (collect(DataFrames.eachcol(Discharge_turbine)), DataFrames.names(Discharge_turbine)),
            Discharge_pump_m3s = (collect(DataFrames.eachcol(Discharge_pump)), DataFrames.names(Discharge_pump)),
            DisSeg_1 = (collect(DataFrames.eachcol(DisSeg_1)), DataFrames.names(DisSeg_1)),
            DisSeg_2 = (collect(DataFrames.eachcol(DisSeg_2)), DataFrames.names(DisSeg_2)),
            DisSeg_3 = (collect(DataFrames.eachcol(DisSeg_3)), DataFrames.names(DisSeg_3)),
            DisSeg_4 = (collect(DataFrames.eachcol(DisSeg_4)), DataFrames.names(DisSeg_4)),
            Head = (collect(DataFrames.eachcol(Head)), DataFrames.names(Head)),
            #Coeff = (collect(DataFrames.eachcol(Coeff)), DataFrames.names(Coeff))
        )
    end
end
