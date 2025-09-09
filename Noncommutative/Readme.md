## Use these scripts to generate the figures and tables in "On the reversible actions of an idempotent vector addition system."

These scripts all use the `vpa` plugin for arbitrary increased integer precision.

`adjaceny_graph(n)` generates the connected components of the graph of the reversible actions in each $n$-network (Figure 2).
`connected_states(n)` computes the total number of allowed 1-colorings in each $n$-network (Eq. 1).
`connected_states(n)` computes the total number of allowed 1-colorings which are *new* (Section V).
`count_origins(n)` computes the total number of 1-to-$n$-colorings which are reversible to no actions (Table I).
`counting_states2(n)` for $n =\:4,\:5,\:6$ is an exhaustive enumeration of the strongly connected 1-colorings (Section VI).
`find_origins(n,'m',m)` computes the numbers $\Omega^n\left(m\right)$ and $B_1^n\left(m\right)$ of the number of $m$-colorings that can reversibly reach 1-colorings, and the convergence of allowed 1-colorings onto n-colorings (Section IV, Eq. 3).
`k_from_above1(n)` creates a table (Table V) of the numbers of m-colorings reachable from above in the n-network from old 1-colorings (Table V).
`old_onecolorings(n)` estimates the numbers of old $n-k$-colorings colorings that must be used to reach $m$-colorings in the $n$-network (Table VI).
`possiblestates2(n)` generates all the connected 1-colorings of the $n$-network.

