:Namespace Generate

  ⎕IO ⎕ML←0 1

⍝ Generate events based on Markov models
⍝
⍝ Usage: Count Generate.Distribution Stimuli Targets Probabilities 
⍝   Stimuli        String representations of events as a vector of strings
⍝   Targets        A matrix of edges mapping source to target via stimuli
⍝   Probabilities  A matrix of probabilities for each transition given in target
⍝   Count          A natural number indicating the number of sequences to generate
⍝
⍝ See the Increment Test Plan for more information on the overall use and design 
⍝ of this namespace and the above inputs. 

Distribution←{⍵{⍵,⊂⊃⍺ Transition⍣≡'' 0}⍣⍺⊢⍬}

⍝ Stimuli VerifyInputs Targets Probabilities
⍝
⍝ The following code only works assuming some invariants. Users can use this 
⍝ function to verify that their input is correct. This is not put in the 
⍝ Distribution function for all calls because of the potential overhead 
⍝ when used automatically.

VerifyInputs←{S T P←⍵,⍨⊂⍺
  Type←⊃∘(0∘⍴)∘⊂
  ~∧/0=,Type P:     'Probability values are not numeric'                 ⎕SIGNAL 11
  ~∧/0=,Type T:     'Target values are not numeric'                      ⎕SIGNAL 11
  ~∧/,2≤/0,(⍪,P),1: 'Probability values are not in range [0,1]'          ⎕SIGNAL 11
  ~∧/(,T)∊¯1,⍳⊃⍴T:  'Edges point to non-existant states'                 ⎕SIGNAL 11
  ~∧/,2≤/0,(⍪+/P),1:'Probability totals are not in range [0,1]'          ⎕SIGNAL 11
  ~(⍴T)≡(⍴P):       'Targets and Probabilities are not of the same shape'⎕SIGNAL 11
  ~2≡⊃⍴⍴T:          'Targets and Probabilities are not Matrices'         ⎕SIGNAL 11
  ~0≠⊃⍴T:           'Model has no states'                                ⎕SIGNAL 11
  ~(⍴S)≡(1↓⍴T):     'Stimuli set does not match the model'               ⎕SIGNAL 11
  ~∧/' '=∊Type S:   'Stimuli are not characters'                         ⎕SIGNAL 11
  ~2≡≡S:            'Stimuli is not a vector of strings (Bad Depth)'     ⎕SIGNAL 11
  ~∧/(⊂,1)≡¨⍴∘⍴¨S:  'Stimuli contains non-strings'                       ⎕SIGNAL 11
  ~∧/0=(¯1=,T)/,P:  'Non-zero probabilities to illegal edges'            ⎕SIGNAL 11
  ⎕←'Input Passes'
}

⍝ (Stimuli Targets Probabilities) Transition (Events State)
⍝    Stimuli,Targets,Probabilities  See Distribution function
⍝    Events                         A string of events
⍝    State                          Current State (Natural Number)
⍝
⍝ Given the Markov Model and a starting state, do one transition on 
⍝ the model and generate at most one new event based on the distribution
⍝ given in the model.
⍝
⍝ This function is designed to run to a fix-point. For each state in a 
⍝ markov model, if a termination is possible, then the total sum of 
⍝ probabilities for the transition should be less than 1.0. In this case, 
⍝ the difference is used as the probability of exiting on this state and 
⍝ generating no additional event. In this case, the output is the same 
⍝ as the input, signalling a termination when used as a fixed point function. 
⍝ We can stop the model by transitioning to the first state, 
⍝ the 0-th state, which is the same as transitioning out of the model. 

Transition←{E T P←⍺ ⋄ Z S←⍵
  (''≢Z)∧0=S              :⍵
  (⊃⍴E)≤I←Pick p,1-+/p←S⌷P:⍵
  (Z,' ',I⊃E)(S I⌷T)
}

⍝ Pick Probs
⍝   Probs A vector of real probabilities on the range [0,1]
⍝
⍝ Generate an index into Probs based on the probabilities given in Probs.
⍝ Probabilities should not extend beyond 5 decimal places.

Pick←{+/(+\⍵)≤D÷⍨?D←100000} 

:EndNamespace