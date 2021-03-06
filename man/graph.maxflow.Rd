\name{max_flow}
\alias{graph.maxflow}
\alias{max_flow}
\alias{graph.mincut}
\alias{min_cut}
\concept{Maximum flow}
\concept{Minimum cut}
\title{Maximum flow in a network}
\description{In a graph where each edge has a given flow capacity the
  maximal flow between two vertices is calculated.}
\usage{
max_flow(graph, source, target, capacity=NULL)
min_cut(graph, source=NULL, target=NULL, capacity=NULL,
       value.only = TRUE)
}
\arguments{
  \item{graph}{The input graph.}
  \item{source}{The id of the source vertex.}
  \item{target}{The id of the target vertex (sometimes also called sink).}
  \item{capacity}{Vector giving the capacity of the edges. If this is
    \code{NULL} (the default) then the \code{capacity} edge attribute is
    used.}
  \item{value.only}{Logical scalar, if \code{TRUE} only the minumum cut
    value is returned, if \code{FALSE} the edges in the cut and a the
    two (or more) partitions are also returned.
  }
}
\details{
  \code{max_flow} calculates the maximum flow between two vertices
  in a weighted (ie. valued) graph. A flow from \code{source} to
  \code{target} is an assignment of non-negative real numbers to the
  edges of the graph, satisfying two properties: (1) for each edge the
  flow (ie. the assigned number) is not more than the capacity of the
  edge (the \code{capacity} parameter or edge attribute), (2) for every
  vertex, except the source and the target the incoming flow is the same
  as the outgoing flow. The value of the flow is the incoming flow of
  the \code{target} vertex. The maximum flow is the flow of maximum
  value.

  \code{min_cut} calculates the minimum st-cut between two vertices
  in a graph (if the \code{source} and \code{target} arguments are
  given) or the minimum cut of the graph (if both \code{source} and
  \code{target} are \code{NULL}).

  The minimum st-cut between \code{source} and \code{target} is the
  minimum total weight of edges needed to remove to eliminate all paths from
  \code{source} to \code{target}.

  The minimum cut of a graph is the minimum total weight of the edges
  needed to remove to separate the graph into (at least) two
  components. (Which is to make the graph \emph{not} strongly connected
  in the directed case.)
  
  The maximum flow between two vertices in a graph is the same as the minimum
  st-cut, so \code{max_flow} and \code{min_cut} essentially
  calculate the same quantity, the only difference is that
  \code{min_cut} can be invoked without giving the \code{source}
  and \code{target} arguments and then minimum of all possible minimum
  cuts is calculated.

  For undirected graphs the Stoer-Wagner algorithm (see reference below)
  is used to calculate the minimum cut.
}
\value{
  For \code{max_flow} a named list with components:
  \item{value}{A numeric scalar, the value of the maximum flow.}
  \item{flow}{A numeric vector, the flow itself, one entry for each
    edge. For undirected graphs this entry is bit trickier,
    since for these the flow direction is not predetermined by
    the edge direction. For these graphs the elements of the
    this vector can be negative, this means that the flow
    goes from the bigger vertex id to the smaller one. Positive
    values mean that the flow goes from the smaller vertex id to
    the bigger one.}
  \item{cut}{A numeric vector of edge ids, the minimum cut corresponding
    to the maximum flow.}
  \item{partition1}{A numeric vector of vertex ids, the vertices in the
    first partition of the minimum cut corresponding to the maximum
    flow.}
  \item{partition2}{A numeric vector of vertex ids, the vertices in the
    second partition of the minimum cut corresponding to the maximum
    flow.}
  \item{stats}{A list with some statistics from the push-relabel
    algorithm. Five integer values currently: \code{nopush} is the
    number of push operations, \code{norelabel} the number of
    relabelings, \code{nogap} is the number of times the gap heuristics
    was used, \code{nogapnodes} is the total number of gap nodes omitted
    because of the gap heuristics and \code{nobfs} is the number of
    times a global breadth-first-search update was performed to assign
    better height (=distance) values to the vertices.}
  
  For \code{min_cut} a numeric constant, the value of the minimum
  cut, except if \code{value.only=FALSE}. In this case a named list with
  components:
  \item{value}{Numeric scalar, the cut value.}
  \item{cut}{Numeric vector, the edges in the cut.}
  \item{partition1}{The vertices in the first partition after the cut
    edges are removed. Note that these vertices might be actually in
    different components (after the cut edges are removed), as the
    graph may fall apart into more than two components.}
  \item{partition2}{The vertices in the second partition after the cut
    edges are removed. Note that these vertices might be actually in
    different components (after the cut edges are removed), as the
    graph may fall apart into more than two components.}
}
\references{
  A. V. Goldberg and R. E. Tarjan: A New Approach to the Maximum Flow
  Problem \emph{Journal of the ACM} 35:921-940, 1988.
  
  M. Stoer and F. Wagner: A simple min-cut algorithm, \emph{Journal of
  the ACM}, 44 585-591, 1997.
}
\author{Gabor Csardi \email{csardi.gabor@gmail.com}}
\seealso{\code{\link{distances}}, \code{\link{edge_connectivity}},
  \code{\link{vertex_connectivity}}}
\examples{
E <- rbind( c(1,3,3), c(3,4,1), c(4,2,2), c(1,5,1), c(5,6,2), c(6,2,10))
colnames(E) <- c("from", "to", "capacity")
g1 <- graph_from_data_frame(as.data.frame(E))
max_flow(g1, source=V(g1)["1"], target=V(g1)["2"])

g <- make_ring(100)
min_cut(g, capacity=rep(1,vcount(g)))
min_cut(g, value.only=FALSE, capacity=rep(1,vcount(g)))

g2 <- graph( c(1,2,2,3,3,4, 1,6,6,5,5,4, 4,1) )
E(g2)$capacity <- c(3,1,2, 10,1,3, 2)
min_cut(g2, value.only=FALSE)
}
\keyword{graphs}
