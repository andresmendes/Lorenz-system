%% Lorenz system - Comparison
% Simulation and animation of the Lorenz system for two slightly different
% initial conditions.
%
%%

clear ;  close all ; clc

%% Parameters

% System
sigma   = 10;
beta    = 8/3;
rho     = 28;

% Video
tF      = 60;                           % Final time                    [s]
fR      = 30;                           % Frame rate                    [fps]
dt      = 1/fR;                         % Time resolution               [s]
time    = linspace(0,tF,tF*fR);         % Time                          [s]

%% Simulation

N           = 4;                        % Resolution increase factor
fR_sim      = N*fR;                     % Frame rate for simulation    [fps]
time_sim    = linspace(0,tF,tF*fR_sim); % Time                         [s]

[t1,states_1] = ode45(@(t,states) lorenz_system_dynamics(t,states,sigma,beta,rho),time_sim,[1 1 1]);
[t2,states_2] = ode45(@(t,states) lorenz_system_dynamics(t,states,sigma,beta,rho),time_sim,[1.1 1 1]);

%% Animation

color = cool(6); % Colormap

% Camera position setup:
raio   = 200;                                % Radius camera position
th  = linspace(0,pi/2,length(time));        % Angle sweep camera
X   = raio*cos(th);
Y   = raio*sin(th);

% % Projection planes
% x_plane = -30;
% y_plane = 30;
% z_plane = 0;

figure
% set(gcf,'Position',[50 50 1280 720])  % YouTube: 720p
% set(gcf,'Position',[50 50 854 480])   % YouTube: 480p
% set(gcf,'Position',[50 50 640 640])     % Social
set(gcf,'Position',[50 50 1000 1000])     % Social high res

hold on ; grid on ; axis equal ; box on
% set(gca,'CameraPosition',[416.8978 -479.6666  263.5680])
set(gca,'xlim',[1.4*min(states_1(:,1)) 1.4*max(states_1(:,1))],'ylim',[1.1*min(states_1(:,2)) 1.1*max(states_1(:,2))],'zlim',[0 50])
set(gca,'xtick',[],'ytick',[],'ztick',[])
set(gca,'Color','k')

an = annotation('textbox', [0.12 0.9, 0.5, 0.1], 'string', 'Lorenz system - Comparison','FitBoxToText','on');
an.FontName     = 'Verdana';
an.FontSize     = 36;
an.LineStyle    = 'none';
an.FontWeight   = 'Bold';

% Create and open video writer object
v = VideoWriter('lorenz_system_comparison.mp4','MPEG-4');
v.Quality   = 100;
v.FrameRate = fR;
open(v);

for i=1:length(time)
    j = N*i; % Scaling iteration
    
    % Update camera position
    set(gca,'CameraPosition',[X(i)    Y(i)    100])
    
    cla
    
    % Trajectories
    plot3(states_1(1:j,1),states_1(1:j,2),states_1(1:j,3),'Color',color(6,:),'LineWidth',1.5)
    plot3(states_2(1:j,1),states_2(1:j,2),states_2(1:j,3),'Color',color(1,:),'LineWidth',1.5)
    
    % Dots
    plot3(states_1(j,1),states_1(j,2),states_1(j,3),'o','MarkerFaceColor',color(4,:),'MarkerSize',15)
    plot3(states_2(j,1),states_2(j,2),states_2(j,3),'o','MarkerFaceColor',color(3,:),'MarkerSize',15)
   
    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v);

function dstate = lorenz_system_dynamics(~,states,sigma,beta,rho)

    dstate(1,1) = -sigma*states(1) + sigma*states(2); 
    dstate(2,1) = rho*states(1) - states(2) - states(1)*states(3); 
    dstate(3,1) = -beta*states(3) + states(1)*states(2);

end
