
function out = imgmerge(I1,I2,s)
% merges arrays either vertically or horizontally
switch s
    case 'v' % merge vertically (I1 above I2)
        if size(I1,2) == size(I2,2)
            out = [I1;I2];
        else
            out = {'err','Column count of input arrays not equal.'};
            return;
        end
    case 'h' % merge horizontically (I1 left of I2)
        if size(I1,1) == size(I2,1)
            out = [I1,I2];
        else
            out = {'err','Row count of input arrays not equal.'};
            return;
        end
    case 'c' % concatenate stacks of images
        if ndims(I1) == 3 && ndims(I2) == 3
           out = cat(3,I1,I2);
        end
end


end