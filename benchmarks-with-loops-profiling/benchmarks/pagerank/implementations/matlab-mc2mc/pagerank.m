function [pageRanks,t,maxDiff] = pagerank(iter,thresh,pages,noutlinks,pageRanks,n)
maxDiff   = 99;
dFactor   = 0.85;
maps = zeros(n,n);

%fprintf('pagerank: loop1 = %d, loop2 = %d, loop3(v) = %d\n',iter,n,n);

for t = 1:iter
    if maxDiff < thresh
        break; 
    end
    % map_page_rank
    for i = 1:n
       outbounRank = pageRanks(i)/noutlinks(i);
       % old
       %for k = 1:n
       %    maps(i,k) = pages(i,k) * outbounRank;
       %end
       % new
       k = colon(1,n);
       maps(i, k) = times(pages(i, k),rdivide(pageRanks(i),noutlinks(i)));
       %
    end
    % reduce_page_rank
    dif = 0;
    for j = 1:n
        oldRank = pageRanks(j);
        newRank = sum(maps(:,j));
        newRank = ((1-dFactor)/n)+(dFactor*newRank);
        newDif  = abs(newRank - oldRank);
        if newDif > dif
            dif = newDif;
        end
        pageRanks(j) = newRank;
    end
    maxDiff = dif;
end
end
