function [ boundedPicture ] = QMUL_partC11( vid, frame)
    %
    %QMUL_part11    Writes object details to file
    % Calculates displacement details and writes to file
    % called 'question11.txt' along with extras
    %
    % boundedPicture = QMUL_partB11(vidFrames, frame)
    %
    % INPUT
    % vidFrames - Frames of the video
    % frame - Frame to use
    %
    % OUTPUT
    % boundedPicture - The picture of frame
    %
    % SOURCES NEEDED
    % QMUL_partA5.m , QMUL_thresholding.m and QMUL_FloodFill.m

  %Create Text file
  output = fopen('question11.txt','w');
  fprintf(output,'Frame : %d\n', frame);
  
  colourList(1,:) = [255 255 255]; %White
  colourList(2,:) = [0 0 0]; %Black
  colourList(3,:) = [255 0 0]; %Red
  colourList(4,:) = [0 255 0]; %Green
  colourList(5,:) = [0 0 255]; %Blue
  colourList(6,:) = [255 140 0]; %Orange
  colourList(7,:) = [160 32 240]; %Purple
  colourList(8,:) = [255 105 180]; %Pink
  colourList(9,:) = [255 255 0]; %Yellow
  colourList(10,:) = [0 255 255]; %Cyan
  colourList(11,:) = [139 69 19]; %Brown
  colourList(12,:) = [148 0 211]; %Dark Violet
  colourList(13,:) = [190 190 190]; %Gray
  
  follow = zeros(1,1); %To know index of object in next frame
  xdis = zeros(1); %movement along x
  ydis = zeros(1); %movement along y
  dis = zeros(1); %actual movement calculated using xdis and ydis
  xydif = zeros(1,2); %keep linked differences
  
  boundedPicture = vid(:,:,:,frame);
  depth = 3;
  
  vidFrame = vid(:,:,:,frame);
  nextFrame = vid(:,:,:,frame+1);
  background = QMUL_partA5(vid, 100, 'average');
  
  tic;
  
  [details centre avg] = QMUL_partC10i(vidFrame, background);
  [details2 centre2 avg] = QMUL_partC10i(nextFrame, background);
  
  for i=1:length(centre)
      fprintf(output,'Object : %d\n', i);
      follow(i,1) = i;
      
      %Find object link
      for j=1:length(centre2)
          xdis(j) = centre(i,1) - centre2(j,2);
          ydis(j) = centre(i,2) - centre2(j,2);
          dis(j) = sqrt((xdis(j)^2) + (ydis(j)^2));
      end
      
      [minDis index] = min(dis);
      follow(i,2) = index; %follow object
      xydif(i,:) = [xdis(index) ydis(index)];
      
      %write details to file
      fprintf(output,'\tX Displacement : %f\n', xdis(index));
      fprintf(output,'\tY Displacement : %f\n', ydis(index));
      fprintf(output,'\tTotal Displacement : %f\n', minDis);
      if xdis(index) < 0 && ydis(index) < 0
          fprintf(output,'\tDirection :  SW\n');
      end
      if xdis(index) < 0 && ydis(index) == 0
          fprintf(output,'\tDirection :  W\n');
      end
      if xdis(index) < 0 && ydis(index) > 0
          fprintf(output,'\tDirection :  NW\n');
      end
      if xdis(index) == 0 && ydis(index) > 0
          fprintf(output,'\tDirection :  N\n');
      end
      if xdis(index) > 0 && ydis(index) > 0
          fprintf(output,'\tDirection :  NE\n');
      end
      if xdis(index) > 0 && ydis(index) == 0
          fprintf(output,'\tDirection :  E\n');
      end
      if xdis(index) > 0 && ydis(index) < 0
          fprintf(output,'\tDirection :  SE\n');
      end
      if xdis(index) == 0 && ydis(index) < 0
          fprintf(output,'\tDirection :  S\n');
      end
      
      area = details(i,3) * details(i,4);
      perimeter = 2* (details(i,3) * details(i,4));
      thicknessRatio = area/perimeter;
      
      fprintf(output,'\tArea : %d',area);
      fprintf(output,'\tPerimeter : %d',perimeter);
      fprintf(output,'\tThickness Ratio : %d', thicknessRatio);
      
  end
  
  imshow(boundedPicture);
  toc
end


