%Analyse Data Taken from a Muon detector, each entry in data1 corresponds to 
%the time between successive detections. The text file has 1.6 million entries, 
%so only read it once per session.

%Read data from a text file
%data1 = dlmread('09-14-21_Muon_Thresh0p010_DerThresh0p005.txt' ); %s
ttl_signal = dlmread('F0000CH1.csv' , ',' , 0 , 3);

% Here we're making length by 1 arrays of time and voltages from the ttl_signal
ttl_time = ttl_signal(:,1);
ttl_voltage = ttl_signal(:,2);


%Sliding Average
wndw = 10;                                      %# sliding window size
Ch1Slide = filter(ones(wndw,1)/wndw, 1, ttl_voltage); %# moving average


% determine threshold
m = mean(Ch1Slide(1:500));
s_d = std(Ch1Slide(1:500));
thresh = m+5*s_d;

% Finding rising index
for i = 1:length(ttl_time) 
temp = ttl_voltage(i);
if temp > thresh
  rise_index = i; % index where v is rising
  break
  end
end 
% Finding falling index
for i = length(ttl_time):-1:2 
temp = ttl_voltage(i);
if temp > thresh
  fall_index = i; % index where v is rising
  break
  end
end 
rise_time = ttl_time(rise_index);
fall_time = ttl_time(fall_index);
%Plotting ttl signal and rises
figure(1); clf
hold
ln = plot(ttl_time,ttl_voltage);
plot(rise_time, ttl_voltage(rise_index), 'or');
plot(fall_time, ttl_voltage(fall_index), 'or');
title('TTL Signal');
xlabel('Time (s)');
ylabel('Voltage (v)');
ttl_width = fall_time-rise_time;

%Muon Statistics
data2 = data1 + ttl_width; 
time = sum(data2); %s Total time 
count = rows(data2); % Number of events counted
R = count/time; % 

nbin = 71;
trange = logspace(-7,0,nbin);
Poisson = R*exp(-R.*trange);

%hist creates a histogram of a vector with nbins.
%nbin is 10 by default, hist does not normalize by default
nbin = 71;
edges = logspace(-7,0,nbin);
n = histc(data2,edges);
n = n(1:end-1);
bincenter = edges(1:end-1) +diff(edges)/2;
binSize = diff(edges);
Hist_Data = n' ./binSize ./count;
unc = (log(e).*(Hist_Data).**(1/2))/count./binSize;

%Plotting 
figure(2); clf
hold on
plot(trange,Poisson)
plot(bincenter, Hist_Data, '.r', 'markersize', 20);
errorbar(bincenter, Hist_Data, unc);
set(gca,'xscale','log','yscale','log') %Change scales to logarithmic 
title('Logarithmic Binning')
xlabel('Log Scale');
ylabel('Poisson Distribution (1/s)');
legend('Poisson Distribution','Data')

