function plotter(p)
close all

f = figure(1);

set(f,'WindowButtonMotionFcn','','WindowButtonDownFcn',@ClickDown,'WindowButtonUpFcn',@ClickUp,'KeyPressFc',@KeyPress);

%%% Init figdata variables %%%

figData.xtarget = [0];
figData.ytarget = [-2];
figData.Fx = [];
figData.Fy = [];
figData.xend = [0];
figData.yend = [-2];
figData.fig = f;
figData.tarControl = true;

%%% 1st subplot -- animation %%%
figData.simArea = subplot(1,1,1);
axis equal
hold on

%Create link1 object
%width1 = p.l1*0.05;
%xdat1 = 0.5*width1*[-1 1 1 -1];
%ydat1 = p.l1*[0 0 1 1];
%link1 = patch(xdat1,ydat1, [0 0 0 0],'r');

%Create link2 object
%width2 = p.l2*0.05;
%xdat2 = 0.5*width2*[-1 1 1 -1];
%ydat2 = p.l2*[0 0 1 1];
%link2 = patch(xdat2,ydat2,[0 0 0 0],'b');
%axis([-3.5 3.5 -3.6 3.6]);

%h1 = plot(0,0,'.k','MarkerSize',40); %First link anchor
%h2 = plot(0,0,'.k','MarkerSize',40); %link1-link2 hinge

width1 = p.l1*0.05;
xdat1 = 0.5*width1*[-1 1 1 -1];
ydat1 = p.l1*[0 0 1 1];
link1 = patch(xdat1,ydat1, [0 0 0 0],'r');

%Create link2 object
width2 = p.l2*0.05;
xdat2 = 0.5*width2*[-1 1 1 -1];
ydat2 = p.l2*[0 0 1 1];
link2 = patch(xdat2,ydat2,[0 0 0 0],'b');
%axis([-3.5 3.5 -3.6 3.6]);
axis([-1 1 -1 1]);


h1 = plot(0,0,'.k','MarkerSize',40); %First link anchor
h2 = plot(0,0,'.k','MarkerSize',40); %link1-link2 hinge


%Timer label
timer = text(-3.2,-3.2,'0.00','FontSize',28);

%Torque values on screen
tmeter1 = text(0.6,-3.2,'0.00','FontSize',22,'Color', 'r');
tmeter2 = text(2.2,-3.2,'0.00','FontSize',22,'Color', 'b');

%Target Point
targetPt = plot(p.xtarget,p.ytarget,'xr','MarkerSize',30);

hold off

%Bigger window for better viewing
set(f, 'units', 'inches', 'position', [5 5 10 9])
set(f,'Color',[1,1,1]);

% Turn the axis off
ax = get(f,'Children');
set(ax,'Visible','off');



%Animation loop -- Includes symplectic integration
z1 = p.init;
told = 0;

set(f,'UserData',figData);

resp_x_x = zeros(1,175);
resp_x_y = zeros(1,175);
resp_x_yc = zeros(1,175);
resp_y_y = zeros(1,175);
resp_y_yc = zeros(1,175);

increment = 0;

tic %Start the clock
while (ishandle(f))
    figData = get(f,'UserData');
    %%% Integration %%%
    tnew = toc;
    dt = tnew - told;
    
    %Old velocity and position
    xold = [z1(1),z1(3)];
    vold = [z1(2),z1(4)];
    
    %Call RHS given old state
    [zdot1, T1, T2] = fullDyn(tnew,z1,p);
    vinter1 = [zdot1(1),zdot1(3)];
    ainter = [zdot1(2),zdot1(4)];
    
    vinter2 = vold + ainter*dt; %Update velocity based on old RHS call
    
    %Update position.
    xnew = xold + vinter2*dt;
    vnew = (xnew-xold)/dt;
    
    z2 = [xnew(1) vnew(1) xnew(2) vnew(2)];

    z1 = z2;
    told = tnew;
    %%%%%%%%%%%%%%%%%%%%
    
    %If there are new mouse click locations, then set those as the new
    %target.
    if ~isempty(figData.xtarget)
    p.xtarget = figData.xtarget;
    end
    
    if ~isempty(figData.ytarget)
    p.ytarget = figData.ytarget;
    end
    set(targetPt,'xData',p.xtarget); %Change the target point graphically.
    set(targetPt,'yData',p.ytarget);
    
    %When you hit a key, it changes to force mode, where the mouse will
    %pull things.
    ra_e = ForwardKinematics(p.l1,p.l2,z1(1),z1(3));
    figData.xend = ra_e(1);
    figData.yend = ra_e(2);
    set(f,'UserData',figData);
    
    if ~isempty(figData.Fx)
    p.Fx = figData.Fx;
    end
    if ~isempty(figData.Fy)
    p.Fy = figData.Fy;
    end
    
    tstar = told; %Get the time (used during this entire iteration)
    
    %On screen timer.
    set(timer,'string',strcat(num2str(tstar,3),'s'))
    zstar = z1;%interp1(time,zarray,tstar); %Interpolate data at this instant in time.
    
    %Rotation matrices to manipulate the vertices of the patch objects
    %using theta1 and theta2 from the output state vector.
    rot1 = [cos(zstar(1)), -sin(zstar(1)); sin(zstar(1)),cos(zstar(1))]*[xdat1;ydat1];
    set(link1,'xData',rot1(1,:))
    set(link1,'yData',rot1(2,:))
    
    rot2 = [cos(zstar(3)+zstar(1)), -sin(zstar(3)+zstar(1)); sin(zstar(3)+zstar(1)),cos(zstar(3)+zstar(1))]*[xdat2;ydat2];
    
    set(link2,'xData',rot2(1,:)+(rot1(1,3)+rot1(1,4))/2) %We want to add the midpoint of the far edge of the first link to all points in link 2.
    set(link2,'yData',rot2(2,:)+(rot1(2,3)+rot1(2,4))/2)
    
    %Change the hinge dot location
    set(h2,'xData',(rot1(1,3)+rot1(1,4))/2)
    set(h2,'yData',(rot1(2,3)+rot1(2,4))/2)
    
    %Show torques on screen (text only atm) update for time series later.
    set(tmeter1,'string',strcat(num2str(T1,2),' Nm'));
    set(tmeter2,'string',strcat(num2str(T2,2),' Nm'));
    
    drawnow;
    
    %f2 = figure(2);
    
    %set(f2, 'units', 'inches', 'position', [5 5 10 9])
    %set(f2,'Color',[1,1,1]);

    %subplot(2,1,1);
    %resp_x_yc = circshift(resp_x_yc,-1);
    %resp_x_yc(175) = figData.xtarget;
    %resp_x_x = circshift(resp_x_x,-1);
    %resp_x_x(175) = tnew;
    %resp_x_y = circshift(resp_x_y,-1);
    %resp_x_y(175) = figData.xend;
    %plot(resp_x_x, resp_x_yc, 'r', resp_x_x, resp_x_y, 'g', 'LineWidth', 2);
    %ylim([-2.5 2.5]);
    
    %legend({'reference','response'});
    %xlabel('time');
    %ylabel('coordinate');
    %title('X xoordinate response');
    
    %subplot(2,1,2);
    %resp_y_yc = circshift(resp_y_yc,-1);
    %resp_y_yc(175) = figData.ytarget;
    %resp_y_y = circshift(resp_y_y,-1);
    %resp_y_y(175) = figData.yend;
    
    %plot(resp_x_x, resp_y_yc, 'r', resp_x_x, resp_y_y, 'g', 'LineWidth', 2);
    %ylim([-2.5 2.5]);
    
    %legend({'reference','response'},'Location','southwest');
    %xlabel('time');
    %ylabel('coordinate');
    %title('Y xoordinate response');
    
    %drawnow
end
end

%%%% BEGIN CALLBACKS FOR MOUSE AND KEYBOARD STUFF %%%%%

% When click-up occurs, disable the mouse motion detecting callback
function ClickUp(varargin)
    figData = get(varargin{1},'UserData');
    set(figData.fig,'WindowButtonMotionFcn','');
    figData.Fx = 0;
    figData.Fy = 0;
    set(varargin{1},'UserData',figData);
end

% When click-down occurs, enable the mouse motion detecting callback
function ClickDown(varargin)
    figData = get(varargin{1},'UserData');
    figData.Fx = 0;
    figData.Fy = 0;

    set(figData.fig,'WindowButtonMotionFcn',@MousePos);
    set(varargin{1},'UserData',figData);
end

% any keypress switches from dragging the setpoint to applying a
% disturbance.
function KeyPress(hObject, eventdata, handles)

figData = get(hObject,'UserData');

figData.tarControl = ~figData.tarControl;

    if figData.tarControl
       disp('Mouse will change the target point of the end effector.')
    else
       disp('Mouse will apply a force on end effector.') 
    end
set(hObject,'UserData',figData);
end

% Checks mouse position and sends it back up.
function MousePos(varargin)
    figData = get(varargin{1},'UserData');

    mousePos = get(figData.simArea,'CurrentPoint');
    if figData.tarControl
        %figData.xtarget = mousePos(1,1);
        %figData.ytarget = mousePos(1,2);
        figData.xtarget = mousePos(1,1)/3.418;
        figData.ytarget = mousePos(1,2)/3.418;
    else
        figData.Fx = 10*(mousePos(1,1)-figData.xend);
        figData.Fy = 10*(mousePos(1,2)-figData.yend);
    end
     set(varargin{1},'UserData',figData);
end
