(* ::Package:: *)

(*Supplementary material Sabine C. Fischer, Elena Corujo-Sim\[OAcute]n, Joaqu\[IAcute]n Lilao, Ernst H.K. Stelzer and Silvia Mu\[NTilde]oz-Descalzo, "The transition from local to global patterns governs the differentiation of mouse blastocysts"*)


BeginPackage["fourPop`"];


colourNumNeigh::usage="assign binary feature to list of centroids depending on number of neighbours starting with centroids with startNum neighbours and up to propPos
(deterministic), if shuffeled == True, teh order of centroids with the same number of neighbours is shuffeled";


simulateICM::usage="assign one of four features to lists of centroids";


correctAssignedCells::usage="evaluate match between simulation and data for population of single cell";


evaluateOneEmbryo::usage="combine list from simulate ICM with orginal values for TE to get simulation of embryo and then evaluate population 
composition and neighbour composition";


plotEvaluation::usage="plot results from parameter scan: correctly assigned population per cell, population distribution, neighbour distribution"


scanModel::usage="perform simulations for the four population model and save the relevant results"


Begin["`Private`"]; (* Begin Private Context *) 


(* ::Input::Initialization:: *)
colourNumNeigh[centroidsNumNeighICM_,propPos_,colPos_,colNeg_,startNum_:9,shuffeled_:False]:=Block[{sortedByNumNeigh,shuffledInGroups,sortedCentroids},
sortedByNumNeigh=SortBy[{#[[1]],#[[2]],Abs[#[[2]]-startNum]}&/@centroidsNumNeighICM,#[[-1]]&];
sortedCentroids=If [shuffeled,
(shuffledInGroups=Flatten[RandomSample[#,Length[#]]&/@Values[GroupBy[sortedByNumNeigh,#[[-1]]&]],1];
shuffledInGroups[[All,1]]),
sortedByNumNeigh[[All,1]]];
Join[{colPos,#}&/@sortedCentroids[[1;;Round[propPos*Length[sortedCentroids]]]],{colNeg,#}&/@sortedCentroids[[Round[propPos*Length[sortedCentroids]]+1;;-1]]]
]


(* ::Input::Initialization:: *)
genPopulation[val1_,val2_]:={val1[[1]]<>val2[[1]],val1[[2]]}


(* ::Input::Initialization:: *)
simulateICM[nucleiFeatures_,propGata6Pos_,propNanogPos_,startNum_:9,shuffeled_:False]:=Block[{centroidsICM,randomICMGata6,numNeighICMNanog,centroidsNumNeighICM},
randomICMGata6=Table[centroidsICM="Centroid"/.Select[nucleiFeatures[[i]],("Identity.km"/.#)!="TE"&];
{If[RandomReal[]>1-propGata6Pos,"G+","G-"],#}&/@centroidsICM,{i,1,Length[nucleiFeatures]}];
numNeighICMNanog=Table[centroidsNumNeighICM={"Centroid","DCGNeighborCount"}/.Select[nucleiFeatures[[i]],("Identity.km"/.#)!="TE"&];
colourNumNeigh[centroidsNumNeighICM,propNanogPos,"N+","N-",startNum,shuffeled],{i,1,Length[nucleiFeatures]}];
Table[Table[genPopulation[Select[numNeighICMNanog[[j]],#[[2]]==randomICMGata6[[j,i,2]]&][[1]],randomICMGata6[[j,i]]],{i,1,Length[randomICMGata6[[j]]]}]/.{"N+G-"->"EPI","N-G+"->"PRE","N-G-"->"DN","N+G+"->"DP"},{j,1,Length[randomICMGata6]}]
]


(* ::Input::Initialization:: *)
correctAssignedCells[nucleiFeatures_,clusterICMrep_,lineageKey_:"Identity.km",populationKey_:"Identity.km"]:=Block[{dataPerEmbryo,dataPerCell,clusterICMPerEmbryo,clusterICMPerCell,correctPerEmbryo,correctPerPopulation,correctPerCell},
dataPerEmbryo=Table[{populationKey,"Centroid"}/.Select[nucleiFeatures[[i]],(lineageKey/.#)!="TE"&],{i,1,Length[nucleiFeatures]}];
dataPerCell=Flatten [dataPerEmbryo,1];
clusterICMPerEmbryo=clusterICMrep;
clusterICMPerCell=Flatten[#,1]&/@clusterICMPerEmbryo;
(*simulationPerCell=Flatten[List@@Tally/@GroupBy[Flatten[clusterICMrep,2],#[[2]]&],1];*)
(*Table[{data[[i,2]],N@If[#!={},#[[1,2]]/100,0]&@Select[simulationPerCell,#[[1]]==Reverse@data[[i]]&]},{i,1,Length[data]}]*)
correctPerEmbryo=Table[(N@Length[Intersection[#[[i]],dataPerEmbryo[[i]]]]/Length[dataPerEmbryo[[i]]])&/@clusterICMPerEmbryo,{i,1,Length[dataPerEmbryo]}];
correctPerCell=Table[N@Length[Intersection[clusterICMPerCell[[i]],dataPerCell]]/Length[dataPerCell],{i,1,Length[clusterICMPerCell]}];
correctPerPopulation={#,Table[N@Count[Intersection[clusterICMPerCell[[i]],dataPerCell],{#,_}]/Count[dataPerCell,{#,_}],{i,1,Length[clusterICMPerCell]}]}&/@{"DN","DP","EPI","PRE"};
{correctPerEmbryo,correctPerCell,correctPerPopulation}
]


(* ::Input::Initialization:: *)
evaluateOneEmbryo[oneSimICM_,nucleiFeatures_,dcgGraph_,lineageKey_:"Identity.km",populationKey_:"Identity.km"]:=Block[{populationsCount,simEmbryo,neighbourCompPop,propNeighboursOfPrEICM,propNeighboursOfEpiICM,propNeighboursOfDNICM,propNeighboursOfDPICM,distIdent,numNeighboursOfPrEICM,numNeighboursOfEpiICM,numNeighboursOfDNICM,numNeighboursOfDPICM},
populationsCount=Count[oneSimICM[[All,1]],#]&/@{"DN","DP","EPI","PRE"};
simEmbryo=Join[oneSimICM,Select[{lineageKey,"Centroid"}/.nucleiFeatures,#[[1]]=="TE"&]];
neighbourCompPop=Table[{oneSimICM[[j]],Select[simEmbryo,GraphDistance[dcgGraph[[2]],oneSimICM[[j,2]],#[[2]],Method->"UnitWeight"]==1&]},{j,1,Length[oneSimICM]}];

propNeighboursOfPrEICM=Table[{pop,If[Length[#]>0,N@Count[#,pop]/Length[#],0]&/@Select[neighbourCompPop,#[[1,1]]=="PRE"&][[All,2,All,1]]},{pop,{"TE","DN","DP","EPI","PRE"}}];
propNeighboursOfEpiICM=Table[{pop,If[Length[#]>0,N@Count[#,pop]/Length[#],0]&/@Select[neighbourCompPop,#[[1,1]]=="EPI"&][[All,2,All,1]]},{pop,{"TE","DN","DP","EPI","PRE"}}];
propNeighboursOfDNICM=Table[{pop,If[Length[#]>0,N@Count[#,pop]/Length[#],0]&/@Select[neighbourCompPop,#[[1,1]]=="DN"&][[All,2,All,1]]},{pop,{"TE","DN","DP","EPI","PRE"}}];
propNeighboursOfDPICM=Table[{pop,If[Length[#]>0,N@Count[#,pop]/Length[#],0]&/@Select[neighbourCompPop,#[[1,1]]=="DP"&][[All,2,All,1]]},{pop,{"TE","DN","DP","EPI","PRE"}}];
Sow[distIdent={EuclideanDistance[#[[2]],Mean[oneSimICM[[All,2]]]],#[[1]]}&/@oneSimICM];numNeighboursOfPrEICM=Table[{pop,If[Length[#]>0,N@Count[#,pop],0]&/@Select[neighbourCompPop,#[[1,1]]=="PRE"&][[All,2,All,1]]},{pop,{"TE","DN","DP","EPI","PRE"}}];
numNeighboursOfEpiICM=Table[{pop,If[Length[#]>0,N@Count[#,pop],0]&/@Select[neighbourCompPop,#[[1,1]]=="EPI"&][[All,2,All,1]]},{pop,{"TE","DN","DP","EPI","PRE"}}];
numNeighboursOfDNICM=Table[{pop,If[Length[#]>0,N@Count[#,pop],0]&/@Select[neighbourCompPop,#[[1,1]]=="DN"&][[All,2,All,1]]},{pop,{"TE","DN","DP","EPI","PRE"}}];
numNeighboursOfDPICM=Table[{pop,If[Length[#]>0,N@Count[#,pop],0]&/@Select[neighbourCompPop,#[[1,1]]=="DP"&][[All,2,All,1]]},{pop,{"TE","DN","DP","EPI","PRE"}}];

Sow[distIdent={EuclideanDistance[#[[2]],Mean[oneSimICM[[All,2]]]],#[[1]]}&/@oneSimICM];
{distIdent,populationsCount,
If[populationsCount[[1]]>0,Mean[#]&/@Transpose[Select[Transpose[propNeighboursOfDNICM[[All,2]]],Total[#]>0&]],{0,0,0,0}],If[populationsCount[[2]]>0,Mean[#]&/@Transpose[Select[Transpose[propNeighboursOfDPICM[[All,2]]],Total[#]>0&]],{0,0,0,0}],
If[populationsCount[[3]]>0,Mean[#]&/@Transpose[Select[Transpose[propNeighboursOfEpiICM[[All,2]]],Total[#]>0&]],{0,0,0,0}],If[populationsCount[[4]]>0,Mean[#]&/@Transpose[Select[Transpose[propNeighboursOfPrEICM[[All,2]]],Total[#]>0&]],{0,0,0,0}],
If[populationsCount[[1]]>0,Mean[#]&/@Transpose[Select[Transpose[numNeighboursOfDNICM[[All,2]]],Total[#]>0&]],{0,0,0,0}],If[populationsCount[[2]]>0,Mean[#]&/@Transpose[Select[Transpose[numNeighboursOfDPICM[[All,2]]],Total[#]>0&]],{0,0,0,0}],
If[populationsCount[[3]]>0,Mean[#]&/@Transpose[Select[Transpose[numNeighboursOfEpiICM[[All,2]]],Total[#]>0&]],{0,0,0,0}],If[populationsCount[[4]]>0,Mean[#]&/@Transpose[Select[Transpose[numNeighboursOfPrEICM[[All,2]]],Total[#]>0&]],{0,0,0,0}]}
];


(* ::Input::Initialization:: *)
plotEvaluation[scanRes_]:=Block[{numCorrect,distrPop,distrNeigh},
numCorrect=BoxWhiskerChart[Join[{Mean/@("correctPerEmbryo"/.scanRes)},{("correctPerCell"/.scanRes)},#[[2]]&/@("correctPerPopulation"/.scanRes)],ImageSize->350,ChartLabels->{Style[#,Black,FontFamily->"Arial",20]&/@{"em-\nbryo","cell","DN","DP","N+/\nG-","N-/\nG+"}},Frame->{True,True,False,False},FrameStyle->Directive[Black,FontFamily->"Arial",20],ChartStyle->Gray,PlotLabel->(Style[#,Black,FontFamily->"Arial",20]&@"correctly assigned ratios")];
distrPop=Labeled[BarChart[Mean["populationCount"/.scanRes],BarSpacing->1,ChartLayout->"Percentile",ImageSize->350,ChartStyle->{Lighter[Orange,0.7],Gray,Darker[Purple],Darker[Green,0.7]},ChartLabels->{{"early","mid","late"},None},PlotLabel->(Style[#,Black,FontFamily->"Arial",20]&@"population"),AxesStyle->Directive[Black,FontFamily->"Arial",20]], SwatchLegend[{Lighter[Orange,0.7],Gray,Darker[Purple],Darker[Green,0.7]},{"DN","DP","EPI","PRE"},LegendLayout->"Row"]];
distrNeigh=BarChart[{Mean[#]&@("mPropNeighboursOfDNICM"/.#),Mean[#]&@("mPropNeighboursOfDPICM"/.#),Mean[#]&@("mPropNeighboursOfEpiICM"/.#),Mean[#]&@("mPropNeighboursOfPrEICM"/.#)},ChartLayout->"Stacked",ChartStyle->{Lighter[Blue,0.8],Lighter[Orange,0.7],Gray,Darker[Purple],Darker[Green,0.7]},AxesStyle->Directive[Black,FontFamily->"Arial",20],ChartLabels->{Style[#,Black,FontFamily->"Arial",20]&/@{"DN","DP","N+/G-","N-/G+"},None},PlotLabel->(Style[#,Black,FontFamily->"Arial",20]&@"neighbour distribution"),ImageSize->350]&@scanRes;
Row[{numCorrect,distrPop,distrNeigh},"    "]]


scanModel[nucleiFeatures_,dcgGraphs_,propGata6_,propNanog_,startNumNeigh_,shuffeled_:False,numSimulations_:100,
lineageKey_:"Identity.km",populationKey_:"Identity.km",exportPath_:NotebookDirectory[]]:=
Block[{clusterICM,correctPerEmbryo,correctPerCell,correctPerPopulation,res,distIdent,populationCount,
mPropNeighboursOfDNICM,mPropNeighboursOfDPICM,mPropNeighboursOfEpiICM,mPropNeighboursOfPrEICM,mNumNeighboursOfDNICM,
mNumNeighboursOfDPICM,mNumNeighboursOfEpiICM,mNumNeighboursOfPrEICM},
clusterICM=Table[simulateICM[nucleiFeatures,propGata6,propNanog,startNumNeigh,shuffeled],{numSimulations}];
{correctPerEmbryo,correctPerCell,correctPerPopulation}=correctAssignedCells[nucleiFeatures,clusterICM,lineageKey,populationKey];
{distIdent,populationCount,mPropNeighboursOfDNICM,mPropNeighboursOfDPICM,mPropNeighboursOfEpiICM,mPropNeighboursOfPrEICM,
mNumNeighboursOfDNICM,mNumNeighboursOfDPICM,mNumNeighboursOfEpiICM,mNumNeighboursOfPrEICM}=
Transpose[Table[If[Mod[j,10]==0,Print[j],None];res=Transpose[Table[evaluateOneEmbryo[clusterICM[[j,i]],nucleiFeatures[[i]],
dcgGraphs[[i]],lineageKey,populationKey],{j,1,Length[clusterICM]}]];Join[{res[[1]]},N[Mean/@(Select[#,Total[#]>0&]&/@res[[2;;-1]])]],
{i,1,Length[nucleiFeatures]}]];
(*each value is averaged over simulations per embryo, results in number of embryos values*)
Export[FileNameJoin[{exportPath,
"ModelSimulation","scan"<>DateString["ISODate"]<>"g"<>ToString[propGata6]<>"n"<>ToString[propNanog]<>"s"<>ToString[startNumNeigh]<>".mx"}],
{"propGata6"->propGata6,"propNanog"->propNanog,"startNumNeigh"->startNumNeigh,"clusterICM"->clusterICM,
"correctPerEmbryo"->correctPerEmbryo,"correctPerCell"->correctPerCell,"correctPerPopulation"->correctPerPopulation,
"distIdent"->distIdent,"populationCount"->populationCount,"mPropNeighboursOfDNICM"->mPropNeighboursOfDNICM,
"mPropNeighboursOfDPICM"->mPropNeighboursOfDPICM,"mPropNeighboursOfEpiICM"->mPropNeighboursOfEpiICM,
"mPropNeighboursOfPrEICM"->mPropNeighboursOfPrEICM,"mNumNeighboursOfDNICM"->mNumNeighboursOfDNICM,
"mNumNeighboursOfDPICM"->mNumNeighboursOfDPICM,"mNumNeighboursOfEpiICM"->mNumNeighboursOfEpiICM,
"mNumNeighboursOfPrEICM"->mNumNeighboursOfPrEICM}]
]


End[];(* End Private Context *)


EndPackage[];
