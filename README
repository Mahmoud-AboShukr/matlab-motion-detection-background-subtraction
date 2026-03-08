# Motion Detection and Background Subtraction in MATLAB

This repository presents a MATLAB project on **classical motion detection in video sequences**, using a grayscale car sequence to compare frame differencing, temporal derivative filters, average background modeling, exponential background updating, and several mask refinement strategies.

The project is structured as a practical study of how moving-object detection can be performed from image sequences using simple yet effective image processing techniques.

## Project Overview

The workflow explores several core approaches to motion detection:

- direct visualization of a grayscale image sequence,
- frame-to-frame absolute differencing,
- Gaussian smoothing before differencing,
- median filtering of binary motion masks,
- temporal derivative operators:
  - temporal Prewitt
  - temporal Sobel
- static background modeling using the average of all frames,
- adaptive background modeling with exponential updating,
- post-processing of detection masks using:
  - median filtering
  - Gaussian smoothing
  - morphological opening and closing
  - erosion and dilation chains,
- combined pre-smoothing and morphological cleanup.

## Main Features

- MATLAB implementation of motion detection on image sequences
- Binary foreground extraction from grayscale `.pgm` frames
- Comparison of multiple motion detection strategies
- Average background estimation from the full sequence
- Adaptive background estimation using exponential moving average
- Foreground mask refinement with:
  - thresholding
  - median filtering
  - Gaussian smoothing
  - morphology (`imopen`, `imclose`, erosion, dilation)
- Frame-by-frame visualization of motion masks
- Practical study of threshold sensitivity, noise, and illumination variation

## Repository Structure

```text
matlab-motion-detection-background-subtraction/
├── motion_detection_background_subtraction.m
├── README.md
├── MATLAB_REQUIREMENTS.md
└── car/
    ├── 0000.pgm
    ├── 0001.pgm
    └── ...
```

## Methodology

### 1. Sequence Visualization
The script first loads the `car` image sequence and displays the frames in order to inspect motion visually.

### 2. Frame Difference
A simple absolute difference between consecutive frames is used to detect moving regions.  
A fixed threshold converts the grayscale difference image into a binary motion mask.

### 3. Smoothing Before Difference
Gaussian smoothing is applied to consecutive frames before differencing in order to reduce high-frequency noise and improve mask stability.

### 4. Median Filtering of the Motion Mask
Median filtering is used to suppress isolated false positives while preserving object boundaries better than simple averaging.

### 5. Temporal Derivative Filters
The project includes temporal versions of:
- **Prewitt**
- **Sobel**

These compare non-adjacent frames to emphasize temporal change more robustly than direct pairwise differencing.

### 6. Average Background Model
A static background is estimated as the mean of all frames in the sequence, then subtracted from each frame to highlight moving objects.

### 7. Exponential Background Update
An adaptive background model is updated recursively using exponential averaging.  
This allows the background estimate to evolve over time instead of remaining fixed.

### 8. Post-Processing of Detection Masks
Several refinement strategies are tested after foreground detection:
- median filtering,
- Gaussian smoothing followed by re-thresholding,
- morphological opening and closing,
- explicit erosion/dilation chains,
- combined Gaussian + morphology pipeline.

## Input Data

The script expects a folder named:

- `car/`

containing grayscale image frames named like:

- `0000.pgm`
- `0001.pgm`
- `0002.pgm`
- ...

The code assumes a sequence length of up to 200 frames in several sections.

## Requirements

See `MATLAB_REQUIREMENTS.md` for the full dependency list.

At minimum, this project expects:
- MATLAB
- Image Processing Toolbox

## How to Run

1. Place the `car/` folder in the project directory.
2. Open MATLAB.
3. Open the main script:
   ```matlab
   motion_detection_background_subtraction.m
   ```
4. Run the script section by section or as a whole.

The script will display:
- raw sequence frames,
- difference images,
- thresholded motion masks,
- background subtraction results,
- refined binary foreground masks for different methods.

## Outputs

Typical outputs include:
- grayscale frame playback,
- motion masks from frame differencing,
- temporal Prewitt and Sobel detections,
- average-background subtraction masks,
- adaptive-background subtraction masks,
- post-processed foreground masks using smoothing and morphology.

## Notes

- This project is best presented as a **classical motion detection and background subtraction project in MATLAB**.
- For GitHub, it is better to rename the script from a TP-style name to something descriptive and portfolio-ready.
- The current script contains several independent experiments; for a cleaner public version, you may later split it into sections such as:
  - `frame_difference`
  - `background_models`
  - `mask_postprocessing`

## Possible Improvements

- add quantitative foreground mask evaluation if ground truth is available,
- compare against running median or mixture-of-Gaussians background models,
- add connected-component analysis and bounding boxes,
- export results as a video,
- refactor each method into reusable MATLAB functions.

## License

This repository is shared as part of a personal portfolio in video analysis, motion detection, and classical computer vision.
