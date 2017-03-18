%**************************************************************************
% Test Cases:
%                 - Free falling cube under gravity
%                 - Stationary tank
%                 - Crashed Cube
%**************************************************************************
function sucess = TestCases(nameExperiment, n, path)

close all;
set(groot,'defaultLineLineWidth',2)

% Check path (optional arument)
if nargin < 2
   path = '';
end

%addpath(genpath('../build/Results/'))

    % Number of files to read
    dirName = dir([nameExperiment, '\*.txt']) %list all directory with.txt
    nstep = length(dir([nameExperiment, '\*.txt']))-1 %[-]

    % Import data at t=0
    filename=strcat(nameExperiment,'/',dirName(1).name)
    InitExperiment = importdata(filename);
    
    % time step
    Str = char(InitExperiment.textdata(9));Key = 'Step Time (k) :';
    Index = strfind(Str, Key);
    timeStep = sscanf(Str(Index(1) + length(Key):end), '%g', 1); %[s]
    
    % write step
    Str = char(InitExperiment.textdata(10));Key = 'Write interval : ';
    Index = strfind(Str, Key);
    timeWrite = sscanf(Str(Index(1) + length(Key):end), '%g', 1); %[s]
    
    % Simulation time
    Str = char(InitExperiment.textdata(11));Key = 'Simulation Time (T) : ';
    Index = strfind(Str, Key);
    timeSimu = sscanf(Str(Index(1) + length(Key):end), '%g', 1); %[s]

    
    for i=1 : nstep 
        
        % Open File nbr i
        disp(dirName(i+1).name)
        filename=strcat(nameExperiment,'/',dirName(i+1).name);
        Experiment = importdata(filename); % Import Data
        
        % Compute time of the experiment
        time(i) = (i-1)*timeWrite; % Time 
        
        % Get time consumption
        Str = char(Experiment.textdata(6)); Key = 'CPU Time : ';
        Index = strfind(Str, Key);
        CPU_Time(i) = sscanf(Str(Index(1) + length(Key):end), '%g', 1);
        
        % Get memory consumption
        Str1 = char(Experiment.textdata(7)); Key1 = 'Memory Usage :';
        Str2 = char(Experiment.textdata(8)); Key2 = 'Peak :';
        Index1 = strfind(Str1, Key1); Index2 = strfind(Str2, Key2);
        Memory(i)      = sscanf(Str1(Index1(1) + length(Key1):end), '%g', 1);
        Memory_Peak(i) = sscanf(Str2(Index2(1) + length(Key2):end), '%g', 1);
    
    end
    
    
    % Put file in a new directory
%     if(input('MoveFile to an other folder (1 for yes, 0 for no): ' ))
%     mkdir ../build/Results/FreeFallingCube
%     movefile ../build/Results/FreeFallingCube_*.txt ../build/Results/FreeFallingCube
%     movefile ../build/Results/FreeFallingCube_*.vtk ../build/Results/FreeFallingCube
%     end



switch n


%% Free Falling cube
%  ************************************************************************
case 1

    
    % Parameters
    g = 9.81;
    z0_center = 100; %[m]
    
    for i=1 : nstep 
        
        % Open File nbr i
        disp(dirName(i+1).name)
        filename=strcat(nameExperiment,'/',dirName(i+1).name);
        Experiment = importdata(filename); % Import Data
        
        % Compute the error to analytical solution 
        Analytic(i) = mean(InitExperiment.data(:,3)) - g*(time(i)^2)/2; % MRUA
        error(i) = mean(abs(((Experiment.data(:,3)-Analytic(i))./Analytic(i))))*100; % error [%]
        %XY_move(i) = sqrt(mean(  (InitExperiment.data(:,1) - Experiment.data(:,1)).^2  ...
                             % +  (InitExperiment.data(:,2) - Experiment.data(:,2)).^2   ));
        MeanZ_experiment(i) = mean(abs(Experiment.data(:,3)));
     
    end

    
    % Plot
    figure(1)
    hold on
    plot(time, Analytic, time, MeanZ_experiment);
    % polyfit...
        %axis([0 0 0 0])
        title('')
        xlabel('Time [s]')
        ylabel('Z')
        text =  strcat('Simulation (time step = ', num2str(timeStep), ')');
        legend('Analytic', text)
        grid
        %print('FreeFallingCube_error', '-depsc')
    hold off  
    

    % Plot
    figure(2)
    hold on
    plot(time, error, '*');
    % polyfit...
        %axis([0 0 0 0])
        title('')
        xlabel('Time [s]')
        ylabel('Error in %')
        legend('')
        grid
        %print('FreeFallingCube_error', '-depsc')
    hold off  
    
%     figure(3)
%     hold on
%     plot(time, XY_move, '*');
%         %axis([0 0 0 0])
%         title('')
%         xlabel('Time [s]')
%         ylabel('Error in %')
%         legend('')
%         grid
%         %print(strcat(path,'FreeFallingCube_XY_move'), '-depsc')
%     hold off  
    
    figure(4)
    hold on
    plot(time, Memory*1.25e-7, time, Memory_Peak*1.25e-7);
        %axis([0 1 2 3])
        title('Memory Consumption')
        xlabel('Time [s]')
        ylabel('Memory Consumption [MB]')
        legend('RSS Memory', 'RSS Memory Peak')
        grid
        %print(strcat(path,'FreeFallingCube_Memory'), '-depsc')
    hold off 
    
    figure(5)
    hold on
    plot(time, CPU_Time);
        %axis([0 1 2 3])
        title('Time Consumption')
        xlabel('Time Experiment[s]')
        ylabel('CPU Time [s]')
        grid
        %print(strcat(path,'FreeFallingCube_Memory'), '-depsc')
    hold off 

% Save data
DATA.name = dirName(1).name;
DATA.path = nameExperiment;
DATA.nbrFiles = nstep;
DATA.timeStep = timeStep;
DATA.timeWrite = timeWrite;
DATA.timeSimu = timeSimu;
DATA.CPUtime = CPU_Time;
DATA.memory = Memory;
DATA.memoryPeak = Memory_Peak;
DATA.time = time;
DATA.analytic = Analytic;
DATA.meanZexperiment = MeanZ_experiment;
DATA.error = error;

save(strcat(nameExperiment,strcat('/',dirName(1).name(1:end-13))), 'DATA')


%% Free Falling cube Random
%  ************************************************************************
case 2

    % Parameters
    g = 9.81;
    z0_center = 100; %[m]

    % Cube:


  



    
    
% Save data
DATA.name = dirName(1).name;
DATA.path = nameExperiment;
DATA.nbrFiles = nstep;
DATA.timeStep = timeStep;
DATA.timeWrite = timeWrite;
DATA.timeSimu = timeSimu;
DATA.CPUtime = CPU_Time;
DATA.memory = Memory;
DATA.memoryPeak = Memory_Peak;
DATA.time = time;

save(strcat(nameExperiment,strcat('/',dirName(1).name(1:end-13))), 'DATA')



%% Stationary tank
%  ************************************************************************
case 3

    % Parameters

    % Cube

    % Import data


    % Plot
    figure(20)
    hold on
    plot();
        %axis([0 0 0 0])
        title('')
        xlabel('')
        ylabel('')
        legend('')
        grid
        %print(strcat(path,'StationaryTank'), '-depsc')
    hold off  

% Save data
DATA.name = dirName(1).name;
DATA.path = nameExperiment;
DATA.nbrFiles = nstep;
DATA.timeStep = timeStep;
DATA.timeWrite = timeWrite;
DATA.timeSimu = timeSimu;
DATA.CPUtime = CPU_Time;
DATA.memory = Memory;
DATA.memoryPeak = Memory_Peak;
DATA.time = time;

save(strcat(nameExperiment,strcat('/',dirName(1).name(1:end-13))), 'DATA')

    
%% Not Valid Experiment
%  ************************************************************************
otherwise
        disp('Not Valid Experiment')
end

sucess = 0;
end




