function [ p1_output_prob, p2_max_final_prob, p2_most_likely_seq] = hmm(test_output)
% Denali Rao
% MATH 87
% 12/17/15
% -----------------------------------------------------------------------
% SET UP THE MODEL

% set of states
% states = [noun, verb, adjective, adverb];
states = [1, 2 , 3, 4];

% set of outputs
% outputs = [run, walk, sleep, eat, you, me, we, fast, slow, he, she, it, is, are, food, unknown];
outputs = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

% set state transition probabilities
transition_probabilities = [
.05    .5   .15   .2;
.3      0   .3    .4;
.65    .1   .2    0;
0      .4   .35   .4
];

%       noun  verb  adj  adv
% noun  .05    .5   .15    .2
% verb  .3      0   .3     .4
% adj   .65    .1   .2      0
% adv   0      .4   .35    .4


% set of emission probabilities
emission_probabilities = [
%run, walk, sleep, eat, you, me, we, fast, slow, he, she, it, is, are, food, unknown
 .2   .2      .2    .2    1   1   1   .1    0    1    1    1   0   0    1   .25; % noun
 .8   .8      .8    .8    0   0   0   .1    .1   0    0    0   1  .15   0   .25; % verb
  0    0      0     0     0   0   0   .3    .8   0    0    0   0  .85   0   .25; % adjective
  0    0      0     0     0   0   0   .4    .1   0    0    0   0   0    0   .25  % adverb
];

%      run, walk, sleep, eat, you, me, we, fast, slow, he, she, it, is, are, food, unknown
% noun .2   .2      .2    .2    1   1   1   .15   0     1   1    1   0   0   1    .25
% verb .8   .8      .8    .8    0   0   0   .15   .1    0   0    0   1   1   0    .25
% adj   0    0      0     0     0   0   0   .4    .8    0   0    0   0   0   0   .25
% adv   0    0      0     0     0   0   0   .3    .1    0   0    0   0   0   0      .25


% set initial probabilities
initial_probabilities = [.65, .05, .2, .1];

%-------------------------------------------------------------------------

% PROBLEM 1
% given an observation sequence of length T, what was the probability of
% that output?
%test_output = [1,2, 1, 1, 2];
forward_var = zeros(length(test_output), length(states));
%forward_var(1,1) = initial_probabilities(test_output(1));

for i = 1:length(states)
    forward_var(1,i) = initial_probabilities(i) * emission_probabilities(i, test_output(1));
end

for t = 1:(length(test_output)-1)
    for j = 1:length(states)
        sum = 0;
        for i = 1:length(states)
            sum = sum + forward_var(t,i) * transition_probabilities(i,j);
        end
        forward_var(t+1, j) = sum * emission_probabilities(j, test_output(t+1));
    end
end


p1_output_prob = 0;
for i = 1:length(states)
    p1_output_prob = p1_output_prob + forward_var(length(test_output), i);
end


%-------------------------------------------------------------------------
% PROBLEM 2
% given an observation sequence of length T, what was the most likely
% sequence of states to lead to it? (and the probability of that sequence?)

% will hold our final answer - the most likely sequence
p2_most_likely_seq = zeros(length(test_output),1);

% delta will hold the best score for paths up to that point, for every t
% phi keeps track of which state was the best, for every t
% We will use both delta and phi to trace back and find the most likely seq
delta = zeros(length(test_output), length(states));
phi = zeros(length(test_output), length(states));

% initialize
for i = 1:length(states)
    delta(1,i) = initial_probabilities(i) * emission_probabilities(i, test_output(1));
    phi(1,i) = 0;
end

% 
for t = 2:length(test_output)
    for j = 1:length(states)
        max = -1;
        argmax = -1;
        for i = 1:length(states)
            if (delta(t-1, i) * transition_probabilities(i,j)) > max
                max = (delta(t-1,i) * transition_probabilities(i,j));
                argmax = i;
            end
        end
        delta(t,j) = max * emission_probabilities(j,test_output(t));
        phi(t,j) = argmax;
    end
end

p2_max_final_prob = -1;
argmax = -1;
for i = 1:length(states)
    if delta(length(test_output), i) > p2_max_final_prob
        p2_max_final_prob = delta(length(test_output),i);
        argmax = i;
    end
end

p2_most_likely_seq(length(test_output)) = argmax;

for t = length(test_output)-1:-1:1
    p2_most_likely_seq(t) = states(phi(t+1, p2_most_likely_seq(t+1)));
end

