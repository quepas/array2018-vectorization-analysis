%% LoopID: pagerank1
loopID = 'pagerank1';
% Benchmark: pagerank
% Function: pagerank.m
% Default: {n: 1000}

resultsDir = '../../results/';
addpath('../../helpers/')
% Num. of repated measurements
rep = 100;
% Function aggregating data from repeated measurements
aggregate = @min;
% Values of input parameter (data sizes)
parameterValues = 1:16:2048;
numValues = length(parameterValues);
aggregatedMeasurements = zeros(numValues, 3);

for value = 1:numValues
   n = parameterValues(value);

   %% Original code
   measurements = zeros(1, rep);
   for r = 1:rep
      maps = rand(n, n);
      pages = rand(n, n);
      outbounRank = rand(1, 1);
      ii = randi([1, n], 1, 1);

      tic();
      for k = 1:n
         maps(ii,k) = pages(ii,k) * outbounRank;
      end
      measurements(1, r) = toc();
   end
   aggregatedMeasurements(value, 1) = aggregate(measurements(1, :));

   %% LCPC code
   measurements = zeros(1, rep);
   for r = 1:rep
      maps = rand(n, n);
      pages = rand(n, n);
      outbounRank = rand(1, 1);
      ii = randi([1, n], 1, 1);

      tic();
      k = colon(1,n);
      maps(ii, k) = times(pages(ii, k), outbounRank);
      measurements(1, r) = toc();
   end
   aggregatedMeasurements(value, 2) = aggregate(measurements(1, :));

   %% HHM code
   measurements = zeros(1, rep);
   for r = 1:rep
      maps = rand(n, n);
      pages = rand(n, n);
      outbounRank = rand(1, 1);
      ii = randi([1, n], 1, 1);

      tic();
      maps(ii,:) = pages(ii,1:n) .* outbounRank;
      measurements(1, r) = toc();
   end
   aggregatedMeasurements(value, 3) = aggregate(measurements(1, :));

end

plotResults(parameterValues, aggregatedMeasurements)
writeResults(parameterValues, aggregatedMeasurements, loopID, resultsDir);
