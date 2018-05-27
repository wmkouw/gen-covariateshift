# sample-covariateshift

Scripts to sample from class-conditional distributions, under covariate shift.

To be precise:

Assume that there is a single sample space X, and a fixed number of classes Y. Let the _source domain_, referred to as p<sub>S</sub>(x,y), be one distribution over (X,Y) and the _target domain_ another, p<sub>T</sub>(x,y). In cases of covariate shift, the posterior distributions are equal in both domains; p<sub>S</sub>(y|x) = p<sub>T</sub>(y|x).

Distributions:
- p(y) is the distribution of the classes (equal in both domains).
- p(y|x) is the posterio distribution (equal in both domains; hence _covariate shift_)
- p<sub>S</sub>(x) is the source distribution of the data.
- p<sub>T</sub>(x) is the target distribution of the data.

The scripts generate class-conditional distributions for each domain, p<sub>S</sub>(x|y) and p<sub>T</sub>(x|y), using Bayes' rule. Samples are drawn using a rejection sampler.


## Usage

Have a look at `example_call.m`

## Questions
Questions, comments and bugs can be submitted in the [issues tracker](https://github.com/wmkouw/sample-covariateshift/issues).
