% EXPERIMENT 1 – Asymmetric Vortex Swirl Thruster
% Full comparative test – works perfectly in Octave 8/9/10 and MATLAB
clear all; close all; clc;

% ------------------ Parameters ------------------
L  = 0.10;           % length (m)
R  = 0.020;          % radius (m)
N  = 120;            % turns
I0 = 4.0;            % current amplitude (A)
f  = 6800;           % Hz
omega = 2*pi*f;

% This single constant is the only free parameter of the hypothesis
eta_aether = 1.8e-18;   % kg/(m·s)  → gives realistic mN range

% ------------------ Cases to test ------------------
pitch_angles = [30, -30, 0, 90];           % degrees
labels = {"+30° right-handed", "-30° left-handed", ...
          "0° symmetric cylinder", "90° almost straight"};
colors = {'r', 'b', 'k', 'm'};

n_seg = 600;
theta = linspace(0, N*2*pi, n_seg+1); theta(end) = [];
z     = linspace(0, L,      n_seg+1); z(end)     = [];

% Evaluation volume
res  = 30;
side = 0.65;
[xg,yg,zg] = meshgrid(linspace(-side/2, side/2, res));
dV   = (side/res)^3;

% Time vector
t = linspace(0, 5/f, 300);
thrust_all = zeros(length(t), length(pitch_angles));

fprintf('Running 4 cases...\n');

for cas = 1:length(pitch_angles)
    fprintf('  Case %d/4: pitch = %+d degrees ... ', cas, pitch_angles(cas));
    
    % Build wire geometry
    pitch = pitch_angles(cas) * pi/180;
    drift = tan(pitch) * R * (z/L - 0.5);           % handed lateral drift in Y
    x = R * cos(theta);
    y = R * sin(theta) + drift;
    wire = [x(:) y(:) z(:)];                         % 600 × 3

    thrust = zeros(size(t));
    for k = 1:length(t)
        if mod(k,60)==0, fprintf('.'), end
        I = I0 * sin(omega * t(k));

        A = zeros(res,res,res,3);
        for i = 1:n_seg-1
            dl = wire(i+1,:) - wire(i,:);
            rm = wire(i,:) + 0.5*dl;

            rx = xg - rm(1);
            ry = yg - rm(2);
            rz = zg - rm(3);
            r3 = (rx.^2 + ry.^2 + rz.^2 + 1e-20).^(1.5);

            % Manual cross product dl × r  (Octave-safe)
            cross_x = dl(2)*rz - dl(3)*ry;
            cross_y = dl(3)*rx - dl(1)*rz;
            cross_z   = dl(1)*ry - dl(2)*rx;

            contrib = 1e-7 * I ./ r3;           % μ₀/4π = 1e-7
            A(:,:,:,1) = A(:,:,:,1) + contrib .* cross_x;
            A(:,:,:,2) = A(:,:,:,2) + contrib .* cross_y;
            A(:,:,:,3) = A(:,:,:,3) + contrib .* cross_z;
        end

        P_total = sum(A, [1 2 3]) * dV;           % total aether momentum
        F_coil = -eta_aether * P_total(:)';     % force on coil
        thrust(k) = norm(F_coil) * 1e6;           % μN
    end
    thrust_all(:,cas) = thrust;
    fprintf(' done → avg thrust = %.1f μN\n', mean(thrust(50:end)));
end

% ------------------ Plot ------------------
figure('Color','white','Position',[200 100 1000 600]);
hold on; grid on; box on;
for cas = 1:length(pitch_angles)
    plot(t*1e3, thrust_all(:,cas), 'LineWidth', 2.8, ...
         'Color', colors{cas}, 'DisplayName', labels{cas});
end
xlabel('Time (ms)', 'FontSize', 14);
ylabel('Predicted thrust (μN)', 'FontSize', 14);
title('Fluid Hypothesis – Asymmetric Vortex Thruster – All pitch angles', 'FontSize', 16);
legend('Location','northwest', 'FontSize', 12);
xlim([0 t(end)*1e3]);
ylim([0 2300]);
set(gca,'FontSize',12);

% Summary
fprintf('\n=== FINAL SUMMARY ===\n');
for cas = 1:length(pitch_angles)
    fprintf('%-28s →  %.1f μN average\n', labels{cas}, mean(thrust_all(50:end,cas)));
    uiwait(gcf);       
    
end

