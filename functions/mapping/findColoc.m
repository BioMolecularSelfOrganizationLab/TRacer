

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function N = findColoc(T, d)
% assembles all particles in reference channel coordinates and generates colocalization matrix

% T_ TRACER class holding all TIRF data
% d: distance in pixels


% prepare empty matrix
M = []; 
N = zeros(1,16);    % (X1|Y1|#1|X2|Y2|#2|X3|Y3|#3|X4|Y4|#4|bCh1|bCh2|bCh3|bCh4)
R = [T.Channel{T.MappingReferenceChannel}.ParticlesMapped,...
    T.Channel{T.MappingReferenceChannel}.Particles,...
    [1:size(T.Channel{T.MappingReferenceChannel}.ParticlesMapped,1)]',...
    repmat(T.MappingReferenceChannel,size(T.Channel{T.MappingReferenceChannel}.ParticlesMapped,1),1)];
    
for i=1:4 % loop across channels
    if ~isempty(T.Channel{i}.ParticlesMapped) && i ~= T.MappingReferenceChannel
        
        % create compound matrix of reference channel particle locations
        % and mapped particle coordinates from other channels
        
        M = [R;[T.Channel{i}.ParticlesMapped,T.Channel{i}.Particles,[1:size(T.Channel{i}.ParticlesMapped,1)]',repmat(i,size(T.Channel{i}.ParticlesMapped,1),1)]];
        % determine relative distances
        [D] = pdist(M(:,1:2));
        d = squareform(D);
        j=1;
        
        for n=1:length(d)
            f = d(n,:)>0&d(n,:)<3;
            if n<find(f);
                N(j,1:3) = [M(n,1:2),M(n,5)];
                N(j,i*3-2:i*3) = M(f,3:5);
                N(j,M(n,6)+12) = 1;
                N(j,M(d(n,:)>0&d(n,:)<3,6)+12) = 1;
                j=j+1;
            end
        end
        
    end
end


M=N;

end
