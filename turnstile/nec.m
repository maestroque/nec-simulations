% Script to process the text file and extract E_theta and E_phi as complex arrays

% Input file name
inputFile = 'turnstile.txt'; % Replace with the actual file name

% Read the data from the file
data = readmatrix(inputFile, 'Delimiter', ' ', 'MultipleDelimsAsOne', true);

% Check if the file was read successfully
if isempty(data)
    error('File could not be read. Check the file path and format.');
end

% Extract the last four columns
E_theta_mag = data(:, end-3); % Magnitude of E_theta
E_theta_ang = data(:, end-2); % Angle of E_theta in degrees
E_phi_mag = data(:, end-1);   % Magnitude of E_phi
E_phi_ang = data(:, end);     % Angle of E_phi in degrees

% Convert to complex form
E_theta = E_theta_mag .* exp(1i * deg2rad(E_theta_ang));
E_phi = E_phi_mag .* exp(1i * deg2rad(E_phi_ang));

E_theta = E_theta(2:end)';
E_phi = E_phi(2:end)';


t = -90:1:-2;

disp(size(E_theta));
disp(size(E_phi));

% Mirror E_theta and E_phi and add the missing values
E_theta = [E_theta, fliplr(E_theta)];
E_phi = [E_phi, fliplr(E_phi)];
t = [t, -fliplr(t)];

disp(size(E_theta));
disp(size(E_phi));
disp(size(t));

% Polar plot of E_theta
figure;
polarplot(deg2rad(t), abs(E_theta));
title('Polar Plot of E_{\theta}');

% % Polar plot of E_phi
figure;
polarplot(deg2rad(t), abs(E_phi));
title('Polar Plot of E_{\phi}');

% Calculate E_left and E_right
E_left = 0.5 * (E_theta - 1j*E_phi);
E_right = 0.5 * (E_theta + 1j*E_phi);

% Normalize E_left and E_right
E_left = E_left / max(abs(E_left));
E_right = E_right / max(abs(E_right));

% Polar plot of E_left
figure;
polarplot(deg2rad(t), 10*log10(abs(E_left)));
title('Polar Plot of E_{left}');

% Polar plot of E_right
figure;
polarplot(deg2rad(t), 10*log10(abs(E_right)));
title('Polar Plot of E_{right}');


save('radiation_pattern_complex.mat', 'E_theta', 'E_phi');
