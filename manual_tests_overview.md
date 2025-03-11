
<u>Overview of Manual Test Results</u>
======================================

Contents
========

* [1. Acoustic forward models](#1-acoustic-forward-models)
	* [1.1 KWaveAcousticForwardConvenienceFunction](#11-kwaveacousticforwardconveniencefunction)
	* [1.2 MinimalKWaveTest](#12-minimalkwavetest)
* [2. Digital device twins](#2-digital-device-twins)
	* [2.1 SimulationWithMSOTInvision](#21-simulationwithmsotinvision)
	* [2.2 VisualiseDevices](#22-visualisedevices)
* [3. Executables](#3-executables)
	* [3.1 MATLABAdditionalFlags](#31-matlabadditionalflags)
	* [3.2 MCXAdditionalFlags](#32-mcxadditionalflags)
* [4. Image reconstruction](#4-image-reconstruction)
	* [4.1 DelayAndSumReconstruction](#41-delayandsumreconstruction)
	* [4.2 DelayMultiplyAndSumReconstruction](#42-delaymultiplyandsumreconstruction)
	* [4.3 PointSourceReconstruction](#43-pointsourcereconstruction)
	* [4.4 SignedDelayMultiplyAndSumReconstruction](#44-signeddelaymultiplyandsumreconstruction)
	* [4.5 TimeReversalReconstruction](#45-timereversalreconstruction)
* [5. Optical forward models](#5-optical-forward-models)
	* [5.1 AbsorptionAndScatteringWithInifinitesimalSlabExperiment](#51-absorptionandscatteringwithinifinitesimalslabexperiment)
	* [5.2 AbsorptionAndScatteringWithinHomogenousMedium](#52-absorptionandscatteringwithinhomogenousmedium)
	* [5.3 CompareMCXResultsWithDiffusionTheory](#53-comparemcxresultswithdiffusiontheory)
	* [5.4 ComputeDiffuseReflectance](#54-computediffusereflectance)
* [6. Processing components](#6-processing-components)
	* [6.1 QPAIReconstruction](#61-qpaireconstruction)
	* [6.2 TestLinearUnmixingVisual](#62-testlinearunmixingvisual)
* [7. Test with experimental measurements](#7-test-with-experimental-measurements)
	* [7.1 ReproduceDISMeasurements](#71-reproducedismeasurements)
* [8. Volume creation](#8-volume-creation)
	* [8.1 SegmentationLoader](#81-segmentationloader)

<style>
img {
max-width: 100%;
height: auto;
}
h1 {
    margin-top: 42px;
}
.click-zoom-left input[type=checkbox] {
    display: none
}
.click-zoom-left img {
    /* margin: 100px; */
    transition: transform 0.25s ease;
    cursor: zoom-in
}
.click-zoom-left input[type=checkbox]:checked~img {
    transform: translate(50%, 100%) scale(2);
    cursor: zoom-out
}

.click-zoom-right input[type=checkbox] {
    display: none
}
.click-zoom-right img {
    /* margin: 100px; */
    transition: transform 0.25s ease;
    cursor: zoom-in
}
.click-zoom-right input[type=checkbox]:checked~img {
    transform: translate(-50%, -100%) scale(2);
    cursor: zoom-out
}
</style>

<b>SIMPA versions:</b><br>


<table>
    <tr>
        <td>Reference simpa version:</td>
        <td>0.1.dev1733+gb783697</td>
    </tr>
    <tr>
        <td>Your simpa version:</td>
        <td>1.0.0</td>
    </tr>
</table>

# 1. Acoustic forward models

## 1.1 KWaveAcousticForwardConvenienceFunction
- <b>Description:</b><br>This class test the convenience function for acoustic forward simulation.
It first creates a volume and runs an optical forward simulation. 
Then the function is actually tested.
Lastly the generated time series data is reconstructed to compare whether everything worked.
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/KWaveAcousticForwardConvenienceFunction\TestKWaveConvenienceFunction.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/KWaveAcousticForwardConvenienceFunction/TestKWaveConvenienceFunction.png></td>
    </tr>
</table>

## 1.2 MinimalKWaveTest
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/MinimalKWaveTest\minimal_kwave_test.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/MinimalKWaveTest/minimal_kwave_test.png></td>
    </tr>
</table>

# 2. Digital device twins

## 2.1 SimulationWithMSOTInvision
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/SimulationWithMSOTInvision\InvisionSimulationTest.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/SimulationWithMSOTInvision/InvisionSimulationTest.png></td>
    </tr>
</table>

## 2.2 VisualiseDevices
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/VisualiseDevices\device_visualisation_MSOT_Acuity.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/VisualiseDevices/device_visualisation_MSOT_Acuity.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/VisualiseDevices\device_visualisation_MSOT_Invision.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/VisualiseDevices/device_visualisation_MSOT_Invision.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/VisualiseDevices\device_visualisation_RSOM_Explorer.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/VisualiseDevices/device_visualisation_RSOM_Explorer.png></td>
    </tr>
</table>

# 3. Executables

## 3.1 MATLABAdditionalFlags
- <b>Description:</b><br>Tests if using Tags.ADDITIONAL_FLAGS to set additional flags for MATLAB works in the KWaveAdapter.
- <b>Comparison of reference and generated image:</b><br>

## 3.2 MCXAdditionalFlags
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

# 4. Image reconstruction

## 4.1 DelayAndSumReconstruction
- <b>Description:</b><br>This test runs a simulation creating an example volume of geometric shapes and reconstructs it with the Delay and
Sum algorithm. To verify that the test was successful a user has to evaluate the displayed reconstruction.
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/DelayAndSumReconstruction\reconstrution_test_DelayAndSumReconstruction.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/DelayAndSumReconstruction/reconstrution_test_DelayAndSumReconstruction.png></td>
    </tr>
</table>

## 4.2 DelayMultiplyAndSumReconstruction
- <b>Description:</b><br>This test runs a simulation creating an example volume of geometric shapes and reconstructs it with the Delay and
Sum algorithm. To verify that the test was successful a user has to evaluate the displayed reconstruction.
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/DelayMultiplyAndSumReconstruction\reconstrution_test_DelayMultiplyAndSumReconstruction.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/DelayMultiplyAndSumReconstruction/reconstrution_test_DelayMultiplyAndSumReconstruction.png></td>
    </tr>
</table>

## 4.3 PointSourceReconstruction
- <b>Description:</b><br>TODO
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/PointSourceReconstruction\PointSourceReconstruction_0.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/PointSourceReconstruction/PointSourceReconstruction_0.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/PointSourceReconstruction\PointSourceReconstruction_1.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/PointSourceReconstruction/PointSourceReconstruction_1.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/PointSourceReconstruction\PointSourceReconstruction_2.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/PointSourceReconstruction/PointSourceReconstruction_2.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/PointSourceReconstruction\PointSourceReconstruction_3.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/PointSourceReconstruction/PointSourceReconstruction_3.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/PointSourceReconstruction\PointSourceReconstruction_4.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/PointSourceReconstruction/PointSourceReconstruction_4.png></td>
    </tr>
</table>

## 4.4 SignedDelayMultiplyAndSumReconstruction
- <b>Description:</b><br>This test runs a simulation creating an example volume of geometric shapes and reconstructs it with the Delay and
Sum algorithm. To verify that the test was successful a user has to evaluate the displayed reconstruction.
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/SignedDelayMultiplyAndSumReconstruction\reconstrution_test_SignedDelayMultiplyAndSumReconstruction.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/SignedDelayMultiplyAndSumReconstruction/reconstrution_test_SignedDelayMultiplyAndSumReconstruction.png></td>
    </tr>
</table>

## 4.5 TimeReversalReconstruction
- <b>Description:</b><br>This test runs a simulation creating an example volume of geometric shapes and reconstructs it with the Delay and
Sum algorithm. To verify that the test was successful a user has to evaluate the displayed reconstruction.
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/TimeReversalReconstruction\reconstrution_test_TimeReversalReconstruction.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/TimeReversalReconstruction/reconstrution_test_TimeReversalReconstruction.png></td>
    </tr>
</table>

# 5. Optical forward models

## 5.1 AbsorptionAndScatteringWithInifinitesimalSlabExperiment
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment\infinitessimal_slab_0.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment/infinitessimal_slab_0.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment\infinitessimal_slab_1.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment/infinitessimal_slab_1.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment\infinitessimal_slab_2.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment/infinitessimal_slab_2.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment\infinitessimal_slab_3.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment/infinitessimal_slab_3.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment\infinitessimal_slab_4.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment/infinitessimal_slab_4.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment\infinitessimal_slab_5.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment/infinitessimal_slab_5.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment\infinitessimal_slab_6.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment/infinitessimal_slab_6.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment\infinitessimal_slab_7.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment/infinitessimal_slab_7.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment\infinitessimal_slab_8.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithInifinitesimalSlabExperiment/infinitessimal_slab_8.png></td>
    </tr>
</table>

## 5.2 AbsorptionAndScatteringWithinHomogenousMedium
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithinHomogenousMedium\scattering_test_0.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithinHomogenousMedium/scattering_test_0.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithinHomogenousMedium\scattering_test_2.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithinHomogenousMedium/scattering_test_2.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/AbsorptionAndScatteringWithinHomogenousMedium\scattering_test_3.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/AbsorptionAndScatteringWithinHomogenousMedium/scattering_test_3.png></td>
    </tr>
</table>

## 5.3 CompareMCXResultsWithDiffusionTheory
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/CompareMCXResultsWithDiffusionTheory\diffusion_theory_0.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/CompareMCXResultsWithDiffusionTheory/diffusion_theory_0.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/CompareMCXResultsWithDiffusionTheory\diffusion_theory_1.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/CompareMCXResultsWithDiffusionTheory/diffusion_theory_1.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/CompareMCXResultsWithDiffusionTheory\diffusion_theory_2.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/CompareMCXResultsWithDiffusionTheory/diffusion_theory_2.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/CompareMCXResultsWithDiffusionTheory\diffusion_theory_3.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/CompareMCXResultsWithDiffusionTheory/diffusion_theory_3.png></td>
    </tr>
</table>

## 5.4 ComputeDiffuseReflectance
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/ComputeDiffuseReflectance\diffusion_theory_reflectance_0.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/ComputeDiffuseReflectance/diffusion_theory_reflectance_0.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/ComputeDiffuseReflectance\diffusion_theory_reflectance_1.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/ComputeDiffuseReflectance/diffusion_theory_reflectance_1.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/ComputeDiffuseReflectance\diffusion_theory_reflectance_2.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/ComputeDiffuseReflectance/diffusion_theory_reflectance_2.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/ComputeDiffuseReflectance\diffusion_theory_reflectance_3.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/ComputeDiffuseReflectance/diffusion_theory_reflectance_3.png></td>
    </tr>
</table>

# 6. Processing components

## 6.1 QPAIReconstruction
- <b>Description:</b><br>This class applies the iterative qPAI reconstruction algorithm on a simple test volume and
- by visualizing the results - lets the user evaluate if the reconstruction is performed correctly.
This test reconstruction contains a volume creation and an optical simulation.
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/QPAIReconstruction\qpai_reconstruction_test.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/QPAIReconstruction/qpai_reconstruction_test.png></td>
    </tr>
</table>

## 6.2 TestLinearUnmixingVisual
- <b>Description:</b><br>This test is a manual test, so visual confirmation is needed.
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/TestLinearUnmixingVisual\linear_unmixing_test.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/TestLinearUnmixingVisual/linear_unmixing_test.png></td>
    </tr>
</table>

# 7. Test with experimental measurements

## 7.1 ReproduceDISMeasurements
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/ReproduceDISMeasurements\DIS_measurement_simulation_a.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/ReproduceDISMeasurements/DIS_measurement_simulation_a.png></td>
    </tr>
</table>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/ReproduceDISMeasurements\DIS_measurement_simulation_b.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/ReproduceDISMeasurements/DIS_measurement_simulation_b.png></td>
    </tr>
</table>

# 8. Volume creation

## 8.1 SegmentationLoader
- <b>Description:</b><br>None
- <b>Comparison of reference and generated image:</b><br>

<table>
    <tr>
        <td>Reference</td>
        <td>Generated</td>
    </tr>
    <tr>
        <td> <img src=.\simpa_tests\manual_tests\reference_figures/SegmentationLoader\SegmentationLoaderExample.png></td>
        <td> <img src=.\simpa_tests\manual_tests\figures/SegmentationLoader/SegmentationLoaderExample.png></td>
    </tr>
</table>
