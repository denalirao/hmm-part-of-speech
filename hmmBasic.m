function [ p1_output_prob, p2_max_final_prob, p2_most_likely_seq] = hmmBasic(test_output)
% Denali Rao
% MATH 87
% 12/17/15

% -----------------------------------------------------------------------
% SET UP THE MODEL

% set of states
% states = ['A', 'B', 'C'];
states = [1,2,3];

% set of outputs
% outputs = ['a', 'b'];
outputs = [1,2];

% set state transition probabilities
transition_probabilities = zeros(3,3);
for i = 1:3
    for j = 1:3
        transition_probabilities(i,j) = .25;
    end
end
transition_probabilities(1,1) = .5;
transition_probabilities(2,2) = .5;
transition_probabilities(3,3) = .5;

%    A   B   C
% A .50 .25 .25
% B .25 .50 .25
% C .25 .25 .50

% set emission probabilities
emission_probabilities = [.8, .2;
                          .1, .7;
                          .1, .1];

%    'a' 'b'
% A  .8  .2
% B  .1  .7
% C  .1  .1


% set initial probabilities
initial_probabilities = [.333,.333,.333];

%-------------------------------------------------------------------------

% PROBLEM 1
% given an observation sequence of length T, what was the probability of
% that output?
%test_output = [1,2, 1, 1, 2];
forward_var = zeros(length(test_output), length(states));
forward_var(1,1) = initial_probabilities(test_output(1));

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
probs = zeros(length(test_output), length(states));
backpointers = zeros(length(test_output), length(states));

% initialize
for i = 1:length(states)
    probs(1,i) = initial_probabilities(i) * emission_probabilities(i, test_output(1));
    backpointers(1,i) = 0;
end

% 
for t = 2:length(test_output)
    for j = 1:length(states)
        max = -1;
        argmax = -1;
        for i = 1:length(states)
            if (probs(t-1, i) * transition_probabilities(i,j)) > max
                max = (probs(t-1,i) * transition_probabilities(i,j));
                argmax = i;
            end
        end
        probs(t,j) = max * emission_probabilities(j,test_output(t));
        backpointers(t,j) = argmax;
    end
end

p2_max_final_prob = -1;
argmax = -1;
for i = 1:length(states)
    if probs(length(test_output), i) > p2_max_final_prob
        p2_max_final_prob = probs(length(test_output),i);
        argmax = i;
    end
end

p2_most_likely_seq(length(test_output)) = argmax;

for t = length(test_output)-1:-1:1
    p2_most_likely_seq(t) = states(backpointers(t+1, p2_most_likely_seq(t+1)));
end

