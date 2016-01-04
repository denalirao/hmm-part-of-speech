function [ p1_output_prob, p2_max_final_prob, p2_most_likely_seq, cml_seq] = hmmWrapper()
% Denali Rao
% MATH 87
% 12/17/15
% -----------------------------------------------------------------------

emission = {'you', 'and', 'I', 'eat', 'food'};
cemission = zeros(1, numel(emission));
% convert input to numbers
% outputs = [run, walk, sleep, eat, you, me, we, fast, slow, he, she, it, is, are, food, unknown];
outputs = [1,2,3,4,5,6,7,8,9,10,11,12,13,14, 15];
unknown = 0;

for i = 1:numel(emission)
   if strcmp(emission(i),'run') || strcmp(emission(i),'runs')
       cemission(i) = 1;
   elseif strcmp(emission(i), 'walk') || strcmp(emission(i),'walks')
       cemission(i) = 2;
   elseif strcmp(emission(i), 'sleep') || strcmp(emission(i), 'sleeps')
       cemission(i) = 3;
   elseif strcmp(emission(i), 'eat')||strcmp(emission(i), 'eats')
       cemission(i) = 4;
   elseif strcmp(emission(i), 'you')
       cemission(i) = 5;
   elseif strcmp(emission(i), 'me')||strcmp(emission(i), 'I')
       cemission(i) = 6;
   elseif strcmp(emission(i), 'we')
       cemission(i) = 7;    
   elseif strcmp(emission(i), 'fast')
       cemission(i) = 8;
   elseif strcmp(emission(i), 'slow')
       cemission(i) = 9;
   elseif strcmp(emission(i), 'he')
       cemission(i) = 10; 
   elseif strcmp(emission(i), 'she')
       cemission(i) = 11; 
   elseif strcmp(emission(i), 'it')
       cemission(i) = 12; 
   elseif strcmp(emission(i), 'is')
       cemission(i) = 13; 
   elseif strcmp(emission(i), 'are')
       cemission(i) = 14; 
   elseif strcmp(emission(i), 'food')
       cemission(i) = 15;       
   else
       cemission(i) = 16;
       unknown = i;
   end
end


[ p1_output_prob, p2_max_final_prob, p2_most_likely_seq] = hmm(cemission);

% convert ml_seq back to parts of speech
% states = [noun, verb, adjective];
% states = [1, 2 , 3];
cml_seq = cell(length(p2_most_likely_seq), 1);
for i = 1:length(p2_most_likely_seq)
    if p2_most_likely_seq(i) == 1
        cml_seq{i,1} = 'noun';
    elseif p2_most_likely_seq(i) == 2
        cml_seq{i,1} = 'verb';
    elseif p2_most_likely_seq(i) == 3
        cml_seq{i,1} = 'adjective';
    elseif p2_most_likely_seq(i) == 4
        cml_seq{i,1} = 'adverb';
    end
end

if unknown > 0
    fprintf('"%s" is most likely a(n) %s', emission{1,unknown}, cml_seq{unknown, 1});

end
