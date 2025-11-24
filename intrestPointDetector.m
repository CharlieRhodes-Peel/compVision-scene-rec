%Blob detection
function detectInterestPoints(image)
    
    %Normalise to values between 0 and 1
    image = double(image) / 255; 
    figure('Name', 'Normal Image'), imshow(image, []);

    equalisedI = histeq(image);

    figure('Name', 'After Histogram eq'), imshow(equalisedI, [])

    gaussianFilter = imgaussfilt(equalisedI);
    figure('Name', 'Gaussian Filtered Image'), imshow(gaussianFilter, []);
    
    dog = equalisedI - gaussianFilter;

    figure('Name', 'DoG'), imshow(dog, []);

    binaryImage = imbinarize(dog, 0.1);

    figure('Name', 'Thresholded'), imshow(binaryImage, []);

    plotPoints(binaryImage, image);
end

function plotPoints(filteredImage, orignalI)
    [x,y] = size(filteredImage);

    imshow(orignalI)
    for i = 1:x
        for j = 1:y
            if filteredImage(i, j) > 0
                hold on;
                plot(j, i, 'r*', 'MarkerSize', 5); % Plot interest points
            end
        end
    end
end

%Testing
file = fullfile("testing", "0.jpg");
image = imread(file);

detectInterestPoints(image);