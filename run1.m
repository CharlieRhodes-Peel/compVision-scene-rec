%Loads all training data into form [{allImagesOfClass, ClassName}]
function trainingWithLabels = LoadAndProcessTraining(trainingDir)
    % Gets a list of all the directories
    classDirectories = dir(trainingDir);

    % Removes non-class directory entries
    classDirectories = classDirectories(~ismember({classDirectories.name}, {'.', '..', '.DS_Store'}));

    %Gets class names
    classNames = {classDirectories.name};

    %Everything in matlab is indexed from 1 (sorry)
    imagesWithLabels = [];

    for i = 1:length(classNames)
        currentClassName = classNames{i};

        %Gets the current class path (e.g "training/bedroom") need to use
        %fullfile because it handles operating system differences
        currentPath = fullfile(trainingDir, currentClassName);
        imgFiles = dir(currentPath);

        %Debug
        fprintf("Now doing %s\n", currentClassName)
        
        %Removes non-image image entries
        imgFiles = imgFiles(~ismember({imgFiles.name}, {'.', '..', '.DS_Store'}));

        %Debug
        firstOfTheClass = true;

        %List of all images in this class
        classImages = [];

        %Loops through every image in class
        for j = 1:length(imgFiles)
            %Gets each image
            imagePath = fullfile(currentPath, imgFiles(j).name);
            currentImage = readImage(imagePath);

            %Gets the small image
            smallImage = extractCroppedSizedImage(currentImage, 16);

            %Puts images with the rest of this class
            classImages = [classImages; smallImage];

            %Debug
            if(firstOfTheClass)
                imshow(smallImage);
                firstOfTheClass = false;
            end
        end

        imagesWithLabels = [imagesWithLabels; {classImages, currentClassName}];
    end
    trainingWithLabels = imagesWithLabels;
end

function output = readImage(imagePath)
    image = imread(imagePath);
    output = double(image) / 255;
end

%Gets a 16x16 sqaure from the center of the image
function feature = extractCroppedSizedImage(image, imageSize)
    %Gets the smallest of the two aspect ratios
    [height, width] = size(image);
    cropSize = min(height,width);

    heightCropOffset = floor((height - cropSize) / 2);
    widthCropOffset = floor((width - cropSize) / 2);

    %Crops in the center of the image
    squareImage = imcrop(image, [widthCropOffset, heightCropOffset, cropSize, cropSize]);

    feature = imresize(squareImage, [imageSize,imageSize]);
end

% Testing
trainingDirectory = 'training';

LoadAndProcessTraining(trainingDirectory)