%QPSK Demodulator

function [demodBits] = QPSK_demodulator(Rx,n)
detSignal=[];
symbols=[1+1i,-1+1i,-1-1i,1-1i];
bitSet=[0,0;1,0;1,1;0,1];
for i=1:length(Rx)

   distanceVals = abs(Rx(i)-symbols);
   [val ind] = min(distanceVals);
   detSignal(i) =  symbols(ind);
end

k=1;
for j=1:n
    for m=1:4
        if detSignal(j)==symbols(m)
            
            demodBits(1,(k:k+1))=bitSet(m,:);
        end
    end
    k=k+2;
end