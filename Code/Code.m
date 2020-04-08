%SP16-BCS-041 | SP16-BCS-017 | SP16-BCS-009

%Loading image
I=rgb2gray(imread('IMG.bmp')); %loading and converting to grey scale
imshow(I)

%Enhancing of self taken picture from simple camera.
%Not needed because using because the image is already processed.

% laplacianSharpening = [-1,-1,-1;-1,8,-1;-1,-1,-1];
% compositeFilter = [-1,-1,-1;-1,9,-1;-1,-1,-1]; 
% prewitHorizontal = [-1,-1,-1;0,0,0;1,1,1];
% prewitVertical = [-1 0 1;-1 0 1;-1 0 1];
% sobelHorizontal = [-1,-2,-1;0,0,0;1,2,1];
% sobelVertical = [-1 0 -1;-2 0 2;-1 0 1];
% gaussianFilter = [1 2 1; 2 4 2; 1 2 1];
% gaussianFilter = gaussianFilter.*(1/16);
% myFilter2 = [-1 -1 0; -1 0 1; 0 1 1];
% myFilter1 =zeros (5,5);
% myFilter1(1:2,3) = -1;
% myFilter1(3,3) = 2;
% myFilter6 = zeros (5,5);
% myFilter6(1:2,3) = -1;
% myFilter6(4:5,3) = -1;
% myFilter6(3,3) = 4;


%Binarizing
%to get more details.
J=I(:,:,1)>160;
imshow(J)

%Thining
%Making the picture more clear and easily processable  
K=bwmorph(~J,'thin','inf');
imshow(~K)%displaying inverse of k

%Computing minutiae. 
fun=@Filter; %% computing one-value of each 3x3 window:
Temp = nlfilter(K,[3 3],fun);%builtin neigborhood function that accepts an m-by-n matrix as input, and returns a scalar result.

% Termination: if Temp is 1 and has only 1 one-value neighbor, then the central pixel is a termination 
Termination=(Temp==1);
imshow(Termination) %showing terminating points
LabelTermination=bwlabel(Termination); %built in function to identify 8 connected neighbors
Terminationproperties=regionprops(LabelTermination,'Centroid');%measures a set of properties for each connected component, returns the centroids in a structure array.
CentroidTermination=round(cat(1,Terminationproperties(:).Centroid));%concetenating arrays rounding to nearest integer
imshow(~K)
hold on %modify same graph
plot(CentroidTermination(:,1),CentroidTermination(:,2),'ro') %plotting points in Red(r) Circles(o)

% Bifurcation: if Temp is 1 and has 3 one-value neighbor, then the central pixel is a bifurcation
Bifurication=(Temp==3);
LabelBifurication=bwlabel(Bifurication); %identifying all bifuircating points 
BifuricationProperties=regionprops(LabelBifurication,'Centroid','Image');%measures a set of properties for each connected component, returns the centroids in a structure array.
CentroidBifurication=round(cat(1,BifuricationProperties(:).Centroid));%concetenating arrays rounding to nearest integer
plot(CentroidBifurication(:,1),CentroidBifurication(:,2),'go') %plotting points in Green(g) Circles(o)

%Discarding extra Minutaes
Temp=10;%threshold to discard minutae

%1) if the distance between a termination and a biffurcation is smaller than Temp 
Distance=Distance(CentroidBifurication,CentroidTermination); %calculating distance
ExtraPoints=Distance<Temp; %finding unwanted points and placing them in a matrix
[i,j]=find(ExtraPoints);%returns row and column indices of the nonzero entries in the matrix ExtraPoints
CentroidBifurication(i,:)=[]; %removing these point from the array
CentroidTermination(j,:)=[]; %removing these point from the array

%2) if the distance between two biffurcations is smaller than Temp
Distance=Distance(CentroidBifurication);%calculating distance
ExtraPoints=Distance<Temp;%finding unwanted points and placing them in a matrix ExtraPoints
[i,j]=find(ExtraPoints);%returns row and column indices of the nonzero entries in the matrix ExtraPoints
CentroidBifurication(i,:)=[]; %removing this point from the array


% Process 3 if the distance between two terminations is smaller than Temp
Distance=Distance(CentroidTermination); %calculating distance
ExtraPoints=Distance<Temp; %finding unwanted points and placing them in a matrix ExtraPoints
[i,j]=find(ExtraPoints);%returns row and column indices of the nonzero entries in the matrix ExtraPoints
CentroidTermination(i,:)=[]; %removing this point from the array

hold off %reseting properties to their defaults
imshow(~K)
hold on %modify same graph
plot(CentroidTermination(:,1),CentroidTermination(:,2),'ro') %plotting points in Red(r) Circles(o)
plot(CentroidBifurication(:,1),CentroidBifurication(:,2),'go') %plotting points in Green(g) Circles(o)
hold off %plotting points in Green(g) Circles(o)

