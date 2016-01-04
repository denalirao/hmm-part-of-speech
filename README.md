# hmm-part-of-speech


	Hidden Markov models are statistical models that were first described in the 1950s and 1960s. They were first used
	for mathematical smoothing of curves, and were soon adopted into the biomedical world for use in bioinformatics.
	Today they are used for gene prediction, sequence alignment, and protein folding.
	
	They are an interesting way to look at the emissions and transitions of a system, and so they lend themselves to
	analysis and modeling of temporal data. This includes data for speech recognition, speech analysis, handwriting
	analysis, and more.
	
	Because hidden Markov models are stochastic and almost completely based on probabilities, they are very sensitive to
	even small changes in their parameters. Depending on the desired application, it can be simple or very difficult to
	build the hidden Markov model. Even when it is simple, different parameters can be modified to “tune” the model to
	different scenarios.

	This paper (see paper.pdf) will demonstrate how to implement a hidden Markov model and begin to apply it to a simple
	problem, and then discuss how to move further with the model. The paper will investigate the sensitivity of the model
	and the difficulty of achieving accuracy. Finally, this paper will discuss the possibilities of improving an
	implemented hidden Markov model, including machine learning.
	
	The file hmm.m contains the implementation of the model. 
	         hmmWrapper.m contains the code needed to apply the model to the problem of part of speech recognition.
	         hmmBasic.m contains a stripped-down version of the model.
