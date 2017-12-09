fprintf('Go grab a coffee, this is going to be a while...\n');

if exist('tdt') == 0
    tdt = tdt_block('1900_1900_20160304.tsq')
end

if exist('kSNIPS') == 0
    tic
    kSNIPS = cell(24,2);
    for i = 1:24
        fprintf('Snips: Working on %d\n',i);
        snip_temp = getdata(tdt,'Snip','channel',i);
        kSNIPS{i,1} = snip_temp.vals;
        kSNIPS{i,2} = snip_temp.times;
    end
    toc
end

if exist('kRAW_TIME') == 0
    tic
    fprintf('Raw: Working on kRAW_TIME\n');
    raw_temp = getTDTdata(tdt,'Raw1','channel',1);
    kRAW_TIME = raw_temp.times;
    toc
end

% if exist('kRAW') == 0
%     tic
%     kRAW = cell(32,2);
%     for i = 1:32
%         fprintf('Raw: Working on %d\n',i);
%         raw_temp = getTDTdata(tdt,'Raw1','channel',i);
%         kRAW{i,1} = raw_temp.vals;
%         kRAW{i,2} = raw_temp.times;
%     end  
%     toc
% end

fprintf('Done!\n');