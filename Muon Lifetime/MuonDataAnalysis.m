%Analyse Data Taken from a Muon detector, each entry in data1 corresponds to 
%the time between successive detections. The text file has 1.6 million entries, 
%so only read it once per session.
pkg load statistics;
%Read data from a text file
data1 = dlmread('09-14-21_Muon_Thresh0p010_DerThresh0p005.txt' ); %s
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
ttl_width = fall_time-rise_time;

%Muon Statistics
data2 = data1 + ttl_width; 
time = sum(data2); %s Total time 
count = rows(data2); % Number of events counted
R = count/time; % 

trange = linspace(0,time,10000);
Poisson = exp(-R.*trange);

%Take the log of the data.
LogData = log10(data2); 
%hist creates a histogram of a vector with nbins. I've specified to normalize the bars.
%nbin is 10 by default, hist does not normalize by default
nbin = 71;
edges = linspace(-7,0,nbin);
n = histc(LogData,edges);
binwidths = 10.**edges;

noverwidths = n'./binwidths/count;
CountError = (noverwidths.**(1/2))/
figure(2); clf
plot(edges, noverwidths, '.r', 'markersize', 15);
title('Logarithmic Binning')
xlabel('Log Scale');


##
##figure(3); clf
##hist(data1, nbins=nbin, 1);
##title('Normalized Binning of Muon Data')
##
##figure(4); clf
##hist(LogData,nbins=nbin,1);
##title('Log Binning (not accounting for bin width)')