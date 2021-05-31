%% Lorenz system - Chaos | Butterfly effect
% Simulation and animation of the Lorenz system.
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

[t,states] = ode45(@(t,states) lorenz_system_dynamics(t,states,sigma,beta,rho),time_sim,[1 1 1]);

%% Animation

figure
set(gcf,'Position',[50 50 1280 720]) % 720p
% set(gcf,'Position',[50 50 854 480]) % 480p

% Create and open video writer object
v = VideoWriter('lorenz_system.avi');
v.Quality   = 100;
v.FrameRate = fR;
open(v);

% Projection planes
x_plane = -60;
y_plane = 65;
z_plane = 0;

for i=1:length(time)
    j = N*i; % Scaling iteration
    cla
    hold on ; grid on ; axis equal ; box on
    set(gca,'CameraPosition',[416.8978 -479.6666  263.5680],'xlim',[x_plane 30],'ylim',[-30 y_plane],'zlim',[z_plane 50])
    % Trajectory
    plot3(states(1:j,1),states(1:j,2),states(1:j,3),'b')
    % Projections
    plot3(x_plane*ones(j,1),states(1:j,2),states(1:j,3),'k') % yz
    plot3(states(1:j,1),y_plane*ones(j,1),states(1:j,3),'k') % xz
    plot3(states(1:j,1),states(1:j,2),z_plane*ones(j,1),'k') % xy
    xlabel('x')
    ylabel('y')
    zlabel('z')
    
    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v);

function dstate = lorenz_system_dynamics(~,states,sigma,beta,rho)

    dstate(1,1) = -sigma*states(1) + sigma*states(2); 
    dstate(2,1) = rho*states(1) - states(2) - states(1)*states(3); 
    dstate(3,1) = -beta*states(3) + states(1)*states(2);

end
