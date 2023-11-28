%Repetition encoding

function [encBits] = Repetition_Encoder(bits,L)
k=1;
for i=1:length(bits)
    encBits(k:k+(L-1))=repmat(bits(i),1,L);
    k=k+L;
end