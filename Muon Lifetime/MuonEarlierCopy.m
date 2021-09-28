[nelements,bincenter] = hist(data1,nbins=n, 1); %Unpacks Yaxis, Xaxis of histogram
lambda = rows(data1)/(24*3600);
Dist = poisspdf(data1,lambda);
%Plot a bar graph of the outputs of earlier histogram
figure(1); clf
hold on;
bar(bincenter,nelements);
%plot(trange, Poisson);

%Plot a histogram of the log of data1
figure(2); clf

%hist plots itself if it doesn't unpack outputs 
[h, x] = hist(LogData,nbins=n,1);
hist(LogData,nbins=n,1);

figure(3); clf
lognn = log(nelements);
logxx = log(bincenter);
bar(bincenter,lognn);