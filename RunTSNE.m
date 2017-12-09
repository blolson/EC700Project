function raw_spike_train = RunTSNE(kRAW_TIME, kSNIPS)
%   Blade Olson, BU 12/8/17
   
    kELECTRODE_NUM = 4;
    kTETRODE_CLUSTER = [10, 4, 7, 3, 5, 8];
    kLINE_COLORS = ['b.', 'g.', 'r.', 'k.', 'm.', 'c.', 'y.', 'b.', 'g.', 'r.'];
    kCLUSTER_TRAIN_EXAMPLES = 500;
    snip_list = cell(4,1);
    
    %assemble rows that include the 31*4 time points across the 4
    %electrodes in the tetrode
    %the matrices should be separated
    for i = 0:5
        fprintf('Load TSNE Matrices: Working on tetrode %d\n',i+1);
        tetrode = kELECTRODE_NUM * i + 1;
        index = i+1;
        t_end = length(kSNIPS{tetrode,1});
        snip_list{index} = [kSNIPS{tetrode,1}(:,1:t_end); kSNIPS{tetrode+1,1}(:,1:t_end); kSNIPS{tetrode+2,1}(:,1:t_end); kSNIPS{tetrode+3,1}(:,1:t_end)]';
    end

    %get greatest time point
    time_end = 0;
    for i = 0:5
        tetrode = kELECTRODE_NUM * i + 1;
        time_end = max(time_end, kSNIPS{tetrode,2}(kCLUSTER_TRAIN_EXAMPLES));
    end
    
    [~, training_time_index] = min(abs(kRAW_TIME-time_end));
    raw_spike_train = zeros(training_time_index,sum(kTETRODE_CLUSTER));
    raw_time_rounded = round(kRAW_TIME, 5);
    
    %RUN ON A SUBSET OF THE DATA
    %for each tetrode matrix, run TSNE to see if we can create neuron
    %groups
    rng default % for reproducibility
    for i = 0:5
        fprintf('Create TSNE Distribution: Working on tetrode %d\n',i+1);
        tetrode = kELECTRODE_NUM * i + 1;
        index = i+1;
%         [Y, loss] = tsne(snip_list{index}(1:kCLUSTER_TRAIN_EXAMPLES,:),'Algorithm','barneshut','NumPCAComponents',50,'Distance','correlation');
%         figure
%         gscatter(Y(:,1),Y(:,2))
        [Y2,loss2] = tsne(snip_list{index}(1:kCLUSTER_TRAIN_EXAMPLES,:),'Algorithm','barneshut','NumPCAComponents',50,'Distance','correlation','NumDimensions',3);
        figure;
        scatter3(Y2(:,1),Y2(:,2),Y2(:,3),'filled')
%         fprintf('2-D embedding has loss %g, and 3-D embedding has loss %g.\n',loss,loss2)
        fprintf('3-D embedding has loss %g.\n',loss2)
        
        %Group the scatter plot into clusters
        %Putting together a basic GMM clustering algorithm...
        options = statset('MaxIter',1000);
        GMModels = fitgmdist(Y2,kTETRODE_CLUSTER(index),'Options',options);
        idx = cluster(GMModels,Y2);
        
        % for plotting your sanity
        figure
        hold on
        for v = 1:kTETRODE_CLUSTER(index)
            temp_cluster = Y2(idx == v,:);
            scatter3(temp_cluster(:,1),temp_cluster(:,2),temp_cluster(:,3),'filled',kLINE_COLORS(v))
            
            %tag the original set of snips using these clusters
            %Blade - I actually don't think this step is necessary

            %AND
            %setup a matrix of 0s and 1s based on when we believe spikes occured
            %rows of each time point
            %columns are neuron clusters we've identified
            cluster_size = length(temp_cluster);
            if cluster_size < 10
                continue;
            end
            
            if index == 1
                currentCluster = v;
            else
                currentCluster = sum(kTETRODE_CLUSTER(1:index-1)) + v;
            end
            
            snip_time_rounded = round(kSNIPS{tetrode,2}(1:kCLUSTER_TRAIN_EXAMPLES), 5);
            spike_temp = ismember(raw_time_rounded, snip_time_rounded(idx == v));
            raw_spike_train(:,currentCluster) = spike_temp(1:training_time_index);
            
            %Combine rows of spikes into single spikes
%             X = [diff(raw_spike_train)~=0;0;];
%             B = find([1;X]); % begin of each group
%             E = find([X;1]); % end of each group
%             D = 1+E-B; % the length of each group
%             Y = D>1; % holds the indices of groups where there is more than 1 spike in a row
%             L = logical(X==1); %this will leave only the 1's cluster group in the matrix - maybe not the best way to do this...
% 
%             for s = 1:length(Y)
%                 if L(B(Y(s))) > 0
%                     strip_len = D(Y(s));
%                     strip_mid = round(strip_len/2,1);
%                     raw_spike_train(B(Y(s)):E(Y(s)), currentCluster) = zeros;
%                     raw_spike_train(strip_mid, currentCluster) = 1;
%                 end
%             end
        end
        hold off
    end
            
    %run directed information or granger causality on the matrix
    
    %RUN ON THE UNUSED TEST DATA
        %With the directed causal connections, now figure out the probability
        %of a spike given a pattern of firing of the parent nodes for a
        %particular child node
end