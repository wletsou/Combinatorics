## Use these scripts to generate the figures and tables in "The Combinatorics of Reversible Chromosome Folding."

These scripts all use the `vpa` plugin for arbitrary increased integer precision.

`adjaceny_graph(n)` generates the connected components of the graph of the reversible actions in each $n$-network (Figure 6).

`connected_states(n)` computes the total number of allowed 1-colorings in each $n$-network (Eq. 3).

`connected_states(n)` computes the total number of allowed 1-colorings which are *new* (Eq. 8).

`count_origins(n)` computes the total number of 1-to-$n$-colorings which are reversible to no actions (Table I).

`counting_states2(n)` for $n =\:4,\:5,\:6$ is an exhaustive enumeration of the strongly connected 1-colorings (Section 6).

`find_origins(n,'m',m)` computes the numbers $\Omega^n\left(m\right)$ and $B_1^n\left(m\right)$ of the number of $m$-colorings that can reversibly reach 1-colorings, and the convergence of allowed 1-colorings onto n-colorings (Section 4, Eqs. 6 and 7).

`k_from_above1(n)` creates a table of the numbers of m-colorings reachable from above in the n-network from old 1-colorings (Table 5).

`old_onecolorings(n)` estimates the numbers of old $n-k$-colorings colorings that must be used to reach $m$-colorings in the $n$-network (Eq. 6, Table 6).

`possiblestates2(n)` generates all the connected 1-colorings of the $n$-network.

`reversible_actions(n,q,r)` computes the number $\varphi_n^q\left(\mathfrak{P}_k\right)$ of configurations in the n-network using colors in the st `q` which are reversible to k-letter words $\mathfrak{P}_k$, listed in the $k$-column matrix `r` (Eq. 4).

