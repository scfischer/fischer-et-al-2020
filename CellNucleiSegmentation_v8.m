(* ::Package:: *)

(*Supplementary code to Schmitz et al. 2017 "Multiscale image analysis reveals structural heterogeneity of the cell microenvironment in homotypic spheroids", Scientific Reports 7, 43693; please cite this paper, when using the code*)



BeginPackage["cns`"];


pipelineAdjustSegmentationGUI::usage="
pipelineAdjustParametersGUI
";


pipelineAdjustPostProcessingGUI::usage="
pipelineAdjustPostGUI
";


cnsFileChooser::usage="";


cnsFolderChooser::usage="";


cnsImageCalibration::usage="";


segmentationPipeline::usage="
segmentationPipeline[assoc_Association,opts:OptionsPattern[]]

performs cell nuclei segmentation for a given association of the form \[LeftAssociation]\"Nuclei\" \[Rule] \!\(\*
StyleBox[\"input_directory\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\\\\\\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"tif\",\nFontSlant->\"Italic\"]\)\[RightAssociation]. 

Options:
options are inherited from the respective functions of each step.
";


segmentationPipelineBatch::usage="
segmentationPipelineBatch[inputFolder_String,pattern_String,opts:OptionsPattern[]]

performs cell nuclei segmentation for a all files in \!\(\*
StyleBox[\"directory\",\nFontSlant->\"Italic\"]\) that match \!\(\*
StyleBox[\"pattern\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)An association list of all file paths {1,...,N} are created in the form {\[LeftAssociation]\"Nuclei\" \[Rule] \!\(\*
StyleBox[\"path1\",\nFontSlant->\"Italic\"]\)\[RightAssociation], ... , \[LeftAssociation]\"Nuclei\" \[Rule] \!\(\*
StyleBox[\"pathN\",\nFontSlant->\"Italic\"]\)\[RightAssociation]}. The datasets are then processed sequentially or in parallel (if multiple kernels are used). 

Options:
all options of the function segmentationPipeline are inherited.
\"Kernels\" \[Rule] number of kernels to use for segmentation of datasets in parallel. Important note: the number of kernels will affect the amount of memory used. If too many kernels are used, the computation might exceed the available memory! (default: 3).
";


postProccessingPipelineBatch::usage="";


postProcessingPipeline::usage="
postProcessingPipeline[folder_String, pattern_String, opts:OptionsPattern[]]
";


postProcessingPipelineFile::Usage="";


pipelineGatherFiles::usage="
pipelineGatherFiles[directory_String,\*
StyleBox[\(\!\(\*
StyleBox[\"pattern\",\nFontSlant->\"Italic\"]\)_String\)]]

Creates an association list of all file paths {1,...,N} in \!\(\*
StyleBox[\"directory\",\nFontSlant->\"Italic\"]\) that match \!\(\*
StyleBox[\"pattern\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)The file paths are returned in the form {\[LeftAssociation]\"Nuclei\" \[Rule] \!\(\*
StyleBox[\"path1\",\nFontSlant->\"Italic\"]\)\[RightAssociation], ... , \[LeftAssociation]\"Nuclei\" \[Rule] \!\(\*
StyleBox[\"pathN\",\nFontSlant->\"Italic\"]\)\[RightAssociation]}\!\(\*
StyleBox[\"\\\\n\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\n\",\nFontSlant->\"Italic\"]\)";


resizeImage3D::usage="
resizeImage3D[image_Image3D,factor_?NumberQ]

rescales a given Image3D \!\(\*
StyleBox[\"image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)by \!\(\*
StyleBox[\"factor\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)and returns a new Image3D object.
";


resampleImage3D::usage="
resampleImage3D[image_Image3D,xResampleFactor_?NumberQ,yResampleFactor_?NumberQ,zResampleFactor_?NumberQ]

resamples an image using the function \!\(\*
StyleBox[\"ImageResize\",\nFontFamily->\"Courier New\"]\) by the factors \!\(\*
StyleBox[\"xResampleFactor\",\nFontSlant->\"Italic\"]\), \!\(\*
StyleBox[\"yResampleFactor\",\nFontSlant->\"Italic\"]\) and \!\(\*
StyleBox[\"zResampleFactor\",\nFontSlant->\"Italic\"]\) given for dimensions x, y and z. The function is intended to give equal voxel spacing in each dimension. The function returns a new Image3D object.
";


threeWayLocalAdaptiveBinarize::usage="
threeWayLocalAdaptiveBinarize[image_Image3D,r_?NumberQ,\[Alpha]_?NumberQ,\[Beta]_?NumberQ,\[Gamma]_?NumberQ]

gives a segmentation of \!\(\*
StyleBox[\"image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)by applying the function LocalAdaptiveBinarize per image plane along each dimension x, y and z. The resulting binary images obtained for each dimension are multiplied to give the result. The parameters \[Alpha], \[Beta] and \[Gamma] are used to control the threshold computation in LocalAdaptiveBinarize. Each pixel is replaced by 1 if its value is above \!\(\*FormBox[\(\[Alpha]\\\ \[Mu] + \[Beta]\\\ \[Sigma] + \[Gamma]\),
TraditionalForm]\) in a range-r neighborhood, where \!\(\*FormBox[\(\[Mu]\),
TraditionalForm]\) and \!\(\*FormBox[\(\[Sigma]\),
TraditionalForm]\) are the local mean and standard deviation and by 0 if its value is less than this local threshold. The function returns a new Image3D object of type \"Bit\".
";


multiScaleBlobDetector::usage="
multiScaleBlobDetector[image_,{rMin_?NumberQ,rMax_?NumberQ},opts:OptionsPattern[]]

provides a custom multi-scale Laplacian of Gaussian (LoG) blob detection algorithm for seed detection. The following description is based on two dimensional images. However, the algorithm is similar for three-dimensional images. The magnitude of the LoG response at (x,y) is LoG(x,y;\[Sigma]) and maximal at the center of a blob given that the standard deviation (scale) \[Sigma] of the LoG kernel matches the size of the blob. The \!\(\*
StyleBox[\"image\",\nFontSlant->\"Italic\"]\) is inverted and convolved by a LoG kernel at multiple scales \[Sigma]_i\[Element]{\[Sigma]_min,\[Ellipsis],\[Sigma]_max}. Given that the relationship between radius r of a blob-like object and the scale \[Sigma] of the LoG is r = \!\(\*SqrtBox[\(2\)]\)\[Sigma]. The values for \[Sigma]_min \[Sigma]_max are determined from the minimal radius \!\(\*
StyleBox[\"rMin\",\nFontSlant->\"Italic\"]\) and maximal radius \!\(\*
StyleBox[\"rMax\",\nFontSlant->\"Italic\"]\) of objects to be detected by the LoG. To achieve scale-invariance, the resulting LoG response LoG(x,y;\[Sigma]) is normalized by multiplication with \[Sigma]^n, where n is the dimension of \!\(\*
StyleBox[\"image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"(\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"i\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"e\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\) 2 in the case of two-dimensional images\!\(\*
StyleBox[\")\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)For computational efficiency, the maximum response LoG_max (x,y;\[Sigma]_min ,\[Ellipsis], \[Sigma]_max) is iteratively computed over scales and the scale that yielded the maximum response at each pixel is stored in a separate image. The result of the multi-scale Laplacian of Gaussian (LoG) blob detection algorithm are two images: one stores the maximum response of the LoG for each pixel (x,y), the second image stores the scale at which the maximum response at pixel (x,y) was obtained. The maximum response image r can be subjected to a maximum transform to detect h-extended maxima that correspond to the centers of blobs.
";


addBackgroundSeed::usage="
addBackgroundSeed[seedImage_Image3D]

given an image of seed points, the function will add a seed for the background region at the outer border of the image and return the result as a new Image3D object of type \"Bit\".
";


Begin["`Private`"]; (* Begin Private Context *) 


cnsTooltipOpts={TooltipDelay->0.5,TooltipStyle->{CellFrameColor->Black,CellFrame->1}};


(*cnsPackagePath="R:\\Alexander\\NucleiSegmentationPipeline\\CellNucleiSegmentation_v5.m";*)


cnsPackagePath=$InputFileName;


pipelineImport::usage="
pipelineImport[assoc_Association,opts:OptionsPattern[]]

imports and pre-processes the raw image given in the association \!\(\*
StyleBox[\"assoc\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\) The association has to be in the form <|\"Nuclei\" \[Rule] \"\!\(\*
StyleBox[\"input_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"tif\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\\\\"\",\nFontSlant->\"Italic\"]\)|>. The function applies the specified resampling along z (\"ImageZScalingFactor\") and resizes the image (\"ImageScalingFactor\"). The pre-processed image is exported to an .mx file that contains the image to  \"\!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\\\\"\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)The association \!\(\*
StyleBox[\"assoc\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)is changed to <|\"Nuclei\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)|> and returned.

Options:

\"ImageZScalingFactor\" \[Rule] resampling factor for z dimension (default: 4),
\"ImageScalingFactor\" \[Rule] resize factor (default: 0.5),
\"DumpDirectory\" \[Rule] directory to save intermediate compuation results (default: \"D:\\SegmentationPipeline\")
";


pipelineDetectSeeds::usage="
pipelineDetectSeeds[assoc_Association,opts:OptionsPattern[]]

imports the pre-processed image \"Nuclei\" from \"\!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\\\\"\",\nFontSlant->\"Italic\"]\) and applies the Laplacian of Gaussian (LoG) blob detection multiScaleBlobDetector[\!\(\*
StyleBox[\"image\",\nFontSlant->\"Italic\"]\), {\!\(\*
StyleBox[\"rMin\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\",\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"rMax\",\nFontSlant->\"Italic\"]\)}] to \"Nuclei\" with \!\(\*
StyleBox[\"xMin\",\nFontSlant->\"Italic\"]\) set to \"NucleiSeedDetectionMinRadius\" and \!\(\*
StyleBox[\"xMax\",\nFontSlant->\"Italic\"]\) set to \"NucleiSeedDetectionMaxRadius\".
The detected sees are exported as an image to an .mx file that contains the image to  \"\!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiSeeds\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\\\\"\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\) The association \!\(\*
StyleBox[\"assoc\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)is changed accordingly to <|\"Nuclei\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\",\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)\"NucleiSeeds\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiSeeds\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)|> and returned.

Options:

\"NucleiSeedDetectionMinRadius\" \[Rule] minimum radius of blobs to be detected by the multi-scale LoG algorithm (default: 4),
\"NucleiSeedDetectionMaxRadius\" \[Rule] maximum radius of blobs to be detected by the multi-scale LoG algorithm (default: 12)
";


segmentNuclei::usage="
segmentNuclei[nucleiImage_Image3D,nucleiSeedsImage_Image3D,opts:OptionsPattern[]]

performs cell nuclei segmentation. The following algorithm is applied:
1. \!\(\*
StyleBox[\"nucleiImage\",\nFontSlant->\"Italic\"]\) is convolved with a Gaussian kernel of range specifed by \"NucleiFilterRange\". The filtered image is segmented using Binarize, negated and the average background intensity is measured (\!\(\*
StyleBox[\"bgrMeanGlobal\",\nFontSlant->\"Italic\"]\)).
2. \!\(\*
StyleBox[\"nucleiImage\",\nFontSlant->\"Italic\"]\) is segmented using the function threeWayLocalAdaptiveBinarize with the parameters r, \[Alpha], \[Beta], \[Gamma] specified by \"NucleiThresholdRange\", \"NucleiMeanFactor\", \"NucleiStandardDeviationFactor\" and \"NucleiBackgroundFactor\" * \!\(\*
StyleBox[\"bgrMeanGlobal\",\nFontSlant->\"Italic\"]\), respectively. Holes smaller than \"NucleiMinCount\" are removed giving the initial segmentation (\!\(\*
StyleBox[\"initialBinaryImage\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\")\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)
3. The negated \!\(\*
StyleBox[\"nucleiImage\",\nFontSlant->\"Italic\"]\) is segmented using the WatershedComponents (method: \"Immersion\"). Markers are used to control the watershed segmentation. Therefore, \"NucleiSeeds\" is multiplied with \!\(\*
StyleBox[\"initialBinaryImage\",\nFontSlant->\"Italic\"]\),\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)a dilation with a spherical structuring element of range \"NucleiSeedDilation\" is applied and a background seed is added by addBackgroundSeed[\!\(\*
StyleBox[\"nucleiSeedsImage\",\nFontSlant->\"Italic\"]\)]\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)The obtained segmentation is multiplied with \!\(\*
StyleBox[\"initialBinaryImage\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\n\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"4.\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)Compments having a total element count less than \"NucleiMinCount\" or greater than \"NucleiMaxCount\" are removed.

The final segmentation of cell nuclei is returned as a new Image3D object of type \"Bit\".

\"NucleiFilterRange\" \[Rule] 3,
\"NucleiThresholdRange\" \[Rule] 12,
\"NucleiMeanFactor\" \[Rule] 1,
\"NucleiStandardDeviationFactor\" \[Rule] 0,
\"NucleiSeedDilation\" \[Rule] 2,
\"NucleiBackgroundFactor\" \[Rule] 0.25,
\"NucleiMinCount\" \[Rule] 10,
\"NucleiMaxCount\" \[Rule] 10000

";


pipelineSegmentNuclei::usage="
pipelineSegmentNuclei[assoc_Association,opts:OptionsPattern[]]

performs cell nuclei segmentation using the function segmentNuclei[nucleiImage, nucleiSeedsImage] with the pre-processed image \"Nuclei\" (\"\!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\\\\"\",\nFontSlant->\"Italic\"]\)) and the detected seeds image \"NucleiSeeds\" (\"\!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiSeeds\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\\\\"\",\nFontSlant->\"Italic\"]\)). The nuclei binary image is exported to an .mx file to  \"\!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiBinary\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\\\\"\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\) The association \!\(\*
StyleBox[\"assoc\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)is changed accordingly to <|\"Nuclei\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\",\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)\"NucleiSeeds\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiSeeds\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\",\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)\"NucleiBinary\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiBinary\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)|> and returned.
";


pipelineMeasure::usage="
pipelineMeasure[assoc_Association,opts:OptionsPattern[]]

measures features for all components in the binary image \"NucleiBinary\". The features are exported to an .mx file to \"\!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiFeatures\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"\\\\\\\"\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)The association \!\(\*
StyleBox[\"assoc\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)is changed accordingly to <|\"Nuclei\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\",\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)\"NucleiSeeds\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiSeeds\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\",\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)\"NucleiBinary\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiBinary\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\",\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)\"NucleiFeatures\" \[Rule] \!\(\*
StyleBox[\"dump_directory\",\nFontSlant->\"Italic\"]\)\\\!\(\*
StyleBox[\"nuclei_image\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"_name\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"-\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"NucleiFeatures\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"mx\",\nFontSlant->\"Italic\"]\)|> and returned.

\"MeasureProperties\" \[Rule] features to measure (default: {\"Label\",\"Centroid\",\"IntensityCentroid\",\"Count\",\"MeanCentroidDistance\",\"MaxCentroidDistance\",\"MinCentroidDistance\",\"PerimeterCount\",\"BoundingBox\",\"MeanIntensity\",\"MaxIntensity\",\"MinIntensity\",\"StandardDeviationIntensity\",\"TotalIntensity\",\"Mask\"})
";


pipelineExport::usage="
pipelineExport[assoc_Association,opts:OptionsPattern[]]

exports the segmentation results to \"ExportDirectory\". The images \"Nuclei\" and \"NucleiBinary\" are exported in TIF format. \"NucleiFeatures\" are exported as MX file. A summary containing pipeline settings and runtime are exported as XLSX spread sheet.

Options:
\"ExportDirectory\" \[Rule] export directory (default: \"D:\\SegmentationPipeline\\New folder\"),
";


pipelineExportSummary::usage="
pipelineExportSummary[assoc_Association,settings_List,opts:OptionsPattern[]]
A summary containing pipeline settings and runtime of the segmentation for \!\(\*
StyleBox[\"assoc\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)are exported as XLSX spread sheet.

Options:
\"ExportDirectory\" \[Rule] export directory (default: \"D:\\SegmentationPipeline\\New folder\"),
";


resizeImage3D[image_Image3D,factor_?NumberQ]:=If[factor!=1,ImageResize[image,Scaled[factor]],image]


resampleImage3D[image_Image3D,xFactor_?NumberQ,yFactor_?NumberQ,zFactor_?NumberQ]:=If[xFactor==1&&yFactor==1&&zFactor==1,image,ImageResize[image,{xFactor,yFactor,zFactor}*ImageDimensions[image]]];


threeWayLocalAdaptiveBinarize[image_Image3D,r_?NumberQ,\[Alpha]_?NumberQ,\[Beta]_?NumberQ,\[Gamma]_?NumberQ]:=Block[
{},
Quiet[
ImageMultiply[ImageMultiply[Image3D[ParallelMap[LocalAdaptiveBinarize[#,r,{\[Alpha],\[Beta],\[Gamma]}]&,Image3DSlices[image]]],ImageRotate[Image3D[ParallelMap[LocalAdaptiveBinarize[#,r,{\[Alpha],\[Beta],\[Gamma]}]&,Image3DSlices[ImageRotate[image,{90 Degree,{1,0,0}}]]]],{-90 Degree,{1,0,0}}]],
ImageRotate[Image3D[ParallelMap[LocalAdaptiveBinarize[#,r,{\[Alpha],\[Beta],\[Gamma]}]&,Image3DSlices[ImageRotate[image,{90 Degree,{0,1,0}}]]]],{-90 Degree,{0,1,0}}]]]
];


multiScaleBlobDetector[image_,{rMin_?NumberQ,rMax_?NumberQ},opts:OptionsPattern[]]:=Block[
{\[Sigma]Norm,\[Sigma]Min,\[Sigma]Max,r,s,rc,bb,bw},
(*The relationship between the radius of detected objects and the scale is r =Sqrt[2]*\[Sigma]. By measuring the minimal
 and maximal radii of nuclei in voxels this can be directly used to obtain \[Sigma]Min and \[Sigma]Max or the LoG filtering.*)
{\[Sigma]Min,\[Sigma]Max}=Round[#/Sqrt[2]]&/@{rMin,rMax};
\[Sigma]Norm=Length@ImageDimensions@image;
(*initialize the response and scale images*)
r=s=Head[image][ConstantArray[0,Reverse@ImageDimensions@image]];(*Convolve image with scale-normalized Laplacian at several scales. Keep the information for the maximum response at each pixel/voxel and additionally store the scale.*)
Map[
(*generate the multi-scale log image*)
(
rc=ColorNegate@ImageMultiply[LaplacianGaussianFilter[image,2#],#^\[Sigma]Norm];(*apply LoG at current scale \[Rule] rc*)
bb=Binarize[ImageSubtract[rc,r],0];(*find pixels/voxels in rc with higher intensity than in r \[Rule] bb*)
bw=ColorNegate@bb; (*the inverted bb corresponds to those pixels/voxels that should be kept from r \[Rule] bw*)
r=ImageAdd[ImageMultiply[bb,rc],ImageMultiply[bw,r]]; (*compute new response image \[Rule] r*)
s=ImageAdd[s,bb]; (*compute new scale image \[Rule] s*)
)&,Range[\[Sigma]Min,\[Sigma]Max] (*the range of scales that LoG filtering should be applied*)
];
{r,s}
];


addBackgroundSeed[seedImage_Image3D]:=ImageAdd[seedImage,ImagePad[Dilation[ImagePad[DeleteSmallComponents[seedImage,1],1,1],1],-1,0]];


Options[pipelineImport]={
"ImageZScalingFactor"->4,
"ImageScalingFactor"->0.5,
"Deconvolution"->True,
"DeconvolutionMaxIterations"->10,
"DeconvolutionKernelXY"->2,
"DeconvolutionKernelZ"->3
};
pipelineImport[assoc_Association,opts:OptionsPattern[]]:=Block[
{dumpDir,date,exportDir,newAssoc,exp},

newAssoc=assoc;
exp=Export[FileNameJoin[{assoc["DumpDirectory"],FileBaseName@assoc["Nuclei"]<>".mx"}],

If[OptionValue["Deconvolution"],
	ImageDeconvolve[resizeImage3D[resampleImage3D[Import[assoc["Nuclei"],"Image3D"],1,1,OptionValue["ImageZScalingFactor"]],OptionValue["ImageScalingFactor"]],GaussianMatrix[{{OptionValue["DeconvolutionKernelZ"],OptionValue["DeconvolutionKernelXY"],OptionValue["DeconvolutionKernelXY"]}}],Method->{"RichardsonLucy","Preconditioned"-> True},MaxIterations->IntegerPart[OptionValue["DeconvolutionMaxIterations"]]],
	resizeImage3D[resampleImage3D[Import[assoc["Nuclei"],"Image3D"],1,1,OptionValue["ImageZScalingFactor"]],OptionValue["ImageScalingFactor"]]
]
];
newAssoc["Nuclei"]=exp;
newAssoc
(*Append[assoc,"ExportDirectory"\[Rule]exportDir]*)
];


pipelineGatherFiles[directory_String,pattern_String]:=Map[Association["Nuclei"->#]&,FileNames[pattern,{directory}]]


Options[pipelineDetectSeeds]={
"NucleiSeedDetectionMethod"->"LaplacianOfGaussian",
"MaxDetectionRange"->0.1,
"NucleiSeedDetectionMinRadius"->4,
"NucleiSeedDetectionMaxRadius"->12,
"NucleiSeedDilation"->2
};
pipelineDetectSeeds[assoc_Association,opts:OptionsPattern[]]:=Block[
{raw,bin,nsd=OptionValue["NucleiSeedDilation"],mdr=OptionValue["MaxDetectionRange"]},
raw=Import[assoc["Nuclei"]]; bin=Import[assoc["NucleiBinary"]];
Append[assoc,
"NucleiSeeds"->Export[FileNameJoin[{DirectoryName[assoc["Nuclei"]],FileBaseName[assoc["Nuclei"]]<>"-"<>"NucleiSeeds"<>".mx"}],

Dilation[addBackgroundSeed[ImageMultiply[
	Switch[ToString@OptionValue["NucleiSeedDetectionMethod"],
	"LoG",
	MaxDetect@First@multiScaleBlobDetector[raw,{OptionValue["NucleiSeedDetectionMinRadius"],OptionValue["NucleiSeedDetectionMaxRadius"]}],
	"Morphological",
	MaxDetect[ImageAdjust@DistanceTransform[bin], mdr],
	_,
	Binarize[ImageAdd[MaxDetect@First@multiScaleBlobDetector[raw,{OptionValue["NucleiSeedDetectionMinRadius"],OptionValue["NucleiSeedDetectionMaxRadius"]}], MaxDetect[ImageAdjust@DistanceTransform[bin],mdr]],0]
	],bin]],DiskMatrix[{nsd,nsd,nsd}]
	]
]
]
];


Options[initialSegmentation]={
"NucleiFilterRange"->1,
"NucleiThresholdRange"->12,
"NucleiMeanFactor"->1,
"NucleiStandardDeviationFactor"->0,
"NucleiBackgroundFactor"->0.25,
"HoleFillingRange"->1
};
initialSegmentation[nucleiImage_Image3D,opts:OptionsPattern[]]:=Block[
{initialBinaryImage,backgroundMean,prepro,bgrMeanGlobal,mainBinaryImage,hfr=OptionValue["HoleFillingRange"]},
(*determine background intensity*)
bgrMeanGlobal=Mean[ComponentMeasurements[{MorphologicalComponents@ColorNegate[Binarize[GaussianFilter[nucleiImage,OptionValue["NucleiFilterRange"]],Method->"MinimumError"]],nucleiImage},"MeanIntensity"][[All,2]]];

(*perform initial binarization of cell nuclei*)
Closing[threeWayLocalAdaptiveBinarize[MedianFilter[nucleiImage,OptionValue["NucleiFilterRange"]],OptionValue["NucleiThresholdRange"],OptionValue["NucleiMeanFactor"],OptionValue["NucleiStandardDeviationFactor"],OptionValue["NucleiBackgroundFactor"]*bgrMeanGlobal],DiskMatrix[{hfr,hfr,hfr}]]
];



Options[pipelineInitialSegmentation]=Options[initialSegmentation];
pipelineInitialSegmentation[assoc_Association,opts:OptionsPattern[]]:=Append[assoc,
"NucleiBinary"->Export[FileNameJoin[{DirectoryName[assoc["Nuclei"]],FileBaseName[assoc["Nuclei"]]<>"-"<>"NucleiBinary"<>".mx"}],
initialSegmentation[Import[assoc["Nuclei"]],FilterRules[{opts},Options[initialSegmentation]]
]
]
]


Options[segmentNuclei]={

};
segmentNuclei[nucleiImage_Image3D,nucleiSeedsImage_Image3D,initialBinaryImage_Image3D,opts:OptionsPattern[]]:=Block[
{
backgroundMean,components,selectedLabels,prepro,bgrMeanGlobal,mainBinaryImage
},
(*compute watershed transform*)
Image3D[Threshold[MorphologicalComponents[WatershedComponents[ColorNegate@nucleiImage,nucleiSeedsImage,Method->"Immersion"]*ImageData[initialBinaryImage]],0],"Bit"]
];


Options[pipelineSegmentNuclei]=Options[segmentNuclei];
pipelineSegmentNuclei[assoc_Association,opts:OptionsPattern[]]:=Append[assoc,
"NucleiBinary"->Export[FileNameJoin[{DirectoryName[assoc["Nuclei"]],FileBaseName[assoc["Nuclei"]]<>"-"<>"NucleiBinary"<>".mx"}],
segmentNuclei[Import[assoc["Nuclei"]],Import[assoc["NucleiSeeds"]],Import[assoc["NucleiBinary"]],FilterRules[{opts},Options[segmentNuclei]]
]
]
]


Options[pipelineMeasure]={"MeasureProperties"->{"Label","Centroid","IntensityCentroid","Count","MeanCentroidDistance","MaxCentroidDistance","MinCentroidDistance","PerimeterCount","BoundingBox","MeanIntensity","MaxIntensity","MinIntensity","StandardDeviationIntensity","TotalIntensity","Mask"}};
pipelineMeasure[assoc_Association,opts:OptionsPattern[]]:=Block[
{
props=OptionValue["MeasureProperties"]
},
Append[assoc,"NucleiFeatures"->
Export[FileNameJoin[{DirectoryName[assoc["Nuclei"]],FileBaseName[assoc["Nuclei"]]<>"-"<>"NucleiFeatures"<>".mx"}],Map[MapThread[Rule, {props,#}]&, 
Values[ComponentMeasurements[{MorphologicalComponents[Import[Normal[assoc["NucleiBinary"]]]],Import[assoc["Nuclei"]]},props]]
]
]
]
]


Options[pipelineExport]={};
pipelineExport[assoc_Association,opts:OptionsPattern[]]:=Block[
{nuclei,colorized,features,binary},

(*import data for exporting*)
features=Import[assoc["NucleiFeatures"]];
nuclei=Image3DSlices@Import[assoc["Nuclei"]];
binary=Image3DSlices@Import[assoc["NucleiBinary"]];

(*export features*)

Needs["JLink`"];
ReinstallJava[JVMArguments -> "-Xmx1000000m"];
Export[FileNameJoin[{assoc["ExportDirectory"],FileBaseName[assoc["Nuclei"]]<>"-"<>"NucleiFeatures"<>".xlsx"}],
Prepend[
Prepend[
Prepend[Values[FilterRules[#,Except["Mask"]]&/@features],Keys@FilterRules[features[[1]],Except["Mask"]]],{}],
{"Nuclei Features","",DateString[]}
]
];
(*export raw and binary*)
Export[FileNameJoin[{assoc["ExportDirectory"],FileBaseName[assoc["Nuclei"]]<>"-"<>"Nuclei"<>".tif"}],nuclei];
Export[FileNameJoin[{assoc["ExportDirectory"],FileBaseName[assoc["Nuclei"]]<>"-"<>"NucleiBinary"<>".tif"}],binary];

(*export segmentation overlay*)

colorized=Image3DSlices[Colorize[MorphologicalComponents@Import[assoc["NucleiBinary"]]]];
Export[FileNameJoin[{assoc["ExportDirectory"],FileBaseName[assoc["Nuclei"]]<>"-"<>"NucleiColorized"<>".tif"}],colorized];
Export[FileNameJoin[{assoc["ExportDirectory"],FileBaseName[assoc["Nuclei"]]<>"-"<>"NucleiOverlay"<>".tif"}],Table[ImageCompose[ImageAdjust@nuclei[[i]],{SetAlphaChannel[colorized[[i]],Binarize[colorized[[i]],0]],0.75}],{i,1,Length@nuclei,1}]];
Export[FileNameJoin[{assoc["ExportDirectory"],FileBaseName[assoc["Nuclei"]]<>"-"<>"NucleiFeatures"<>".mx"}],Rule["NucleiFeatures",features]];
assoc
];


Options[segmentationPipeline]=DeleteDuplicates[
Join[
	Options[pipelineImport],
	Options[pipelineInitialSegmentation],
	Options[pipelineDetectSeeds],
	Options[pipelineSegmentNuclei],
	Options[pipelineMeasure],
	Options[pipelineExport],
	Options[pipelineExportSummary]
]
];
segmentationPipeline[assoc_Association,opts:OptionsPattern[]]:=Block[
{result,time},

time=Round@First@AbsoluteTiming[
result=RightComposition[
If[Quiet[And@@Map[Check[FileExistsQ[#],False]&,Values@#]],
pipelineImport[#,FilterRules[{opts},Options[pipelineImport]]],
Print["Missing files in ", #]; Abort[];
]&,
pipelineInitialSegmentation[#,FilterRules[{opts},Options[pipelineInitialSegmentation]]]&,
pipelineDetectSeeds[#,FilterRules[{opts},Options[pipelineDetectSeeds]]]&,
pipelineSegmentNuclei[#,FilterRules[{opts},Options[pipelineSegmentNuclei]]]&,
pipelineMeasure[#,FilterRules[{opts},Options[pipelineMeasure]]]&,
pipelineExport[#,FilterRules[{opts},Options[pipelineExport]]]&
][assoc]
];
];


Options[pipelineExportSummary]={};
pipelineExportSummary[exportFileName_String,settings_List,opts:OptionsPattern[]]:=Export[exportFileName,Prepend[Prepend[(settings)/.Rule->List,{}],{"Segmentation Settings","",DateString[]}]];


segmentationPipeline[folder_String,pattern_String,settingsFile_String]:=Block[
{datasets,date,dumpDir,exportDir,settings,kernels},

(*retrieve pipeline settings from xlsx file*)
settings=Map[ToExpression,Rule@@@(First[Import[settingsFile]][[3;;-1,1;;2]]),{2}];
(*gather datasets that match the input pattern*)
datasets=pipelineGatherFiles[folder,pattern];

(*create output folders for segmentation and dump*)
(*date=DateString[{"Year","Month","Day","_","Hour","Minute"}];*)
date=StringReplace[FileBaseName@settingsFile,"_SegmentationSettings"->""];

dumpDir=FileNameJoin[{folder,date<>"_Temporary"}];
exportDir=FileNameJoin[{folder,date<>"_Segmentation"}];

(*apply segmentation to each dataset*)
Map[(segmentationPipeline[#,settings])&,Append[#,{"DumpDirectory"->dumpDir,"ExportDirectory"->exportDir}]&/@datasets];
Quiet[DeleteDirectory[dumpDir,DeleteContents->True]];

pipelineExportSummary[FileNameJoin[{exportDir,date<>"_SegmentationSettings.xlsx"}],settings];
];


segmentationPipelineBatch[folder_String,pattern_String,settingsFile_String]:=Block[
{runcmd,date,dumpDir,exportDir},

(*date=DateString[{"Year","Month","Day","_","Hour","Minute"}];*)
date=StringReplace[FileBaseName@settingsFile,"_SegmentationSettings"->""];
Quiet[dumpDir=CreateDirectory@FileNameJoin[{folder,date<>"_Temporary"}]];
Quiet[exportDir=CreateDirectory@FileNameJoin[{folder,date<>"_Segmentation"}]];

Export[
FileNameJoin[{exportDir,date<>"_SegmentationPipelineBatch.m"}],
"
Quiet[<<\""<>StringReplace[cnsPackagePath,"\\" -> "\\\\"]<>"\"];
segmentationPipeline[\""<>StringReplace[folder,"\\" -> "\\\\"]<>"\",\""<>pattern<>"\",\""<>StringReplace[settingsFile,"\\" -> "\\\\"]<>"\"];
Quit[];
",
"Text"
];

Export[
FileNameJoin[{exportDir,date<>"_SegmentationPipelineBatch.bat"}],
"\"math\" -script \""<>FileNameJoin[{exportDir,date<>"_SegmentationPipelineBatch.m"}]<>"\"",
"Text"];

Export[FileNameJoin[{exportDir,date<>"_SegmentationPipelineBatch.vbs"}],
"Set oShell = CreateObject (\"Wscript.Shell\") 
Dim strArgs
strArgs = \"cmd /c \"\""<>FileNameJoin[{exportDir,date<>"_SegmentationPipelineBatch.bat"}]<>"\"\"\"
oShell.Run strArgs, 0, false","Text"];
runcmd = "@%windir%\\system32\\wscript.exe //Nologo " <> "\"" <> FileNameJoin[{exportDir,date<>"_SegmentationPipelineBatch.vbs"}] <> "\" %*";
Run[runcmd];
];


cnsFolderChooser[dir_String,opts:OptionsPattern[]]:=Block[
{f},
f=SystemDialogInput["Directory",dir,WindowTitle->"Choose a directory"];
If[f=!=$Canceled&&DirectoryQ@ToString@f,f,$Failed]
];


cnsFileChooser[dir_String,ext_String,opts:OptionsPattern[]]:=Block[
{f},
f=SystemDialogInput["FileOpen",FileNameJoin[{dir,"*."<>ext}],WindowTitle->"Choose a ."<>ext<>" file"];
If[f=!=$Canceled&&FileExistsQ@ToString@f&&FileExtension@ToString@f===ext,f,$Failed]
];


cnsFilePattern[dir_String]:=Block[
{img,fTemp=""},
DialogInput[
{},
img={768,256};
Panel@Column[
{
Tooltip[Row[{"File pattern ", InputField[Dynamic[fTemp],String,FieldSize->Medium,ContinuousAction->True]},""],
"Enter a file name pattern. The pipeline will only process TIF files that match the file pattern.",cnsTooltipOpts],
Dynamic@Pane[Grid[List@FileNameTake[#]&/@FileNames["*"<>fTemp<>"*.tif",{dir}],Alignment->Left], ImageSize->Dynamic@img,Scrollbars->True]
,
Row[{
Button["OK",DialogReturn[fTemp],ImageSize->128],
Button["Cancel",DialogReturn[$Failed],ImageSize->128]
}]
}],
WindowSize->Dynamic@All
]
];


cnsImageCalibration[{}]:=cnsImageCalibration[{1,1,1,1}];
cnsImageCalibration[{x_?NumberQ,y_?NumberQ,z_?NumberQ,imgScale_?NumberQ}]:=Block[
{xTemp=x,yTemp=y,zTemp=z,imgScaleTemp=imgScale,calibration},
calibration=DialogInput[
	{},
	Panel@Column[
	{
	Tooltip[Row[{"Voxel size (x)",InputField[Dynamic[xTemp],Number,FieldSize->5],"\[Micro]m"}," "],"Enter voxel size in x.",cnsTooltipOpts],
	Tooltip[Row[{"Voxel size (y)",InputField[Dynamic[yTemp],Number,FieldSize->5],"\[Micro]m"}," "],"Enter voxel size in y.",cnsTooltipOpts],
	Tooltip[Row[{"Voxel size (z)",InputField[Dynamic[zTemp],Number,FieldSize->5],"\[Micro]m"}," "],"Enter voxel size in z.",cnsTooltipOpts],

	Tooltip[Row[{"Image scaling",Manipulator[Dynamic[imgScaleTemp],{0.1,1,0.05},Appearance->"Open",AppearanceElements->{"InputField","StepLeftButton","StepRightButton"}]}," "],"The image will be scaled down by the factor chosen.",cnsTooltipOpts],
	Row[
{
Button["OK",
DialogReturn[{xTemp,yTemp,zTemp,imgScaleTemp}],ImageSize->128],
Button["Cancel",DialogReturn[$Failed],ImageSize->128]
}
]
	},Alignment->Center
	],WindowTitle->"Calibration"
];
calibration
]


pipelineAdjustSegmentationGUI[inputFile_String,calibration_List]:=DynamicModule[
{
(*image variables*)
imageSlicesxy={},imageSliceszy={},currentSlicexy=1,currentSlicezy=1,ratios={1,1,4},x=0.69,y=0.69,z=2,imgScale=1, deconvolution=False, xyDeconRange=3, zDeconRange=2,
deconxy, deconzy,preproxy,preprozy,

(*segmentation parameter variables*)
localThresholdRange,localThresholdMean=1.,localThresholdStd=0,localThresholdBackground=0.25,preFilterRange=1,holefillingRange=1,maxDetRange=0.1,seedDilationRange,logMinMaxRange={2,5},nucleiMinCount=1,nucleiMaxCount=Infinity,

(*segmentation result variables*)
bgrMeanGlobalxy,bgrMeanGlobalzy,seedsxy,seedszy,initSegxy,initSegzy,watershedxy,watershedzy,finalImagexy,finalImagezy,

(*display variables*)
seeds=True,seedDetectionMethod="Morphological",showImage="Pre-processed",overlay="Final",imgSize=512,tabviewSpec=1,tooltipOpts={TooltipDelay->0.5,TooltipStyle->{CellFrameColor->Black,CellFrame->1}}
},

(*compute the ratios for image resampling and import the image*)
ratios=(#/#[[1]])&@calibration[[1;;3]];
imgScale=Last[calibration];
Block[{image},
image=resizeImage3D[resampleImage3D[Import[inputFile,"Image3D"],ratios[[1]],ratios[[2]],ratios[[3]]],imgScale];
imageSlicesxy=Image3DSlices[image];
imageSliceszy=ImageReflect[ImageRotate[#, -90 Degree],Left->Right]&/@Image3DSlices[image,All,3];
];

localThresholdMean=1.0;localThresholdStd=0;localThresholdBackground=0.25;preFilterRange=1;holefillingRange=1;maxDetRange=0.1;

(*main*)
Manipulate[

(*pre-procssing*)
If[deconvolution,
	(
	deconxy=ImageDeconvolve[imageSlicesxy[[currentSlicexy]],GaussianMatrix[xyDeconRange],Method->{"RichardsonLucy","Preconditioned"-> True},MaxIterations->10];
	deconzy=ImageDeconvolve[imageSliceszy[[currentSlicezy]],GaussianMatrix[{{xyDeconRange,zDeconRange}}],Method->{"RichardsonLucy","Preconditioned"-> True},MaxIterations->10];
	),
	deconxy=imageSlicesxy[[currentSlicexy]];
	deconzy=imageSliceszy[[currentSlicezy]];
];

preproxy=MedianFilter[deconxy,preFilterRange];
preprozy=MedianFilter[deconzy,preFilterRange];
bgrMeanGlobalxy=Mean[ComponentMeasurements[{MorphologicalComponents@ColorNegate[Binarize[GaussianFilter[imageSlicesxy[[currentSlicexy]],preFilterRange],Method->"MinimumError"]],imageSlicesxy[[currentSlicexy]]},"MeanIntensity"][[All,2]]];
bgrMeanGlobalzy=Mean[ComponentMeasurements[{MorphologicalComponents@ColorNegate[Binarize[GaussianFilter[imageSliceszy[[currentSlicezy]],preFilterRange],Method->"MinimumError"]],imageSliceszy[[currentSlicezy]]},"MeanIntensity"][[All,2]]];

(*segmentation*)
initSegxy=Closing[LocalAdaptiveBinarize[preproxy,localThresholdRange,{localThresholdMean,localThresholdStd,localThresholdBackground*bgrMeanGlobalxy}],DiskMatrix[holefillingRange]];
initSegzy=Closing[LocalAdaptiveBinarize[preprozy,localThresholdRange,{localThresholdMean,localThresholdStd,localThresholdBackground*bgrMeanGlobalzy}],DiskMatrix[holefillingRange]];

Switch[seedDetectionMethod,
"Morphological",
(
seedsxy=Dilation[ImageMultiply[MaxDetect[ImageAdjust@DistanceTransform[initSegxy],maxDetRange],initSegxy],DiskMatrix[seedDilationRange]];
seedszy=Dilation[ImageMultiply[MaxDetect[ImageAdjust@DistanceTransform[initSegzy],maxDetRange],initSegzy],DiskMatrix[seedDilationRange]];
),

"LoG",
(
seedsxy=Dilation[ImageMultiply[MaxDetect[First[multiScaleBlobDetector[imageSlicesxy[[currentSlicexy]],{logMinMaxRange[[1]],logMinMaxRange[[2]]}]]],initSegxy],DiskMatrix[seedDilationRange]];
seedszy=Dilation[ImageMultiply[MaxDetect[First[multiScaleBlobDetector[imageSliceszy[[currentSlicezy]],{logMinMaxRange[[1]],logMinMaxRange[[2]]}]]],initSegzy],DiskMatrix[seedDilationRange]];
),
_,
(
seedsxy=Dilation[Binarize[ImageAdd[ImageMultiply[MaxDetect[ImageAdjust@DistanceTransform[initSegxy],maxDetRange],initSegxy],ImageMultiply[MaxDetect[First[multiScaleBlobDetector[imageSlicesxy[[currentSlicexy]],{logMinMaxRange[[1]],logMinMaxRange[[2]]}]]],initSegxy]],0],DiskMatrix[seedDilationRange]];
seedszy=Dilation[Binarize[ImageAdd[ImageMultiply[MaxDetect[ImageAdjust@DistanceTransform[initSegzy],maxDetRange],initSegzy],ImageMultiply[MaxDetect[First[multiScaleBlobDetector[imageSliceszy[[currentSlicezy]],{logMinMaxRange[[1]],logMinMaxRange[[2]]}]]],initSegzy]],0],DiskMatrix[seedDilationRange]];
)
];

watershedxy=ImageMultiply[Colorize@WatershedComponents[ColorNegate@imageSlicesxy[[currentSlicexy]],seedsxy,Method->"Immersion"],initSegxy];
watershedzy=ImageMultiply[Colorize@WatershedComponents[ColorNegate@imageSliceszy[[currentSlicezy]],seedszy,Method->"Immersion"],initSegzy];

(*overlay and highlights*)
Switch[showImage,
	"Raw", 
	(
	finalImagexy=ImageAdjust@imageSlicesxy[[currentSlicexy]];finalImagezy=ImageAdjust@imageSliceszy[[currentSlicezy]];
	),
	"Deconvolved", 
	(
	finalImagexy=ImageAdjust@deconxy;
	finalImagezy=ImageAdjust@deconzy;
	),
	_, 
	finalImagexy=ImageAdjust@preproxy;
	finalImagezy=ImageAdjust@preprozy;
];

Switch[overlay,
"Initial",
(
finalImagexy=HighlightImage[finalImagexy,{RGBColor[1/3,1,1/3,0.5],initSegxy}];
finalImagezy=HighlightImage[finalImagezy,{RGBColor[1/3,1,1/3,0.5],initSegzy}];
),
"Final",
(
finalImagexy=ImageCompose[finalImagexy,{SetAlphaChannel[watershedxy,Binarize[watershedxy,0]],0.5}];
finalImagezy=ImageCompose[finalImagezy,{SetAlphaChannel[watershedzy,Binarize[watershedzy,0]],0.5}];
),
_, 
""
];

If[seeds,
	finalImagexy=HighlightImage[finalImagexy,{RGBColor[1,0,0,0.5],seedsxy}];
	finalImagezy=HighlightImage[finalImagezy,{RGBColor[1,0,0,0.5],seedszy}];
];

(*image visualization*)
TabView[
{
"segmentation"->Grid[
{
{Style["xy view",16,Bold,FontFamily->"Helvetica"],Style["zy view",16,Bold,FontFamily->"Helvetica"]},
{Dynamic@Show[finalImagexy,ImageSize->Dynamic@{Automatic,imgSize}],Dynamic@Show[finalImagezy,ImageSize->Dynamic@{Automatic,imgSize}]},
{SwatchLegend[{LightGreen,Red},{"initial segmentation","seeds"}],SpanFromLeft}
},Alignment->{Left,Top}
]
},Dynamic@tabviewSpec,Alignment->{Left,Top}],

(*Controls*)

Grid[
{
(*pre-processing controls*)
{Style["pre-processing",16,Bold]},
{"deconvolution",Tooltip[Control@{{deconvolution,True,""},{True,False}},"Apply deconvolution.",tooltipOpts]},
{Dynamic["range [xy="<>ToString[xyDeconRange]<>" pixels, z="<>ToString[zDeconRange]<>" pixels]"],
Row[{
Dynamic["xy"],Tooltip[Control[{{xyDeconRange,3,""},1,10,1,ImageSize->Small,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False}],"Range of deconvolution in xy.",tooltipOpts],
Dynamic["z"],Tooltip[Control[{{zDeconRange,2,""},1,10,1,ImageSize->Small,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False}],"Range of deconvolution in z.",tooltipOpts]
}," "]
},
{Dynamic["median filter range ["<>ToString[preFilterRange]<>" pixels]"],Tooltip[Control[{{preFilterRange,1,""},0,8,1,ImageSize->Medium,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False}],"Range of the gaussian and median filters used for pre-processing.",tooltipOpts]},
{},

(*segmentation controls*)
{Style["segmentation",16,Bold]},
{Dynamic["local threshold range ["<>ToString[localThresholdRange]<>" pixels]"],Tooltip[Control[{{localThresholdRange,5,""},1,64,1,ImageSize->Medium,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False}],"Range of the inital local threshold in pixels (voxels). The threshold is computed as \!\(\*
StyleBox[\"t\",\nFontSlant->\"Italic\"]\) = \[Alpha]*\[Mu] + \[Beta]*\[Sigma] + \[Gamma], where \[Micro] is the mean intensity, \[Sigma] is the intensity standard deviation. \[Alpha], \[Beta] and \[Gamma] are factors that control the influcence. All intensity values are in the range [0,1].",tooltipOpts]},
(*", \[Beta]="<>ToString[localThresholdStd]<>*)
{Dynamic["local threshold factors\n[\[Alpha]="<>ToString[localThresholdMean]<>", \[Gamma]="<>ToString[localThresholdBackground]<>"]"],
Row[{
"\[Alpha]", Tooltip[Slider[Dynamic[localThresholdMean],{0,1.,0.05},ImageSize->Small,Appearance->{"DownArrow","Open"},(*AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},*)ContinuousAction->False],"Factor \[Alpha] that controls the influence of the mean intensity for the initial local threshold. The threshold is computed as \!\(\*
StyleBox[\"t\",\nFontSlant->\"Italic\"]\) = \[Alpha]*\[Mu] + \[Beta]*\[Sigma] + \[Gamma], where \[Micro] is the mean intensity, \[Sigma] is the intensity standard deviation.",tooltipOpts],
"\[Gamma]" Tooltip[Slider[Dynamic[localThresholdBackground],{0,1.,0.05},ImageSize->Small,Appearance->{"DownArrow","Open"},(*AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},*)ContinuousAction->False],"\[Gamma] controls the influence of the background intensity. The threshold is computed as \!\(\*
StyleBox[\"t\",\nFontSlant->\"Italic\"]\) = \[Alpha]*\[Mu] + \[Beta]*\[Sigma] + \[Gamma], where \[Micro] is the mean intensity, \[Sigma] is the intensity standard deviation.",tooltipOpts]
(*"\[Beta]",Tooltip[Control[{{localThresholdStd,0,""},-1,1,0.1,ImageSize\[Rule]Small,Appearance\[Rule]"DownArrow",AppearanceElements\[Rule]{"InputField"}}],"Factor \[Beta] that controls the influence of the intensity standard deviation for the initial local threshold.",tooltipOpts],*)
}," "]
},
{"",Row[{
"\[Alpha]",Tooltip[InputField[Dynamic[localThresholdMean],Number,FieldSize->5],"Minimum range of the Laplacian of Gaussian (LoG) seed detection, i.e. minimum and maximum radius of cell nuclei.",tooltipOpts],
"\[Gamma]",Tooltip[InputField[Dynamic[localThresholdBackground],Number,FieldSize->5],"Maximum range of the Laplacian of Gaussian (LoG) seed detection, i.e. minimum and maximum radius of cell nuclei.",tooltipOpts]
}," "]},
{Dynamic["hole filling range ["<>ToString[holefillingRange]<>" pixels]"],Tooltip[Control[{{holefillingRange,1,""},0,10,1,ImageSize->Medium,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False}],"Range of hole filling operator.",tooltipOpts]},
{"seed detection method ",Tooltip[Control[{{seedDetectionMethod,"Morphological",""},{"Morphological","LoG","Combined"},ControlType->RadioButton}],"Seed detection method to use for watershed segmentation.",tooltipOpts],""},
{Dynamic["seed detection range\n[min="<>ToString[logMinMaxRange[[1]]]<>" pixels, "<>"max="<>ToString[logMinMaxRange[[2]]]<>" pixels]"],
Row[{
Tooltip[Control[{{logMinMaxRange,{2,5},""},1,64,1,IntervalSlider,Method->"Push",MinIntervalSize->1, ContinuousAction->False}],"Minimum and maximum range of the Laplacian of Gaussian (LoG) seed detection, i.e. minimum and maximum radius of cell nuclei.",tooltipOpts]
}," "]
},
{"",
Row[{
"min",Tooltip[InputField[Dynamic[logMinMaxRange[[1]]],Number,FieldSize->5],"Minimum range of the Laplacian of Gaussian (LoG) seed detection, i.e. minimum and maximum radius of cell nuclei.",tooltipOpts],
"max",Tooltip[InputField[Dynamic[logMinMaxRange[[2]]],Number,FieldSize->5],"Maximum range of the Laplacian of Gaussian (LoG) seed detection, i.e. minimum and maximum radius of cell nuclei.",tooltipOpts]
}," "]
},

{Dynamic["max detection range ["<>ToString[maxDetRange]<>" pixels]"],Tooltip[Control[{{maxDetRange,0.1,""},0,1,0.01,ImageSize->Medium,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False}],"Range of max detection operator.",tooltipOpts]},

{Dynamic["seed dilation ["<>ToString[seedDilationRange]<>" pixels]"],Tooltip[Control[{{seedDilationRange,1,""},0,16,1,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False}],"Amount of seed dilation applied to the detected seeds. Higher values will merge adjacent seed locations into one seed.",tooltipOpts]},
{},

(*view controls*)
{Style["view options",16,Bold]},
{Dynamic["plane [xy="<>ToString[currentSlicexy]<>", zy="<>ToString[currentSlicezy]<>"]"],
Row[{
Dynamic["xy"],Tooltip[Control@{{currentSlicexy,IntegerPart[Length@imageSlicesxy/2],""},1,Length@imageSlicesxy,1,ImageSize->Small,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False},"Image plane along z.",tooltipOpts],
Dynamic["zy"],Tooltip[Control@{{currentSlicezy,IntegerPart[Length@imageSliceszy/2],""},1,Length@imageSliceszy,1,ImageSize->Small,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False},"Image plane along x.",tooltipOpts]
}," "]
},
{"image size",Tooltip[Control@{{imgSize,512,""},16,1024,16,Appearance->"DownArrow",AppearanceElements->{"InputField","StepLeftButton","StepRightButton"}},"Size of the image.",tooltipOpts],""},
{"show seeds",Tooltip[Control@{{seeds,True,""},{True,False}},"Show/hide detected seeds.",tooltipOpts],""},
{"show image",Tooltip[Control[{{showImage,"Pre-processed",""},{"Raw","Deconvolved","Pre-processed"},ControlType->RadioButton}],"Image to display.",tooltipOpts],""},
{"segmentation overlay",Tooltip[Control[{{overlay,"Final",""},{"Initial","Final","None"},ControlType->RadioButton}],"Segmentation overlay to display.",tooltipOpts],""},
{},

{Row[{
Button["export settings",
(
Block[
{settingsFile,a},
settingsFile=SystemDialogInput["FileSave",FileNameJoin[{NotebookDirectory[],DateString[{"Year","Month","Day","_","Hour","Minute"}]<>"_SegmentationSettings.xlsx"}]];
If[settingsFile=!=$Canceled,
	a=Association@Options@segmentationPipeline;
	a["Deconvolution"]=deconvolution;
	a["DeconvolutionKernelXY"]=xyDeconRange;
	a["DeconvolutionKernelZ"]=zDeconRange;
	a["NucleiThresholdRange"]=localThresholdRange;
	a["NucleiMeanFactor"]=localThresholdMean;
	a["NucleiStandardDeviationFactor"]=localThresholdStd;
	a["NucleiSeedDetectionMinRadius"]=logMinMaxRange[[1]];
	a["NucleiSeedDetectionMaxRadius"]=logMinMaxRange[[2]];
	a["NucleiSeedDilation"]=seedDilationRange;
	a["NucleiBackgroundFactor"]=localThresholdBackground;
	a["NucleiFilterRange"]=preFilterRange;
	a["HoleFillingRange"]=holefillingRange;
	a["NucleiSeedDetectionMethod"]=seedDetectionMethod;
	a["MaxDetectionRange"]=maxDetRange;
	a=Append[a,{"ImageZScalingFactor"->ratios[[3]],"ImageScalingFactor"->imgScale}];
	Export[settingsFile, Prepend[Prepend[List@@@Normal@a,{}],{"Segmentation Settings","",DateString[]}]];
];
];
),Method->"Queued",ImageSize->{Automatic,30}
],

Button["import settings",
(
Block[
{settingsFile,a},
settingsFile=SystemDialogInput["FileOpen",".xlsx"];
If[settingsFile=!=$Canceled,
	a=ToExpression@Association[Rule@@@(First[Import[settingsFile]][[3;;-1,1;;2]])];
	deconvolution=a["Deconvolution"];
	xyDeconRange=IntegerPart@a["DeconvolutionKernelXY"];
	zDeconRange=IntegerPart@a["DeconvolutionKernelZ"];
	localThresholdRange=a["NucleiThresholdRange"];
	localThresholdMean=a["NucleiMeanFactor"];
	localThresholdStd=a["NucleiStandardDeviationFactor"];
	logMinMaxRange[[1]]=IntegerPart@a["NucleiSeedDetectionMinRadius"];
	logMinMaxRange[[2]]=IntegerPart@a["NucleiSeedDetectionMaxRadius"];
	seedDilationRange=IntegerPart@a["NucleiSeedDilation"];
	localThresholdBackground=a["NucleiBackgroundFactor"];
	preFilterRange=IntegerPart@a["NucleiFilterRange"];
	holefillingRange=IntegerPart@a["HoleFillingRange"];
	seedDetectionMethod=ToString[a["NucleiSeedDetectionMethod"]];
	maxDetRange=a["MaxDetectionRange"];
];
];
),Method->"Queued",ImageSize->{Automatic,30}
]
}
],SpanFromLeft
}
},Alignment->Right
],
Deployed->True,
TrackedSymbols:>{xyDeconRange,zDeconRange,deconvolution,currentSlicexy,currentSlicezy,localThresholdRange,localThresholdMean,localThresholdStd,localThresholdBackground,logMinMaxRange,seedDilationRange,preFilterRange,holefillingRange,maxDetRange,seeds,seedDetectionMethod,showImage,overlay,imgSize},ControlPlacement->Left,Alignment->Top,
Initialization:>{
localThresholdMean=1.0;localThresholdStd=0;localThresholdBackground=0.25;preFilterRange=1;
}
]
]


determinePrincipalComponentsLocal::usage="
determinePrincipalComponentsLocal[componentMask_]

determines the main axes and their extent of a component given in \!\(\*
StyleBox[\"componentMask\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)The input is expected to be a SparseArray. The function first extracts a list of points for all component elements and then uses Principal Component Analysis (PCA) to determine the main axes and the extent of the point cloud.
";


appendShape::usage="
appendShape[objects_List,opts:OptionsPattern[]]

determines the main axes and elongation of each of the object components using the function determinePrincipalComponentsLocal. The function appends main axes and their extent to each object in \!\(\*
StyleBox[\"objects\",\nFontSlant->\"Italic\"]\) in the form {\"MainAxes\" -> k, \"Extension\" -> l}.
";


determinePrincipalComponentsLocal[componentMask_]:=Block[
{cells,bobo,points,bKld,mKld,zDim,yDim,xDim},
{zDim,yDim,xDim}=Dimensions[componentMask];
points={#[[3]]-.5,yDim-#[[2]]+.5,zDim-#[[1]]+.5}&/@ArrayRules[componentMask][[1;;-2,1]];{bKld,mKld}=KarhunenLoeveDecomposition[ Transpose[points], "Centered"-> True];{Transpose[Inverse[mKld]],If[Length[#]>1,2StandardDeviation[#],{0.5,0.5,0.5}]&@Transpose@bKld}
];


Options[appendShape]={"MaskName"->"Mask"};
appendShape[objects_List,opts:OptionsPattern[]]:=Block[
{masks,shapeMeasures,keys},
masks=OptionValue["MaskName"]/.objects;
shapeMeasures=determinePrincipalComponentsLocal/@masks;
keys={"MainAxes","Extension"};
Table[FilterRules[objects[[cur]],Except[keys]]~Join~MapThread[Rule,{keys,shapeMeasures[[cur]]}],{cur,1,Length@objects,1}]
];


circumRadius=Compile[{{v,_Real,2}},With[
{a=v[[1]]-v[[4]],b=v[[2]]-v[[4]],c=v[[3]]-v[[4]]},With[
{a1=Plus@@(a^2),b1=Plus@@(b^2),c1=Plus@@(c^2),\[Alpha]1=b[[2]] c[[3]]-b[[3]] c[[2]],\[Alpha]2=b[[3]] c[[1]]-b[[1]] c[[3]],\[Alpha]3=b[[1]] c[[2]]-b[[2]] c[[1]],\[Beta]1=c[[2]] a[[3]]-c[[3]] a[[2]],\[Beta]2=c[[3]] a[[1]]-c[[1]] a[[3]],\[Beta]3=c[[1]] a[[2]]-c[[2]] a[[1]],\[Gamma]1=a[[2]] b[[3]]-a[[3]] b[[2]],\[Gamma]2=a[[3]] b[[1]]-a[[1]] b[[3]],\[Gamma]3=a[[1]] b[[2]]-a[[2]] b[[1]]},Norm[a1 {\[Alpha]1,\[Alpha]2,\[Alpha]3}+b1 {\[Beta]1,\[Beta]2,\[Beta]3}+c1 {\[Gamma]1,\[Gamma]2,\[Gamma]3}]/(2 Norm[Plus@@(a[[1;;3]] {\[Alpha]1,\[Alpha]2,\[Alpha]3})])]],CompilationTarget->"WVM",RuntimeOptions->"Speed",RuntimeAttributes->{Listable},Parallelization->True];


alphaShapes[points_,\[Alpha]_]:=Module[{alphacriteria,del=Quiet@DelaunayMesh@points,tetras,tetcoords,tetradii,selectExternalFaces},alphacriteria[tetrahedra_,radii_,rmax_]:=Pick[tetrahedra,UnitStep@Subtract[rmax,radii],1];
selectExternalFaces[facets_]:=MeshRegion[points,facets];
If[Head[del]===EmptyRegion,del,tetras=MeshCells[del,3];
tetcoords=MeshPrimitives[del,3][[All,1]];
tetradii=Quiet@circumRadius@tetcoords/.ComplexInfinity->$MaxMachineNumber;
selectExternalFaces@alphacriteria[tetras,tetradii,\[Alpha]]]]


proximityCellGraph[pts_,t_]:=Block[
{nn},
nn=NearestNeighborGraph[pts,{All,t}];
PropertyValue[nn,EdgeWeight]=(EuclideanDistance@@@EdgeList@nn);
PropertyValue[nn,VertexCoordinates]=Thread[pts->pts];
nn
];


delaunayCellGraph[pts_,t_]:=Block[
{l},
l=Flatten[Apply[List,Select[MeshCells[DelaunayMesh[pts],1],EuclideanDistance@@pts[[Part@@#]]<=t&],{1}],1];
Graph[pts,l,EdgeWeight->(EuclideanDistance[pts[[#1]],pts[[#2]]]&@@@l),VertexCoordinates->pts]
];


appendSurfaceDistance[objects_List, surf_MeshRegion] := Block[
	{surfaceCentroid, nearestSurfacePoint, dist,keys}, 
	keys={"SurfaceDistance","SurfaceNearest"};
	Table[
		FilterRules[objects[[cur]],Except[keys]]~Join~(
		surfaceCentroid = RegionCentroid[surf]; 
		nearestSurfacePoint = RegionNearest[surf, "Centroid" /. objects[[cur]]]; 
        {"SurfaceDistance" -> 
		If[EuclideanDistance[surfaceCentroid, "Centroid" /. objects[[cur]]] <= EuclideanDistance[surfaceCentroid, nearestSurfacePoint], 
           RegionDistance[surf, "Centroid" /. objects[[cur]]], -RegionDistance[surf, "Centroid" /. objects[[cur]]]
		], 
	"SurfaceNearest" -> nearestSurfacePoint}
	),{cur,1,Length@objects,1}]
	]; 


computeVertexProperties[graph_Graph]:=Block[
{inc},
N@Map[
(inc=IncidenceList[graph,#];
{VertexDegree[graph,#],LocalClusteringCoefficient[graph,#]}~Join~Through[{Min,Max,Mean,If[Length[#]>1,StandardDeviation[#],0]&}[PropertyValue[{graph,#},EdgeWeight]&/@inc]]
)&,VertexList[graph]
]
]


appendGraphFeatures[objects_List,graph_Graph,names_List]:=Block[
{vertexProps,keys},
vertexProps=computeVertexProperties[graph];
Table[FilterRules[objects[[cur]],Except[keys]]~Join~MapThread[Rule,{names,vertexProps[[cur]]}],{cur,1,Length@objects,1}]
];


SetAttributes[meshHighlight,Listable];
meshHighlight[mesh_]:=HighlightMesh[mesh,Style[2,LightBlue,Opacity[0.75]],PlotTheme->"SmoothShading"]
meshHighlight[mesh_,col_]:=HighlightMesh[mesh,Style[2,col,Opacity[0.75]],PlotTheme->"SmoothShading"]


pipelineAdjustPostProcessingGUI[inputFile_String]:=DynamicModule[
{
(*general variables*)
nucSel,nuclei,nucNotSel,outside,

(*post-processing variables*)
\[Alpha]=90,o=50,e=30,nucleiMinMaxCount={1,Infinity},cellGraph,nucleiPos,alphaShape, surface,nucleiOutlierGraphics,nucleiNotSelGraphics,nucleiSelGraphics,
nucColors,dif,coldat,graphic,
(*view option variables*)
colFun,off=10,showSurface=True,showGraph=True,showNuclei=True,showOutliers=True,
tooltipOpts={TooltipDelay->0.5,TooltipStyle->{CellFrameColor->Black,CellFrame->1}},min,max,intx,inty,intz,intxs,intys,intzs,imgSize=512,status="ok.",hist,

(*updating functions*)
updating,finishUpdating,updateSurface,updateCellGraph,updateGraphic,updateSelection
},

nuclei=nucSel={"Centroid","Count"}/.("NucleiFeatures"/.Import[inputFile]);
nucNotSel=outside={};
{intx,inty,intz}={intxs,intys,intzs}=({Min[#],Max[#]}&/@Transpose@(nuclei[[All,1]]))-{{off,-off},{off,-off},{off,-off}};

nucleiMinMaxCount={min,max}=Through[{Min,Max}[nuclei[[All,2]]]];
dif=(max-min);coldat=ColorData["Rainbow"];
colFun[v_]:=coldat[(v-min)/dif];
SetAttributes[colFun,Listable];

Manipulate[

(*image visualization*)
TabView[
	{
	"Post-processing"->Dynamic@Labeled[Show[graphic,
		Axes->True,Boxed->True,AxesLabel->{"x [voxels]","y [voxels]","z [voxels]"},ImageSize->Dynamic@{imgSize,imgSize},(*RotationAction->"Clip",*)SphericalRegion->True,PlotRange->{intx,inty,intz},BoxStyle->Directive[Thick,Black],AxesStyle->Directive[Thick,Bold,Black,16],Lighting->"Neutral",PerformanceGoal->"Speed", 
		BaseStyle->RenderingOptions->{"DepthPeelingLayers"->5}],
			Grid[{
			{
			BarLegend[{"Rainbow",{min,max}},All,LegendLayout->"Row",LegendLabel->Placed["nuclei size (voxels)",Top],LegendMarkerSize->300],
			SwatchLegend[{LightBlue,Black,Gray},{"surface","cell graph edges (only surface)","excluded cell nuclei"}]
			},
			{
			Dynamic[Style["number of selected cell nuclei: "<>ToString@(Length@nucSel-Length@outside),FontFamily->"Arial"]],
			Dynamic@hist
			}
			},Alignment->{Left,Top}],
		Bottom]
	},1,Alignment->Top
],

Grid[{
{},
{Style["nuclei selection",16,Bold]},
{Dynamic["nuclei volume\n[min="<>ToString[nucleiMinMaxCount[[1]]]<>" voxels, "<>"max="<>ToString[nucleiMinMaxCount[[2]]]<>" voxels]"],
Row[{Tooltip[IntervalSlider[Dynamic[nucleiMinMaxCount,{(nucleiMinMaxCount=#)&,(updateSelection[])&}],{min,max,1},Method->"Push",MinIntervalSize->1, ContinuousAction->False],"Minimum and maximum size of cell nuclei in number of voxels.",tooltipOpts]}," "]
},
{"",
Row[{
"min",Tooltip[InputField[Dynamic[nucleiMinMaxCount[[1]],{
(nucleiMinMaxCount[[1]]=#)&,
(updateSelection[])&
}],Number,FieldSize->5],"Minimum size of cell nuclei in number of voxels.",tooltipOpts],
"max",Tooltip[InputField[Dynamic[nucleiMinMaxCount[[2]],{
(nucleiMinMaxCount[[2]]=#)&,
(updateSelection[])&
}],Number,FieldSize->5],"Maximum size of cell nuclei in number of voxels.",tooltipOpts]
}," "]
},
{},

{Style["surface approximation",16,Bold]},
{
Dynamic["min outlier distance ["<>ToString[o]<>" voxels]"],Tooltip[Manipulator[Dynamic[o,
{(o=#)&,(updateSurface[];updateCellGraph[];(*updateGraphic[]*))&}],{0,64,1},Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False],"Minimum distance of cell nuclei outside the surface such that they are considered outliers.",tooltipOpts]},
{Dynamic["alpha ["<>ToString[\[Alpha]]<>" voxels]"],Tooltip[Manipulator[Dynamic[\[Alpha],{(\[Alpha]=#)&,(updateSurface[];updateCellGraph[];)&}],{1,256,1},Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False],"Alpha parameter value for alpha shapes surface approximation.",tooltipOpts]},

{},
{Style["cell graph generation",16,Bold]},
{Dynamic["max edge length ["<>ToString[e]<>" voxels]"],Tooltip[Manipulator[Dynamic[e,{(e=#)&,(updateCellGraph[])&}],{1,256,1},Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"},ContinuousAction->False],"Maximum distance of two cell nuclei to draw an edge in the cell graph.",tooltipOpts]},
{},
{Style["view options",16,Bold]},

{"show cell nuclei",Tooltip[Checkbox[Dynamic[showNuclei,{(showNuclei=#)&,(updateGraphic[])&}],{False,True}],"Show cell nuclei as colored spheres.",tooltipOpts]},
{"show surface",Tooltip[Checkbox[Dynamic[showSurface,{(showSurface=#)&,(updateGraphic[])&}],{False,True}],"Show approximated surface.",tooltipOpts]},
{"show cell graph (only surface)",Tooltip[Checkbox[Dynamic[showGraph,{(showGraph=#)&,(updateCellGraph[];updateGraphic[])&}],{False,True}],"Show cell graph edges (surface only).",tooltipOpts]},
{"show outliers",Tooltip[Checkbox[Dynamic[showOutliers,{(showOutliers=#)&,(updateGraphic[])&}],{False,True}],"Show outliers.",tooltipOpts]},
{"image size",Tooltip[Control[{{imgSize,512,""},16,1024,16,Appearance->{"DownArrow","Open"},AppearanceElements->{"InputField","StepLeftButton","StepRightButton"}}],"",tooltipOpts],""},
{},
{
Row[
{
Button["export settings",
Block[
{settingsFile,a},
settingsFile=SystemDialogInput["FileSave",FileNameJoin[{NotebookDirectory[],DateString[{"Year","Month","Day","_","Hour","Minute"}]<>"_PostProcessingSettings.xlsx"}]];
If[settingsFile=!=$Canceled,
	a=Association@Options@postProcessingPipeline;
	a["NucleiMinCount"]=nucleiMinMaxCount[[1]];
	a["NucleiMaxCount"]=nucleiMinMaxCount[[2]];
	a["Alpha"]=\[Alpha];
	a["OutlierDistanceThreshold"]=o;
	a["EdgeDistanceThreshold"]=e;
	a["IncludeSubfolders"]=False;
	Export[settingsFile,Prepend[Prepend[List@@@Normal@a,{}],{"Post Processing Settings","",DateString[]}]];
];
],Method->"Queued",ImageSize->{Automatic,30}],
Button["import settings",
Block[
{settingsFile,a},
settingsFile=SystemDialogInput["FileOpen",".xlsx"];
If[settingsFile=!=$Canceled,
	a=ToExpression@Association[Rule@@@(First[Import[settingsFile]][[3;;-1,1;;2]])];
	nucleiMinMaxCount[[1]]=a["NucleiMinCount"];
	nucleiMinMaxCount[[2]]=a["NucleiMaxCount"];	
	\[Alpha]=a["Alpha"];
	o=a["OutlierDistanceThreshold"];
	e=a["EdgeDistanceThreshold"];
	updateSelection[];
];
],Method->"Queued",ImageSize->{Automatic,30}]
}
],SpanFromLeft
}
},Alignment->Right
],
ControlPlacement->Left,Alignment->Top
],
Initialization:>{
updating[]:=Block[{},status="Updating...";],
finishUpdating[]:=Block[{},status="ok.";],

updateSurface[]:=Block[{},
	updating[];
	
	alphaShape=Quiet@Check[alphaShapes[First@ConnectedComponents@delaunayCellGraph[nucSel[[All,1]], o], \[Alpha]],EmptyRegion[3]];
	outside=Select[nucSel,!RegionMember[alphaShape,#[[1]]]&];
	nucleiOutlierGraphics=GraphicsComplex[outside[[All,1]],MapThread[{#,Sphere[#2,N[0.52CubeRoot[#3],2]]}&,{ConstantArray[Darker@Gray,Length@outside],outside[[All,1]],outside[[All,2]]}]];
	surface=Quiet@Check[meshHighlight[RegionBoundary@alphaShape],Graphics3D[{}]];
	
	updateGraphic[];
	finishUpdating[];
],

updateCellGraph[]:=Block[{},
	updating[];
	
	cellGraph=If[showGraph,Quiet@Check[Graphics3D[{Black,Thick,Line/@(List@@@(EdgeList@delaunayCellGraph[Complement[MeshCoordinates[surface],outside], e]))}],Graphics3D[{}]],Graphics3D[{}]];
	updateGraphic[];

],

updateSelection[]:=Block[
	{},
	updating[];
	nucSel=Select[nuclei,nucleiMinMaxCount[[1]]<=#[[2]]<=nucleiMinMaxCount[[2]] &];
	nucNotSel=Complement[nuclei,nucSel];

	hist=Histogram[{nucSel[[All,2]],nucNotSel[[All,2]]},Automatic,"Count",ImageSize->{Automatic,128},PlotRange->{{0,Automatic},Automatic},Frame->True,FrameLabel->{"nuclei volume [voxels]","number"},ChartStyle->{Green,Gray}];
	nucColors=colFun[nucSel[[All,2]]];
	nucleiSelGraphics=GraphicsComplex[nucSel[[All,1]],MapThread[{#,Sphere[#2,N[0.52CubeRoot[#3],2]]}&,{nucColors,nucSel[[All,1]],nucSel[[All,2]]}]];
	nucleiNotSelGraphics=GraphicsComplex[nucNotSel[[All,1]],MapThread[{#,Sphere[#2,N[0.52CubeRoot[#3],2]]}&,{ConstantArray[Darker@Gray,Length@nucNotSel],nucNotSel[[All,1]],nucNotSel[[All,2]]}]];
	
	updateSurface[]; updateCellGraph[]; updateGraphic[];
],

updateGraphic[]:=Block[
	{},
	updating[];
	graphic={
		If[showSurface,surface,Graphics3D[{}]],
		Graphics3D[{Specularity[White,100],If[showOutliers,nucleiNotSelGraphics,{}],If[showNuclei,nucleiSelGraphics,{}],If[showOutliers,nucleiOutlierGraphics,{}]}],
		If[showGraph, cellGraph, Graphics3D[{}]]
		};
	finishUpdating[];
],
showSurface=True;showGraph=True;tooltipOpts={TooltipDelay->0.5,TooltipStyle->{CellFrameColor->Black,CellFrame->1}};
updateSelection[];
updateSurface[];
updateCellGraph[];
updateGraphic[];
}
]


postProccessingPipelineBatch[folder_String,pattern_String,settingsFile_String]:=Block[
{runcmd,date},

date=StringReplace[FileBaseName@settingsFile,"_PostProcessingSettings"->""];

Export[
FileNameJoin[{folder,date<>"_PostProcessingPipelineBatch.m"}],
"
Quiet[<<\""<>StringReplace[cnsPackagePath,"\\" -> "\\\\"]<>"\"];
postProcessingPipelineFile[\""<>StringReplace[folder,"\\" -> "\\\\"]<>"\",\""<>pattern<>"\",\""<>StringReplace[settingsFile,"\\" -> "\\\\"]<>"\"];
Quit[];",
"Text"
];

Export[
FileNameJoin[{folder,date<>"_PostProcessingPipelineBatch.bat"}],
"\"math\" -script \""<>FileNameJoin[{folder,date<>"_PostProcessingPipelineBatch.m"}]<>"\"",
"Text"];

Export[FileNameJoin[{folder,date<>"_PostProcessingPipelineBatch.vbs"}],
"Set oShell = CreateObject (\"Wscript.Shell\") 
Dim strArgs
strArgs = \"cmd /c \"\""<>FileNameJoin[{folder,date<>"_PostProcessingPipelineBatch.bat"}]<>"\"\"\"
oShell.Run strArgs, 0, false","Text"];
runcmd = "@%windir%\\system32\\wscript.exe //Nologo " <> "\"" <> FileNameJoin[{folder,date<>"_PostProcessingPipelineBatch.vbs"}] <> "\" %*";
Run[runcmd];
];


postProcessingPipelineFile[folder_String,pattern_String,settingsFile_String]:=Block[
{datasets,date,dumpDir,exportDir,settings,kernels},

(*retrieve pipeline settings from xlsx file*)
settings=Rule@@@(First[Import[settingsFile]][[3;;-1,1;;2]]);

postProcessingPipeline[folder,pattern,settings];
date=StringReplace[FileBaseName@settingsFile,"_PostProcessingSettings"->""];

Export[FileNameJoin[{folder,date<>"_PostProcessingSettings.xlsx"}],
Prepend[Prepend[List@@@settings,{}],{"Post Processing Settings","",DateString[]}]];
];


Options[postProcessingPipeline]={"Alpha"-> 30,"OutlierDistanceThreshold"-> 20,"EdgeDistanceThreshold"->30,"NucleiMinCount"->10,"NucleiMaxCount"->10000,"IncludeSubfolders"->True};
postProcessingPipeline[folder_String,pattern_String,opts:OptionsPattern[]]:=Block[
{
\[Alpha]=OptionValue["Alpha"],outlierDist=OptionValue["OutlierDistanceThreshold"],edgeDistance=OptionValue["EdgeDistanceThreshold"],
nucleiFeatures,centroids,surf,nucleiFeaturesUpdated,c,files,time,dcg,pcg,alphaShape,delCellGraph,
nMinCount=OptionValue["NucleiMinCount"],nMaxCount=OptionValue["NucleiMaxCount"],
pcgFeatures={"PCGNeighborCount","PCGClusteringCoefficient","PCGMinNeighborDistance","PCGMaxNeighborDistance","PCGMeanNeighborDistance","PCGStandardDeviationNeighborDistance"},
dcgFeatures={"DCGNeighborCount","DCGClusteringCoefficient","DCGMinNeighborDistance","DCGMaxNeighborDistance","DCGMeanNeighborDistance","DCGStandardDeviationNeighborDistance"}
},
files=If[OptionValue["IncludeSubfolders"],FileNames[pattern,{folder},Infinity],FileNames[pattern,{folder}]];
Map[
(
nucleiFeatures=Select["NucleiFeatures"/.Import[#], nMinCount <= ("Count"/.#) <= nMaxCount&];(*import segmentation data and select nuclei based on count*)
alphaShape=alphaShapes[First@ConnectedComponents@delaunayCellGraph["Centroid"/.nucleiFeatures, outlierDist], \[Alpha]];(*compute alpha shape from nuclei centroids*)

surf=RegionBoundary@alphaShape; (*approximate surface as the region boundary of the alpha shape*)
nucleiFeaturesUpdated=Select[appendSurfaceDistance[nucleiFeatures, surf],("SurfaceDistance"/.#)>= 0 &]; (*compute surface distance and remove outliers*)

(*generate proximity cell graph and delaunay cell graph*)
pcg = proximityCellGraph["Centroid"/.nucleiFeaturesUpdated,edgeDistance];
dcg = delaunayCellGraph["Centroid"/.nucleiFeaturesUpdated,edgeDistance];

(*append graph features*)
nucleiFeaturesUpdated=appendGraphFeatures[appendGraphFeatures[appendSurfaceOrientation[appendShape[nucleiFeaturesUpdated],surf],pcg,pcgFeatures],dcg,dcgFeatures];
(*export new data to mx file*)

(*Needs["JLink`"];
ReinstallJava[JVMArguments -> "-Xmx1000000m"];
Export[FileNameJoin[{DirectoryName[#],FileBaseName[#]<>"_Final.xlsx"}],
Prepend[
Prepend[
Prepend[Values[FilterRules[#,Except["Mask"]]&/@nucleiFeaturesUpdated],Keys@FilterRules[nucleiFeaturesUpdated[[1]],Except["Mask"]]],{}],
{"Nuclei Features Final","",DateString[]}
]
];*)

Export[FileNameJoin[{DirectoryName[#],FileBaseName[#]<>"_Summary.xlsx"}],
Prepend[
Prepend[
{
{"NucleiCount",Length[nucleiFeaturesUpdated]},
{"Volume",RegionMeasure[alphaShape]},
{"SurfaceArea",Area@surf},
{"Centroid",RegionCentroid[surf]}
}~Join~nucleiFeaturesSummary[nucleiFeaturesUpdated],

{}],
{"Features Summary","",DateString[]}
]
];

Export[FileNameJoin[{DirectoryName[#],FileBaseName[#]<>"_Final.mx"}],
{
"NucleiFeatures"->nucleiFeaturesUpdated,
"GlobalFeatures"->{"ProximityCellGraph"->pcg,"DelaunayCellGraph"->dcg,"Surface"->surf,"SurfaceArea"->Area@surf,"Volume"->RegionMeasure[alphaShape],"Centroid"->RegionCentroid[surf],"MinDistanceSurface"->RegionDistance[surf,RegionCentroid[surf]]}}
];
)&,
files
];
];


nucleiFeaturesSummary[nuclei_List]:=Block[
{functions={Min,Max,Mean,StandardDeviation},prop},
Flatten[
Map[
(
prop=#;
MapThread[{#1,#2}&,{ToString[#]<>prop&/@functions,N@Through[functions[#/.nuclei]]}]
)&,
{"Count","PCGNeighborCount","DCGMeanNeighborDistance"}],1]
];


determineOriention[s_,c_,a_]:=If[
EuclideanDistance[c, RegionNearest[s,c]]!=0,
Round[90-If[#>90,180-#,#]&@(VectorAngle[ First[a],c- RegionNearest[s,c]]/Degree)],
Round[90-If[#>90,180-#,#]&@(VectorAngle[ First[a],c- RegionCentroid[s]]/Degree)]
];


appendSurfaceOrientation[objects_List,surface_MeshRegion]:=Block[
{},
Table[
FilterRules[objects[[cur]],Except[{"SurfaceOrientation"}]]~Join~{"SurfaceOrientation"->determineOriention[surface,"Centroid"/.objects[[cur]],"MainAxes"/.objects[[cur]]]},{cur,1,Length@objects,1}]
];


End[];(* End Private Context *)


EndPackage[];
