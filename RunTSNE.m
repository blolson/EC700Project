function data = RunTSNE(kRAW_TIME, kSNIPS)
%   Blade Olson, BU 12/8/17
   
    kNUMBER_OF_ELECTRODES = 6;
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
        temp_snip_matix = zeros(length(kSNIPS{tetrode,1}(1,:)),length(kSNIPS{tetrode,1}(:,1))*4);
        time_end = length(kSNIPS{tetrode,1});
        temp_snip_matix = [kSNIPS{tetrode,1}(:,1:time_end); kSNIPS{tetrode+1,1}(:,1:time_end); kSNIPS{tetrode+2,1}(:,1:time_end); kSNIPS{tetrode+3,1}(:,1:time_end)]';
        snip_list{index} = temp_snip_matix;
    end

    %get greatest time point
    time_end = 0;
    for i = 0:5
        tetrode = kELECTRODE_NUM * i + 1;
        time_end = max(time_end, kSNIPS{tetrode,2}(kCLUSTER_TRAIN_EXAMPLES));
    end
    
    cluster_matrix = zeros(kCLUSTER_TRAIN_EXAMPLES*kNUMBER_OF_ELECTRODES,sum(kTETRODE_CLUSTER));
    %RUN ON A SUBSET OF THE DATA
    %for each tetrode matrix, run TSNE to see if we can create neuron
    %groups
    rng default % for reproducibility
    for i = 0:5
        fprintf('Create TSNE Distribution: Working on tetrode %d\n',i+1);
        index = i+1;
        [Y, loss] = tsne(snip_list{index}(1:kCLUSTER_TRAIN_EXAMPLES,:),'Algorithm','barneshut','NumPCAComponents',50,'Distance','correlation');
        figure
        gscatter(Y(:,1),Y(:,2))
        [Y2,loss2] = tsne(snip_list{index}(1:kCLUSTER_TRAIN_EXAMPLES,:),'Algorithm','barneshut','NumPCAComponents',50,'Distance','correlation','NumDimensions',3);
        scatter3(Y2(:,1),Y2(:,2),Y2(:,3),'filled')
        fprintf('2-D embedding has loss %g, and 3-D embedding has loss %g.\n',loss,loss2)
        
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
        end
        hold off
        
        %tag the original set of snips using these clusters
        %Blade - I actually don't think this step is necessary
        %AND

        %setup a matrix of 0s and 1s based on when we believe spikes occured
        %rows of each time point
        %columns are neuron clusters we've identified
        
        
    end
    
    %run directed information or granger causality on the matrix
    
    %RUN ON THE UNUSED TEST DATA
        %With the directed causal connections, now figure out the probability
        %of a spike given a pattern of firing of the parent nodes for a
        %particular child node
        
     data = 1;
end