function y = blockBackground(x)
% blockBackground extracts the block data from the input structure
% and finds its minimum  and returns that scalar as the output
block = x.data;
y = min(block(:));



