% Make sure your images are inside a folder named "car"
% Example: car/0000.pgm

for i = 0:50
    filename = sprintf('car/%04d.pgm', i);
    I = double(imread(filename));

    imshow(mat2gray(I));
    title(filename);
    pause(0.05);
end

% Simple Frame Difference.
I0 = double(imread('car/0000.pgm'));

for i = 1:50
    I1 = double(imread(sprintf('car/%04d.pgm', i)));
    
    % Computes per-pixel absolute difference.
    D = abs(I1 - I0);   

    % Turns grayscale difference into black/white:
    % White = motion
    % Black = background
    BW = D > 30;        % Thresholding

    subplot(1,2,1); imshow(mat2gray(D)); title('Difference');
    subplot(1,2,2); imshow(BW); title('Thresholded');

    I0 = I1;            % Move to next iteration
    pause(0.05);
end

% Choosing a good threshold is hard because:

% 1- noise.
% 2- illumination changes
% 3- shadows
% 4- small object motion

% Gaussian Smoothing Before Difference

% Noise causes false positives in difference images
% Smoothing reduces high-frequency (random) variation

I0 = double(imread('car/0000.pgm'));

for i = 1:50
    I1 = double(imread(sprintf('car/%04d.pgm', i)));
    % Reduces high-frequency noise
    % Smoothes contour
    I0s = imgaussfilt(I0, 1);
    I1s = imgaussfilt(I1, 1);

    D = abs(I1s - I0s);
    % Lower threshold (20 instead of 30) because noise reduced.
    BW = D > 20;

    imshow(BW); title('Smoothed difference');
    I0 = I1;
    pause(0.05);
end

% Median Filtering on Detection Mask

% Removes isolated noise pixels ("salt-and-pepper noise")
% Preserves edges better than averaging filters

I0 = double(imread('car/0000.pgm'));

for i = 1:199
    I1 = double(imread(sprintf('car/%04d.pgm', i)));

    % Gaussian smoothing
    I0s = imgaussfilt(I0, 1);
    I1s = imgaussfilt(I1, 1);

    % Difference + threshold (same as chunk 2)
    D = abs(I1s - I0s);
    BW = D > 20;

    % NOW apply median filter
    BW_clean = medfilt2(BW, [5 5]);

    imshow(BW_clean);
    title('Smoothed + Median Filter');
    pause(0.05);

    I0 = I1;
end

% Temporal Prewitt Filter

% Instead of comparing consecutive frames, 
% the temporal Prewitt operator compares frame (i+1) and (i–1)

I_prev = double(imread('car/0000.pgm'));
I_curr = double(imread('car/0001.pgm'));

for i = 2:50
    I_next = double(imread(sprintf('car/%04d.pgm', i)));

    DP = I_next - I_prev;       % Prewitt temporal derivative
    BW = abs(DP) > 20;

    imshow(BW); title('Temporal Prewitt');
    pause(0.05);

    I_prev = I_curr;
    I_curr = I_next;
end

% Temporal Sobel Filter
% Temporal Sobel is similar but more weighted
% This produces a stronger gradient response than Prewitt.

DS = (I_next - I_prev) / 2;
BW = abs(DS) > 20;

I_prev = double(imread('car/0000.pgm'));
I_curr = double(imread('car/0001.pgm'));

for i = 2:50
    I_next = double(imread(sprintf('car/%04d.pgm', i)));

    DS = (I_next - I_prev) / 2;
    BW = abs(DS) > 20;

    imshow(BW); title('Temporal Sobel Filter');
    pause(0.05);

    I_prev = I_curr;
    I_curr = I_next;
end

% Average Background Model

% Background = Mean of all 200 frames

sumImg = 0;

for i = 0:199
    Img = double(imread(sprintf('car/%04d.pgm', i)));
    sumImg = sumImg + Img;
end

B = sumImg / 200;
imshow(mat2gray(B)); title('Average background');

% Background Subtraction Using the Average

% Compute background inside this script
sumImg = 0;

for i = 0:199
    Img = double(imread(sprintf('car/%04d.pgm', i)));
    sumImg = sumImg + Img;
end

B = sumImg / 200;   % Average background


% Use background for motion detection
for i = 0:199
    I = double(imread(sprintf('car/%04d.pgm', i)));

    D = abs(I - B);
    BW = D > 25;    % Threshold

    imshow(BW);
    title(sprintf('Background subtraction — Frame %04d', i));
    pause(0.05);
end

% Exponential Background Update

k = 0.89;  % slow update
b = double(imread('car/0000.pgm'));

for i = 1:199
    I = double(imread(sprintf('car/%04d.pgm', i)));

    b = k*b + (1-k)*I;

    BW = abs(I - b) > 25;

    imshow(BW);
    title('Exponential background (k=0.95)');
    pause(0.05);
end

% Exponential Background Update + smoothing AFTER detection
% Median Filtering AFTER Detection ===

k = 0.89;  % update speed
b = double(imread('car/0000.pgm'));

for i = 1:199
    
    % Read next frame
    I = double(imread(sprintf('car/%04d.pgm', i)));

    % Update background estimate
    b = k*b + (1-k)*I;

    % Background subtraction and detection
    BW = abs(I - b) > 25;

    % ---- MEDIAN FILTER SMOOTHING ----
    BW_smooth = medfilt2(BW, [5 5]);

    imshow(BW_smooth);
    title(sprintf('Median Filtered Detection — Frame %04d', i));
    pause(0.05);

end

% Gaussian Filter AFTER Detection ===

k = 0.89;
b = double(imread('car/0000.pgm'));

for i = 1:199
    
    I = double(imread(sprintf('car/%04d.pgm', i)));

    b = k*b + (1-k)*I;

    BW = abs(I - b) > 25;

    % ---- GAUSSIAN FILTER SMOOTHING ----
    BW_gauss = imgaussfilt(double(BW), 1);  % smooth mask
    BW_smooth = BW_gauss > 0.5;            % re-binarize

    imshow(BW_smooth);
    title(sprintf('Gaussian Filtered Detection — Frame %04d', i));
    pause(0.05);

end

% === OPTION 4: Combined Smoothing (Gaussian + Median + Morphology) ===

k = 0.89;
b = double(imread('car/0000.pgm'));

se = strel('disk', 3);

for i = 1:199
    
    I = double(imread(sprintf('car/%04d.pgm', i)));

    b = k*b + (1-k)*I;

    BW = abs(I - b) > 25;

    % ---- STEP 1: Gaussian smoothing of mask ----
    BW = imgaussfilt(double(BW), 1) > 0.5;

    % ---- STEP 2: Median smoothing ----
    BW = medfilt2(BW, [5 5]);

    % ---- STEP 3: Morphological smoothing ----
    BW = imopen(BW, se);
    BW = imclose(BW, se);

    imshow(BW);
    title(sprintf('Combined Smoothing — Frame %04d', i));
    pause(0.05);

end

% === Exponential Background Update + Erode/Dilate Smoothing ===

k = 0.89;    % background update speed
b = double(imread('car/0000.pgm'));

% Structuring element (small disk)
se = strel('disk', 2);  % radius 2 is ideal

for i = 1:199
    
    % Read current frame
    I = double(imread(sprintf('car/%04d.pgm', i)));

    % Update background
    b = k*b + (1-k)*I;

    % Motion detection
    BW = abs(I - b) > 25;

    % ========= ERODE + DILATE (Opening) =========
    % Remove tiny white speckles
    BW_open = imerode(BW, se);
    BW_open = imdilate(BW_open, se);

    % ========= DILATE + ERODE (Closing) =========
    % Restore holes inside the moving object
    BW_close = imdilate(BW_open, se);
    BW_close = imerode(BW_close, se);
    % ============================================

    imshow(BW_close);
    title(sprintf('Erode + Dilate Smoothing — Frame %04d', i));
    pause(0.05);

end


% === Exponential Background + Gaussian Smoothing + Morphology ===

k = 0.89;                             % background update coefficient
b = double(imread('car/0000.pgm'));   % initial background frame

% Structuring element for morphological smoothing
se = strel('disk', 2);   % radius 2 = gentle smoothing

for i = 1:199

    % ---- Load frame ----
    I = double(imread(sprintf('car/%04d.pgm', i)));

    % ---- PRE-SMOOTHING (Gaussian filter on grayscale image) ----
    I_smooth = imgaussfilt(I, 1);     % sigma = 1 (works best)
    b_smooth = imgaussfilt(b, 1);     % smooth the background too

    % ---- Background update (exponential averaging) ----
    b = k*b + (1-k)*I;

    % ---- Motion detection (using smoothed images) ----
    BW = abs(I_smooth - b_smooth) > 25;

    % ---- POST-SMOOTHING (Morphology: opening then closing) ----
    % Remove tiny noise points
    BW_open = imerode(BW, se);
    BW_open = imdilate(BW_open, se);

    % Close small holes and reconnect edges
    BW_clean = imdilate(BW_open, se);
    BW_clean = imerode(BW_clean, se);

    % ---- Display ----
    imshow(BW_clean);
    title(sprintf('Gaussian + Morphology — Frame %04d', i));
    pause(0.05);

end
