%Function to plot the phasor diagram for a diffraction grating in a movie.
%Can uncomment lines at the bottom to generate the movie for either viewing
%in MATLAB or exporting to a seperate file.

%Use the variables at the top to set up the diffraction grating

%Written by Matt Bergin 2017
%% Initialise variables
%User defined variables to setup problem
k=100;      %Wavevector of the incoming wave. Wave is assumed to be perpendicular to the grating
d=1;        %Width between the slits
N_slit=6;   %Number of slits in grating
A=1;        %Amplitude of incoming wave


%Setup extra variables
fig=figure;
phi_tot=0;

%Define the angles to view the grating at and calculate the path difference
%between adjacent slits
theta_step=0.0001;
theta_end=0.1;
s_theta=theta_step:theta_step:theta_end; %sin(theta)
N_theta=length(s_theta);
delta=k*d*(s_theta);


%% Find how the intensity varies with angle
%Calculate the total amplitude for each angle in a vector phi_tot
for k=1:N_slit
    phi_tot=phi_tot+A*exp(1i*k*delta);
end

%Create variable to save frames to
clear F
F(N_theta)=struct('cdata',[],'colormap',[]);

%Plot top half of figure with total intensity and moving line as
%sin(theta) increases
h1=subplot(2,1,1);
plot(s_theta,abs(phi_tot).^2)
hold on
p1=plot([0 0],[0 N_slit^2+10],'r');
ylim([0 N_slit^2+5])
xlabel('sin(\theta)')
ylabel('I')
title('Variation of Intensity with angle')

%% Plot the phasors for each angle
%Main loop over each angle
for n=1:N_theta
    
    %Update the position of the red line on the top graph
    set(p1,'XData',[s_theta(n) s_theta(n)])
    
    %Clear the bottom graph
    if exist('h2','var')==1
        delete(h2)
    end
    
    %Draw phasor diagram in bottom half of the figure
    h2=subplot(2,1,2);
    
    phi=A*exp(1i*delta(n));
    plot([complex(0,0),phi])
    hold on
    
    %Let axes change size so it is easy to see details
    axis square
    axis equal
    
    %Alternatively can keep axes fixed for better feeling of scale
    %set(gca,'XTickLabel','','YTickLabel','')
    %xlim([-N_slit N_slit])
    %ylim([-N_slit N_slit])
    
    title('Phasor Diagram')
    
    %Loop to add each extra slit in
    for k=2:N_slit
        temp=phi;
        phi=phi+A*exp(1i*k*delta(n));
        plot([temp,phi])
    end
    %Draw figure
    drawnow
    
    %Uncomment to capture the frame to use in a movie later
    %F(n)=getframe(fig);
    
end


%% Extra code to use if you need to export a movie
%Code to show movie in MATLAB
% hf=figure;
% axis off
% movie(hf,F)

%Code to export a video
% v = VideoWriter('Diffraction_test.avi');
% v.Quality=25; %Reduce quality to keep file size down
% open(v)
% writeVideo(v,F)
% close(v)
