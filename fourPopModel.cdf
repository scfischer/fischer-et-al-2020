(* Content-type: application/vnd.wolfram.cdf.text *)

(*** Wolfram CDF File ***)
(* http://www.wolfram.com/cdf *)

(* CreatedBy='Mathematica 11.3' *)

(***************************************************************************)
(*                                                                         *)
(*                                                                         *)
(*  Under the Wolfram FreeCDF terms of use, this file and its content are  *)
(*  bound by the Creative Commons BY-SA Attribution-ShareAlike license.    *)
(*                                                                         *)
(*        For additional information concerning CDF licensing, see:        *)
(*                                                                         *)
(*         www.wolfram.com/cdf/adopting-cdf/licensing-options.html         *)
(*                                                                         *)
(*                                                                         *)
(***************************************************************************)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[      1088,         20]
NotebookDataLength[     34812,        814]
NotebookOptionsPosition[     33082,        775]
NotebookOutlinePosition[     33425,        790]
CellTagsIndexPosition[     33382,        787]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell["Population simuulations ", "Title",
 CellChangeTimes->{
  3.694925057297426*^9, {3.714036297622506*^9, 3.7140363109973116`*^9}, {
   3.753609044312745*^9, 3.7536090649999065`*^9}, 3.777720671618744*^9, {
   3.781350173417123*^9, 
   3.7813501778871455`*^9}},ExpressionUUID->"002c1775-e511-4709-8b44-\
eb65318b917a"],

Cell[CellGroupData[{

Cell["\<\
Supplementary material Sabine C. Fischer, Elena Corujo-Sim\[OAcute]n, Joaqu\
\[IAcute]n Lilao, Ernst H.K. Stelzer and Silvia Mu\[NTilde]oz-Descalzo, \
\[OpenCurlyDoubleQuote]The transition from local to global patterns governs \
the differentiation of mouse blastocysts\[OpenCurlyDoubleQuote]\
\>", "Chapter",
 CellChangeTimes->{{3.694925063490426*^9, 3.6949251473104267`*^9}, {
  3.6949293572744265`*^9, 3.6949293586354265`*^9}, {3.77772069045651*^9, 
  3.777720716754665*^9}},ExpressionUUID->"eba19448-594a-4c9c-b275-\
cb56b6b18549"],

Cell["\<\
The model has three parameters:
- proportion of NANOG positive cells 
- proportion of GATA6 positive cells 
- starting number of neighbours for assigning high NANOG levels \
\>", "Text",
 CellChangeTimes->{{3.7519582927008085`*^9, 3.7519583434970336`*^9}, {
   3.751958459058055*^9, 3.7519585471038017`*^9}, 3.751959288001119*^9, 
   3.7554291551148906`*^9, {3.781350166781184*^9, 
   3.7813501701469493`*^9}},ExpressionUUID->"17370071-3edb-4364-800e-\
8abc9518b124"],

Cell["\<\
Output of the model:
- Proportions of correctly assigned cells
- Population composition
- neighbours distribution\
\>", "Text",
 CellChangeTimes->{{3.7519585536349688`*^9, 3.7519585870251665`*^9}, {
  3.751959252220292*^9, 
  3.7519592741418962`*^9}},ExpressionUUID->"835f6202-92f9-494c-8d39-\
ff416b50f4f6"],

Cell[CellGroupData[{

Cell["Initialisation", "Section",
 CellChangeTimes->{{3.6949294869194264`*^9, 
  3.6949294892344265`*^9}},ExpressionUUID->"d818f9b4-7e83-47ea-b7e8-\
15ea49dc428b"],

Cell[BoxData[
 RowBox[{"<<", 
  RowBox[{"(", 
   RowBox[{"FileNameJoin", "[", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"NotebookDirectory", "[", "]"}], ",", 
      "\"\<FourPopulationModel.m\>\""}], "}"}], "]"}], ")"}]}]], "Input",
 InitializationCell->True,
 CellChangeTimes->{{3.7519611197636757`*^9, 3.751961126013621*^9}, {
   3.781347527201914*^9, 3.7813475346320148`*^9}, 3.7813503916267815`*^9},
 CellLabel->"In[2]:=",ExpressionUUID->"b287b2c3-ebdf-4a60-af0f-8f3b7c174f7c"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Data", "Section",
 CellChangeTimes->{{3.751961297089962*^9, 
  3.751961297511837*^9}},ExpressionUUID->"b8dcd8aa-cec5-4a6e-b00a-\
2fbcd88b31df"],

Cell[BoxData[
 RowBox[{
  RowBox[{"finalFNames", "=", 
   RowBox[{"FileNames", "[", 
    RowBox[{"\"\<*FinalData.mx\>\"", ",", 
     RowBox[{"FileNameJoin", "[", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"NotebookDirectory", "[", "]"}], ",", 
        "\"\<EmbryoFeaturesSaiz\>\""}], "}"}], "]"}]}], "]"}]}], 
  ";"}]], "Input",
 CellChangeTimes->{{3.66772847368152*^9, 3.6677284965187488`*^9}, {
   3.667728695339083*^9, 3.667728699863025*^9}, 3.667729303067416*^9, {
   3.667729834165241*^9, 3.6677298411696854`*^9}, {3.6677300813488255`*^9, 
   3.6677300818792286`*^9}, {3.668944131048835*^9, 3.668944139176382*^9}, {
   3.668945092845069*^9, 3.668945093859063*^9}, {3.669723188823038*^9, 
   3.6697232165262065`*^9}, {3.6870851278044643`*^9, 
   3.6870851417422886`*^9}, {3.6949528668534245`*^9, 3.694952882790018*^9}, {
   3.6949529167514143`*^9, 3.694952937595498*^9}, {3.6950975621700673`*^9, 
   3.6950975630420675`*^9}, {3.714643540924018*^9, 3.714643541924005*^9}, {
   3.7170404112005343`*^9, 3.7170404122161016`*^9}, {3.7400353907563143`*^9, 
   3.74003539189695*^9}, {3.7813475578620625`*^9, 3.781347563591997*^9}, 
   3.7813478444416194`*^9},
 CellLabel->"In[3]:=",ExpressionUUID->"d2021ecb-6de0-4b69-a22e-979302238931"],

Cell[BoxData[
 RowBox[{
  RowBox[{"nucleiFeatures", "=", 
   RowBox[{
    RowBox[{
     RowBox[{"(", 
      RowBox[{"\"\<NucleiFeatures\>\"", "/.", 
       RowBox[{"Import", "[", "#", "]"}]}], ")"}], "&"}], "/@", 
    "finalFNames"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.662789745744736*^9, 3.662789750565136*^9}, {
   3.663306026319808*^9, 3.663306035175808*^9}, {3.6677308837795715`*^9, 
   3.6677309010644827`*^9}, {3.6677311478268642`*^9, 3.667731150697283*^9}, {
   3.6689454081034484`*^9, 3.668945411535426*^9}, {3.669955063732564*^9, 
   3.669955065198964*^9}, 3.6949531318909254`*^9},
 CellLabel->"In[4]:=",ExpressionUUID->"85a669fa-1187-4b43-9652-07c73e2e5e2b"],

Cell[BoxData[
 RowBox[{
  RowBox[{"staging", "=", 
   RowBox[{
    RowBox[{
     RowBox[{"(", 
      RowBox[{"\"\<Staging\>\"", "/.", 
       RowBox[{"Import", "[", "#", "]"}]}], ")"}], "&"}], "/@", 
    "finalFNames"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.6950103322614956`*^9, 3.6950103483514957`*^9}, {
  3.6950145882002954`*^9, 3.6950145942998953`*^9}},
 CellLabel->"In[5]:=",ExpressionUUID->"253bed6b-f780-49d9-9d03-a0d5239fa3ab"],

Cell[BoxData[
 RowBox[{
  RowBox[{"dcgGraphs", "=", 
   RowBox[{"Transpose", "[", 
    RowBox[{"{", 
     RowBox[{"staging", ",", 
      RowBox[{
       RowBox[{
        RowBox[{"(", 
         RowBox[{"\"\<DelaunayCellGraph\>\"", "/.", 
          RowBox[{"(", 
           RowBox[{"\"\<GlobalFeatures\>\"", "/.", 
            RowBox[{"Import", "[", "#", "]"}]}], ")"}]}], ")"}], "&"}], "/@", 
       "finalFNames"}]}], "}"}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{
  3.6950096472746954`*^9, {3.6950096777882957`*^9, 3.6950097133406954`*^9}, {
   3.6950103534804955`*^9, 3.6950103732738953`*^9}, 3.695014613784295*^9, 
   3.7243288210363317`*^9, {3.7243298038521705`*^9, 3.724329807336539*^9}},
 CellLabel->"In[6]:=",ExpressionUUID->"2c309eea-90e6-417c-b0d5-8974ac439a1f"],

Cell[BoxData[
 RowBox[{
  RowBox[{"posStagesEmbryos", "=", 
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"Position", "[", 
       RowBox[{"staging", ",", "i"}], "]"}], "[", 
      RowBox[{"[", 
       RowBox[{"All", ",", "1"}], "]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       RowBox[{"{", 
        RowBox[{
        "\"\<3.5ncb\>\"", ",", "\"\<4.0ncb\>\"", ",", "\"\<4.5ncb\>\""}], 
        "}"}]}], "}"}]}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{3.751965179227086*^9, 3.7813475689122715`*^9},
 CellLabel->"In[7]:=",ExpressionUUID->"5fa40453-86e6-410c-86e8-34f1c81c19cb"]
}, Open  ]],

Cell[CellGroupData[{

Cell["\<\
Simulation for wild type embryos (Fig 6 B; Fig 7 D analogous)\
\>", "Section",
 CellChangeTimes->{{3.751961304011779*^9, 3.751961307621133*^9}, {
  3.7813497086590137`*^9, 3.7813497099393005`*^9}, {3.781350088887339*^9, 
  3.781350099147501*^9}},ExpressionUUID->"a4df2281-eaee-47f5-ae61-\
755009f5704a"],

Cell[BoxData[
 RowBox[{
  RowBox[{"nucleiFeaturesEarly", "=", 
   RowBox[{"nucleiFeatures", "[", 
    RowBox[{"[", 
     RowBox[{"posStagesEmbryos", "[", 
      RowBox[{"[", "1", "]"}], "]"}], "]"}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.751965241382069*^9, 3.751965256538123*^9}, 
   3.751965661282056*^9, 3.781347580442387*^9},
 CellLabel->"In[8]:=",ExpressionUUID->"ab2b2c31-8a4a-4433-9148-9b2da849571b"],

Cell[BoxData[
 RowBox[{
  RowBox[{"dcgGraphsEarly", "=", 
   RowBox[{"dcgGraphs", "[", 
    RowBox[{"[", 
     RowBox[{"posStagesEmbryos", "[", 
      RowBox[{"[", "1", "]"}], "]"}], "]"}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.7519653771295586`*^9, 3.751965389676195*^9}, 
   3.7813475835622177`*^9},
 CellLabel->"In[9]:=",ExpressionUUID->"fb8328c7-1b4b-41ee-8e69-a4a810c3ce99"],

Cell["pGata6 = 85 %, pNANOG = 82 %, startNumNeigh = 9", "Text",
 CellChangeTimes->{{3.781349934407687*^9, 
  3.781349954041404*^9}},ExpressionUUID->"90cbdfcb-9f8c-4b74-9500-\
d12ad70622e3"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"scanModel", "[", 
  RowBox[{
  "nucleiFeaturesEarly", ",", "dcgGraphsEarly", ",", "0.85", ",", "0.82", ",",
    "9"}], "]"}]], "Input",
 CellChangeTimes->{{3.7523979080926385`*^9, 3.752397916279831*^9}, {
   3.781347695732253*^9, 3.7813477318918147`*^9}, 3.781347998005604*^9, {
   3.781349897440559*^9, 3.7813499030781817`*^9}},
 CellLabel->"In[10]:=",ExpressionUUID->"35eacc85-f0c6-4d42-907c-603a3371cab6"],

Cell[BoxData["\<\"C:\\\\Users\\\\saf75nu\\\\Documents\\\\Projekte\\\\ms mouse \
embryo\\\\RoyalSocietyOpen\\\\Supplementary \
material\\\\ModelSimulation\\\\scan2019-10-29g0.85n0.82s9.mx\"\>"], "Output",
 CellChangeTimes->{3.7813479928502197`*^9, 3.7813481929908037`*^9, 
  3.781348260680788*^9, 3.781348363710765*^9, 3.7813499773874464`*^9, 
  3.781350273465806*^9, 3.781350537215623*^9},
 CellLabel->"Out[10]=",ExpressionUUID->"f28ea04c-a323-4bb0-9e7e-5fcea4c6703a"]
}, Open  ]],

Cell[BoxData[
 RowBox[{
  RowBox[{"fName", "=", 
   RowBox[{"FileNameJoin", "[", 
    RowBox[{"{", 
     RowBox[{
      RowBox[{"NotebookDirectory", "[", "]"}], ",", "\"\<ModelSimulation\>\"",
       ",", "\"\<scan2019-10-29g0.85n0.82s9.mx\>\""}], "}"}], "]"}]}], 
  ";"}]], "Input",
 CellChangeTimes->{{3.78134974137899*^9, 3.781349781068905*^9}, {
  3.781349913722129*^9, 3.781349918857952*^9}, {3.781349988132044*^9, 
  3.781349989477731*^9}},
 CellLabel->"In[11]:=",ExpressionUUID->"40a81f0c-1ec5-45f7-8c17-1669f999da38"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"popCount", "=", 
  RowBox[{"(", 
   RowBox[{
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"\"\<propGata6\>\"", "/.", "#"}], ",", 
       RowBox[{"\"\<propNanog\>\"", "/.", "#"}], ",", 
       RowBox[{"Total", "[", 
        RowBox[{"\"\<populationCount\>\"", "/.", "#"}], "]"}]}], "}"}], "&"}],
     "@", 
    RowBox[{"Import", "[", "fName", "]"}]}], ")"}]}]], "Input",
 CellChangeTimes->{{3.7555942410463853`*^9, 3.75559429928053*^9}, {
   3.7555951535898523`*^9, 3.7555951703085613`*^9}, {3.7555952882920876`*^9, 
   3.7555953167916393`*^9}, {3.7582642699377413`*^9, 3.7582642774220247`*^9}, 
   3.7582643154375505`*^9, 3.78134973881866*^9, 3.781349791838803*^9},
 CellLabel->"In[12]:=",ExpressionUUID->"af52d70e-6384-4ba3-9987-e57638384ceb"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0.85`", ",", "0.82`", ",", 
   RowBox[{"{", 
    RowBox[{
    "30.46`", ",", "808.39`", ",", "140.60999999999999`", ",", 
     "177.54000000000002`"}], "}"}]}], "}"}]], "Output",
 CellChangeTimes->{{3.7555942532025766`*^9, 3.7555942615150003`*^9}, 
   3.7555942999523797`*^9, 3.755595172652275*^9, {3.755595308453148*^9, 
   3.7555953183696404`*^9}, 3.7582642816407733`*^9, 3.758264316468751*^9, {
   3.781349467334443*^9, 3.7813494793428483`*^9}, {3.7813497831615915`*^9, 
   3.781349792908968*^9}, {3.7813499777275085`*^9, 3.781349991327793*^9}, 
   3.781350273646487*^9, 3.7813505373655376`*^9},
 CellLabel->"Out[12]=",ExpressionUUID->"69857a86-5479-4353-a739-a436494abe4e"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Labeled", "[", 
  RowBox[{
   RowBox[{"BarChart", "[", 
    RowBox[{
     RowBox[{"popCount", "[", 
      RowBox[{"[", 
       RowBox[{"-", "1"}], "]"}], "]"}], ",", 
     RowBox[{"BarSpacing", "\[Rule]", "1"}], ",", 
     RowBox[{"ChartLayout", "->", "\"\<Percentile\>\""}], ",", 
     RowBox[{"ImageSize", "\[Rule]", "400"}], ",", 
     RowBox[{"ChartStyle", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"Lighter", "[", 
         RowBox[{"Orange", ",", "0.7"}], "]"}], ",", "Gray", ",", 
        RowBox[{"Darker", "[", "Purple", "]"}], ",", 
        RowBox[{"Darker", "[", 
         RowBox[{"Green", ",", "0.7"}], "]"}]}], "}"}]}], ",", 
     RowBox[{"ChartLabels", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
        RowBox[{"{", "\"\<NANOG mut\>\"", "}"}], ",", "None"}], "}"}]}], ",", 
     RowBox[{
     "PlotLabel", "\[Rule]", "\"\<prediction population distribution\>\""}]}],
     "]"}], ",", " ", 
   RowBox[{"SwatchLegend", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"Lighter", "[", 
        RowBox[{"Orange", ",", "0.7"}], "]"}], ",", "Gray", ",", 
       RowBox[{"Darker", "[", "Purple", "]"}], ",", 
       RowBox[{"Darker", "[", 
        RowBox[{"Green", ",", "0.7"}], "]"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
      "\"\<DN\>\"", ",", "\"\<DP\>\"", ",", "\"\<Epi progenitor\>\"", ",", 
       "\"\<PrE progenitor\>\""}], "}"}], ",", 
     RowBox[{"LegendLayout", "\[Rule]", "\"\<Row\>\""}]}], "]"}]}], 
  "]"}]], "Input",
 CellChangeTimes->{{3.7555943042961235`*^9, 3.7555943074054804`*^9}, {
   3.7555951779022613`*^9, 3.755595253089023*^9}, {3.7555953215727234`*^9, 
   3.7555953545720177`*^9}, {3.7813493134222193`*^9, 3.78134933455335*^9}, {
   3.7813493894714017`*^9, 3.7813493895813236`*^9}, 3.781349488470929*^9, {
   3.7813497965178223`*^9, 3.7813498074485407`*^9}},
 CellLabel->"In[13]:=",ExpressionUUID->"aed676ef-017c-4024-92d9-1d651ca70cdb"],

Cell[BoxData[
 TemplateBox[{GraphicsBox[{{
      Opacity[0], 
      PointBox[{{-1.52, 0.}, {3.5, 0.}}]}, {{}, {
       Directive[
        EdgeForm[
         Directive[
          Thickness[Small], 
          Opacity[0.6719999999999999]]], 
        RGBColor[0.982864, 0.7431472, 0.3262672]], {{
         Directive[
          EdgeForm[
           Directive[
            Thickness[Small], 
            Opacity[0.6719999999999999]]], 
          RGBColor[1., 0.85, 0.7]], 
         TagBox[
          TooltipBox[
           TagBox[
            DynamicBox[{
              FEPrivate`If[
               CurrentValue["MouseOver"], 
               EdgeForm[{
                 GrayLevel[0.5], 
                 AbsoluteThickness[1.5], 
                 Opacity[0.66]}], {}, {}], 
              
              RectangleBox[{0.5, 0.}, {1.5, 2.6326707000864302`}, 
               "RoundingRadius" -> 0]}], StatusArea[#, 30.46]& , TagBoxNote -> 
            "30.46"], 
           StyleBox["30.46`", {}, StripOnInput -> False]], Annotation[#, 
           Style[30.46, {}], "Tooltip"]& ]}, {
         Directive[
          EdgeForm[
           Directive[
            Thickness[Small], 
            Opacity[0.6719999999999999]]], 
          GrayLevel[0.5]], 
         TagBox[
          TooltipBox[
           TagBox[
            DynamicBox[{
              FEPrivate`If[
               CurrentValue["MouseOver"], 
               EdgeForm[{
                 GrayLevel[0.5], 
                 AbsoluteThickness[1.5], 
                 Opacity[0.66]}], {}, {}], 
              
              RectangleBox[{0.5, 2.6326707000864302`}, {1.5, 
               72.50216076058773}, "RoundingRadius" -> 0]}], 
            StatusArea[#, 808.39]& , TagBoxNote -> "808.39"], 
           StyleBox["808.39`", {}, StripOnInput -> False]], Annotation[#, 
           Style[808.39, {}], "Tooltip"]& ]}, {
         Directive[
          EdgeForm[
           Directive[
            Thickness[Small], 
            Opacity[0.6719999999999999]]], 
          RGBColor[0.33333333333333337`, 0, 0.33333333333333337`]], 
         TagBox[
          TooltipBox[
           TagBox[
            DynamicBox[{
              FEPrivate`If[
               CurrentValue["MouseOver"], 
               EdgeForm[{
                 GrayLevel[0.5], 
                 AbsoluteThickness[1.5], 
                 Opacity[0.66]}], {}, {}], 
              
              RectangleBox[{0.5, 72.50216076058773}, {1.5, 84.6551426101988}, 
               "RoundingRadius" -> 0]}], StatusArea[#, 140.60999999999999`]& ,
             TagBoxNote -> "140.60999999999999"], 
           StyleBox["140.60999999999999`", {}, StripOnInput -> False]], 
          Annotation[#, 
           Style[140.60999999999999`, {}], "Tooltip"]& ]}, {
         Directive[
          EdgeForm[
           Directive[
            Thickness[Small], 
            Opacity[0.6719999999999999]]], 
          RGBColor[0., 0.30000000000000004`, 0.]], 
         TagBox[
          TooltipBox[
           TagBox[
            DynamicBox[{
              FEPrivate`If[
               CurrentValue["MouseOver"], 
               EdgeForm[{
                 GrayLevel[0.5], 
                 AbsoluteThickness[1.5], 
                 Opacity[0.66]}], {}, {}], 
              
              RectangleBox[{0.5, 84.6551426101988}, {1.5, 100.}, 
               "RoundingRadius" -> 0]}], StatusArea[#, 177.54000000000002`]& ,
             TagBoxNote -> "177.54000000000002"], 
           StyleBox["177.54000000000002`", {}, StripOnInput -> False]], 
          Annotation[#, 
           Style[177.54000000000002`, {}], 
           "Tooltip"]& ]}}}, {}, {}}, {}, {}, {}, {}, {
      StyleBox[{Antialiasing -> False, {
         Directive[
          Thickness[Tiny]], {
          LineBox[{{-1.52, 0.}, {3.5604, 0.}}]}, 
         StyleBox[{}, "GraphicsLabel", StripOnInput -> False]}, 
        StyleBox[{{
           Directive[
            Thickness[Tiny]], 
           LineBox[{{0.5, 0.}, 
             Offset[{-1.102182119232618*^-15, -6.}, {0.5, 0.}]}], 
           LineBox[{{1.5, 0.}, 
             Offset[{-1.102182119232618*^-15, -6.}, {1.5, 0.}]}], {{}, {}}}, 
          StyleBox[{}, "GraphicsLabel", StripOnInput -> False]}, 
         "GraphicsTicks", StripOnInput -> False]}, "GraphicsAxes", 
       StripOnInput -> False]}}, {
    DisplayFunction -> Identity, AspectRatio -> 
     NCache[GoldenRatio^(-1), 0.6180339887498948], Axes -> {False, True}, 
     AxesLabel -> {None, None}, AxesOrigin -> {-1.52, 0.}, 
     CoordinatesToolOptions -> {"DisplayFunction" -> ({
         Identity[
          Part[#, 1]], 
         Identity[
          Part[#, 2]]}& ), "CopiedValueFunction" -> ({
         Identity[
          Part[#, 1]], 
         Identity[
          Part[#, 2]]}& )}, FrameLabel -> {{None, None}, {None, None}}, 
     FrameTicks -> {{Automatic, Automatic}, {Automatic, Automatic}}, 
     GridLines -> {None, None}, GridLinesStyle -> Directive[
       GrayLevel[0.5, 0.4]], ImageSize -> 400, PlotLabel -> 
     FormBox["\"prediction population distribution\"", TraditionalForm], 
     PlotRange -> {{All, All}, {All, All}}, PlotRangePadding -> {{
        Scaled[0.02], 
        Scaled[0.02]}, {
        Scaled[0.02], 
        Scaled[0.05]}}, Ticks -> {None, Automatic}}],
   TemplateBox[{
    "\"DN\"", "\"DP\"", "\"Epi progenitor\"", "\"PrE progenitor\""}, 
    "SwatchLegend", DisplayFunction -> (StyleBox[
      StyleBox[
       PaneBox[
        TagBox[
         GridBox[{{
            TagBox[
             GridBox[{{
                GraphicsBox[{
                  Directive[
                   EdgeForm[
                    Directive[
                    Opacity[0.3], 
                    GrayLevel[0]]], 
                   PointSize[0.5], 
                   AbsoluteThickness[1.6], 
                   RGBColor[1., 0.85, 0.7]], 
                  RectangleBox[{0, 0}, {10, 10}, "RoundingRadius" -> 0]}, 
                 AspectRatio -> Full, ImageSize -> {10, 10}, PlotRangePadding -> 
                 None, ImagePadding -> Automatic, 
                 BaselinePosition -> (Scaled[0.1] -> Baseline)], #, 
                GraphicsBox[{
                  Directive[
                   EdgeForm[
                    Directive[
                    Opacity[0.3], 
                    GrayLevel[0]]], 
                   PointSize[0.5], 
                   AbsoluteThickness[1.6], 
                   GrayLevel[0.5]], 
                  RectangleBox[{0, 0}, {10, 10}, "RoundingRadius" -> 0]}, 
                 AspectRatio -> Full, ImageSize -> {10, 10}, PlotRangePadding -> 
                 None, ImagePadding -> Automatic, 
                 BaselinePosition -> (Scaled[0.1] -> Baseline)], #2, 
                GraphicsBox[{
                  Directive[
                   EdgeForm[
                    Directive[
                    Opacity[0.3], 
                    GrayLevel[0]]], 
                   PointSize[0.5], 
                   AbsoluteThickness[1.6], 
                   RGBColor[0.33333333333333337`, 0, 0.33333333333333337`]], 
                  RectangleBox[{0, 0}, {10, 10}, "RoundingRadius" -> 0]}, 
                 AspectRatio -> Full, ImageSize -> {10, 10}, PlotRangePadding -> 
                 None, ImagePadding -> Automatic, 
                 BaselinePosition -> (Scaled[0.1] -> Baseline)], #3, 
                GraphicsBox[{
                  Directive[
                   EdgeForm[
                    Directive[
                    Opacity[0.3], 
                    GrayLevel[0]]], 
                   PointSize[0.5], 
                   AbsoluteThickness[1.6], 
                   RGBColor[0., 0.30000000000000004`, 0.]], 
                  RectangleBox[{0, 0}, {10, 10}, "RoundingRadius" -> 0]}, 
                 AspectRatio -> Full, ImageSize -> {10, 10}, PlotRangePadding -> 
                 None, ImagePadding -> Automatic, 
                 BaselinePosition -> (Scaled[0.1] -> Baseline)], #4}}, 
              GridBoxAlignment -> {
               "Columns" -> {Center, Left}, "Rows" -> {{Baseline}}}, 
              AutoDelete -> False, 
              GridBoxDividers -> {
               "Columns" -> {{False}}, "Rows" -> {{False}}}, 
              GridBoxItemSize -> {"Columns" -> {{All}}, "Rows" -> {{All}}}, 
              GridBoxSpacings -> {"Columns" -> {{0.5, 0.5}}}], "Grid"]}}, 
          GridBoxAlignment -> {"Columns" -> {{Left}}, "Rows" -> {{Top}}}, 
          AutoDelete -> False, 
          GridBoxDividers -> {"Columns" -> {{None}}, "Rows" -> {{None}}}, 
          GridBoxItemSize -> {"Columns" -> {{All}}, "Rows" -> {{All}}}, 
          GridBoxSpacings -> {"Columns" -> {{0}}, "Rows" -> {{1}}}], "Grid"], 
        Alignment -> Left, AppearanceElements -> None, 
        ImageMargins -> {{5, 5}, {5, 5}}, ImageSizeAction -> "ResizeToFit"], 
       LineIndent -> 0, StripOnInput -> False], {FontFamily -> "Arial"}, 
      Background -> Automatic, StripOnInput -> False]& ), 
    InterpretationFunction :> (RowBox[{"SwatchLegend", "[", 
       RowBox[{
         RowBox[{"{", 
           RowBox[{
             InterpretationBox[
              ButtonBox[
               TooltipBox[
                GraphicsBox[{{
                   GrayLevel[0], 
                   RectangleBox[{0, 0}]}, {
                   GrayLevel[0], 
                   RectangleBox[{1, -1}]}, {
                   RGBColor[1., 0.85, 0.7], 
                   RectangleBox[{0, -1}, {2, 1}]}}, DefaultBaseStyle -> 
                 "ColorSwatchGraphics", AspectRatio -> 1, Frame -> True, 
                 FrameStyle -> 
                 RGBColor[
                  0.6666666666666667, 0.5666666666666667, 0.4666666666666667],
                  FrameTicks -> None, PlotRangePadding -> None, ImageSize -> 
                 Dynamic[{
                   Automatic, 
                    1.35 (CurrentValue["FontCapHeight"]/AbsoluteCurrentValue[
                    Magnification])}]], 
                StyleBox[
                 RowBox[{"RGBColor", "[", 
                   RowBox[{"1.`", ",", "0.85`", ",", "0.7`"}], "]"}], 
                 NumberMarks -> False]], Appearance -> None, BaseStyle -> {}, 
               BaselinePosition -> Baseline, DefaultBaseStyle -> {}, 
               ButtonFunction :> With[{Typeset`box$ = EvaluationBox[]}, 
                 If[
                  Not[
                   AbsoluteCurrentValue["Deployed"]], 
                  SelectionMove[Typeset`box$, All, Expression]; 
                  FrontEnd`Private`$ColorSelectorInitialAlpha = 1; 
                  FrontEnd`Private`$ColorSelectorInitialColor = 
                   RGBColor[1., 0.85, 0.7]; 
                  FrontEnd`Private`$ColorSelectorUseMakeBoxes = True; 
                  MathLink`CallFrontEnd[
                    FrontEnd`AttachCell[Typeset`box$, 
                    FrontEndResource["RGBColorValueSelector"], {
                    0, {Left, Bottom}}, {Left, Top}, 
                    "ClosingActions" -> {
                    "SelectionDeparture", "ParentChanged", 
                    "EvaluatorQuit"}]]]], BaseStyle -> Inherited, Evaluator -> 
               Automatic, Method -> "Preemptive"], 
              RGBColor[1., 0.85, 0.7], Editable -> False, Selectable -> 
              False], ",", 
             InterpretationBox[
              ButtonBox[
               TooltipBox[
                GraphicsBox[{{
                   GrayLevel[0], 
                   RectangleBox[{0, 0}]}, {
                   GrayLevel[0], 
                   RectangleBox[{1, -1}]}, {
                   GrayLevel[0.5], 
                   RectangleBox[{0, -1}, {2, 1}]}}, DefaultBaseStyle -> 
                 "ColorSwatchGraphics", AspectRatio -> 1, Frame -> True, 
                 FrameStyle -> GrayLevel[0.33333333333333337`], FrameTicks -> 
                 None, PlotRangePadding -> None, ImageSize -> 
                 Dynamic[{
                   Automatic, 
                    1.35 (CurrentValue["FontCapHeight"]/AbsoluteCurrentValue[
                    Magnification])}]], 
                StyleBox[
                 RowBox[{"GrayLevel", "[", "0.5`", "]"}], NumberMarks -> 
                 False]], Appearance -> None, BaseStyle -> {}, 
               BaselinePosition -> Baseline, DefaultBaseStyle -> {}, 
               ButtonFunction :> With[{Typeset`box$ = EvaluationBox[]}, 
                 If[
                  Not[
                   AbsoluteCurrentValue["Deployed"]], 
                  SelectionMove[Typeset`box$, All, Expression]; 
                  FrontEnd`Private`$ColorSelectorInitialAlpha = 1; 
                  FrontEnd`Private`$ColorSelectorInitialColor = 
                   GrayLevel[0.5]; 
                  FrontEnd`Private`$ColorSelectorUseMakeBoxes = True; 
                  MathLink`CallFrontEnd[
                    FrontEnd`AttachCell[Typeset`box$, 
                    FrontEndResource["GrayLevelColorValueSelector"], {
                    0, {Left, Bottom}}, {Left, Top}, 
                    "ClosingActions" -> {
                    "SelectionDeparture", "ParentChanged", 
                    "EvaluatorQuit"}]]]], BaseStyle -> Inherited, Evaluator -> 
               Automatic, Method -> "Preemptive"], 
              GrayLevel[0.5], Editable -> False, Selectable -> False], ",", 
             InterpretationBox[
              ButtonBox[
               TooltipBox[
                GraphicsBox[{{
                   GrayLevel[0], 
                   RectangleBox[{0, 0}]}, {
                   GrayLevel[0], 
                   RectangleBox[{1, -1}]}, {
                   RGBColor[0.33333333333333337`, 0, 0.33333333333333337`], 
                   RectangleBox[{0, -1}, {2, 1}]}}, DefaultBaseStyle -> 
                 "ColorSwatchGraphics", AspectRatio -> 1, Frame -> True, 
                 FrameStyle -> 
                 RGBColor[0.22222222222222227`, 0., 0.22222222222222227`], 
                 FrameTicks -> None, PlotRangePadding -> None, ImageSize -> 
                 Dynamic[{
                   Automatic, 
                    1.35 (CurrentValue["FontCapHeight"]/AbsoluteCurrentValue[
                    Magnification])}]], 
                StyleBox[
                 RowBox[{"RGBColor", "[", 
                   
                   RowBox[{
                    "0.33333333333333337`", ",", "0", ",", 
                    "0.33333333333333337`"}], "]"}], NumberMarks -> False]], 
               Appearance -> None, BaseStyle -> {}, BaselinePosition -> 
               Baseline, DefaultBaseStyle -> {}, ButtonFunction :> 
               With[{Typeset`box$ = EvaluationBox[]}, 
                 If[
                  Not[
                   AbsoluteCurrentValue["Deployed"]], 
                  SelectionMove[Typeset`box$, All, Expression]; 
                  FrontEnd`Private`$ColorSelectorInitialAlpha = 1; 
                  FrontEnd`Private`$ColorSelectorInitialColor = 
                   RGBColor[0.33333333333333337`, 0, 0.33333333333333337`]; 
                  FrontEnd`Private`$ColorSelectorUseMakeBoxes = True; 
                  MathLink`CallFrontEnd[
                    FrontEnd`AttachCell[Typeset`box$, 
                    FrontEndResource["RGBColorValueSelector"], {
                    0, {Left, Bottom}}, {Left, Top}, 
                    "ClosingActions" -> {
                    "SelectionDeparture", "ParentChanged", 
                    "EvaluatorQuit"}]]]], BaseStyle -> Inherited, Evaluator -> 
               Automatic, Method -> "Preemptive"], 
              RGBColor[0.33333333333333337`, 0, 0.33333333333333337`], 
              Editable -> False, Selectable -> False], ",", 
             InterpretationBox[
              ButtonBox[
               TooltipBox[
                GraphicsBox[{{
                   GrayLevel[0], 
                   RectangleBox[{0, 0}]}, {
                   GrayLevel[0], 
                   RectangleBox[{1, -1}]}, {
                   RGBColor[0., 0.30000000000000004`, 0.], 
                   RectangleBox[{0, -1}, {2, 1}]}}, DefaultBaseStyle -> 
                 "ColorSwatchGraphics", AspectRatio -> 1, Frame -> True, 
                 FrameStyle -> RGBColor[0., 0.20000000000000004`, 0.], 
                 FrameTicks -> None, PlotRangePadding -> None, ImageSize -> 
                 Dynamic[{
                   Automatic, 
                    1.35 (CurrentValue["FontCapHeight"]/AbsoluteCurrentValue[
                    Magnification])}]], 
                StyleBox[
                 RowBox[{"RGBColor", "[", 
                   RowBox[{"0.`", ",", "0.30000000000000004`", ",", "0.`"}], 
                   "]"}], NumberMarks -> False]], Appearance -> None, 
               BaseStyle -> {}, BaselinePosition -> Baseline, 
               DefaultBaseStyle -> {}, ButtonFunction :> 
               With[{Typeset`box$ = EvaluationBox[]}, 
                 If[
                  Not[
                   AbsoluteCurrentValue["Deployed"]], 
                  SelectionMove[Typeset`box$, All, Expression]; 
                  FrontEnd`Private`$ColorSelectorInitialAlpha = 1; 
                  FrontEnd`Private`$ColorSelectorInitialColor = 
                   RGBColor[0., 0.30000000000000004`, 0.]; 
                  FrontEnd`Private`$ColorSelectorUseMakeBoxes = True; 
                  MathLink`CallFrontEnd[
                    FrontEnd`AttachCell[Typeset`box$, 
                    FrontEndResource["RGBColorValueSelector"], {
                    0, {Left, Bottom}}, {Left, Top}, 
                    "ClosingActions" -> {
                    "SelectionDeparture", "ParentChanged", 
                    "EvaluatorQuit"}]]]], BaseStyle -> Inherited, Evaluator -> 
               Automatic, Method -> "Preemptive"], 
              RGBColor[0., 0.30000000000000004`, 0.], Editable -> False, 
              Selectable -> False]}], "}"}], ",", 
         RowBox[{"{", 
           RowBox[{#, ",", #2, ",", #3, ",", #4}], "}"}], ",", 
         RowBox[{"LegendLayout", "\[Rule]", "\"Row\""}]}], "]"}]& ), Editable -> 
    True]},
  "Labeled",
  DisplayFunction->(GridBox[{{
      TagBox[
       ItemBox[
        PaneBox[
         TagBox[#, "SkipImageSizeLevel"], Alignment -> {Center, Baseline}, 
         BaselinePosition -> Baseline], DefaultBaseStyle -> "Labeled"], 
       "SkipImageSizeLevel"]}, {
      ItemBox[#2, DefaultBaseStyle -> "LabeledLabel"]}}, 
    GridBoxAlignment -> {"Columns" -> {{Center}}, "Rows" -> {{Center}}}, 
    AutoDelete -> False, 
    GridBoxItemSize -> {"Columns" -> {{Automatic}}, "Rows" -> {{Automatic}}}, 
    BaselinePosition -> {1, 1}]& ),
  InterpretationFunction->(RowBox[{"Labeled", "[", 
     RowBox[{#, ",", #2}], "]"}]& )]], "Output",
 CellChangeTimes->{{3.7813497996184936`*^9, 3.781349808259404*^9}, {
   3.781349979007742*^9, 3.7813499925320225`*^9}, 3.781350273890766*^9, 
   3.781350537610159*^9},
 CellLabel->"Out[13]=",ExpressionUUID->"46f1a684-3815-43aa-9d01-411b51bc73ea"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
}, Open  ]]
},
WindowSize->{2048, 1069},
WindowMargins->{{-8, Automatic}, {Automatic, 0}},
FrontEndVersion->"11.3 for Microsoft Windows (64-bit) (March 6, 2018)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1510, 35, 321, 6, 96, "Title",ExpressionUUID->"002c1775-e511-4709-8b44-eb65318b917a"],
Cell[CellGroupData[{
Cell[1856, 45, 545, 9, 113, "Chapter",ExpressionUUID->"eba19448-594a-4c9c-b275-cb56b6b18549"],
Cell[2404, 56, 477, 10, 100, "Text",ExpressionUUID->"17370071-3edb-4364-800e-8abc9518b124"],
Cell[2884, 68, 318, 9, 100, "Text",ExpressionUUID->"835f6202-92f9-494c-8d39-ff416b50f4f6"],
Cell[CellGroupData[{
Cell[3227, 81, 163, 3, 67, "Section",ExpressionUUID->"d818f9b4-7e83-47ea-b7e8-15ea49dc428b"],
Cell[3393, 86, 486, 11, 44, "Input",ExpressionUUID->"b287b2c3-ebdf-4a60-af0f-8f3b7c174f7c",
 InitializationCell->True]
}, Open  ]],
Cell[CellGroupData[{
Cell[3916, 102, 149, 3, 67, "Section",ExpressionUUID->"b8dcd8aa-cec5-4a6e-b00a-2fbcd88b31df"],
Cell[4068, 107, 1244, 23, 28, "Input",ExpressionUUID->"d2021ecb-6de0-4b69-a22e-979302238931"],
Cell[5315, 132, 675, 14, 28, "Input",ExpressionUUID->"85a669fa-1187-4b43-9652-07c73e2e5e2b"],
Cell[5993, 148, 440, 11, 28, "Input",ExpressionUUID->"253bed6b-f780-49d9-9d03-a0d5239fa3ab"],
Cell[6436, 161, 777, 18, 28, "Input",ExpressionUUID->"2c309eea-90e6-417c-b0d5-8974ac439a1f"],
Cell[7216, 181, 622, 17, 28, "Input",ExpressionUUID->"5fa40453-86e6-410c-86e8-34f1c81c19cb"]
}, Open  ]],
Cell[CellGroupData[{
Cell[7875, 203, 313, 6, 67, "Section",ExpressionUUID->"a4df2281-eaee-47f5-ae61-755009f5704a"],
Cell[8191, 211, 417, 9, 28, "Input",ExpressionUUID->"ab2b2c31-8a4a-4433-9148-9b2da849571b"],
Cell[8611, 222, 389, 9, 28, "Input",ExpressionUUID->"fb8328c7-1b4b-41ee-8e69-a4a810c3ce99"],
Cell[9003, 233, 189, 3, 34, "Text",ExpressionUUID->"90cbdfcb-9f8c-4b74-9500-d12ad70622e3"],
Cell[CellGroupData[{
Cell[9217, 240, 432, 8, 28, "Input",ExpressionUUID->"35eacc85-f0c6-4d42-907c-603a3371cab6"],
Cell[9652, 250, 468, 6, 32, "Output",ExpressionUUID->"f28ea04c-a323-4bb0-9e7e-5fcea4c6703a"]
}, Open  ]],
Cell[10135, 259, 525, 12, 28, "Input",ExpressionUUID->"40a81f0c-1ec5-45f7-8c17-1669f999da38"],
Cell[CellGroupData[{
Cell[10685, 275, 784, 17, 28, "Input",ExpressionUUID->"af52d70e-6384-4ba3-9987-e57638384ceb"],
Cell[11472, 294, 717, 13, 32, "Output",ExpressionUUID->"69857a86-5479-4353-a739-a436494abe4e"]
}, Open  ]],
Cell[CellGroupData[{
Cell[12226, 312, 1954, 46, 48, "Input",ExpressionUUID->"aed676ef-017c-4024-92d9-1d651ca70cdb"],
Cell[14183, 360, 18847, 409, 308, "Output",ExpressionUUID->"46f1a684-3815-43aa-9d01-411b51bc73ea"]
}, Open  ]]
}, Open  ]]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature Nu0NB5mtNoA8fAg3LuEp86k0 *)
