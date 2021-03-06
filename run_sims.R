
.args <- c("simulator.R", "1.5", "0.58", "2", "1e3", "thing.rds")
.args <- commandArgs(trailingOnly = TRUE)

source(.args[1])
R <- as.numeric(.args[2])
k <- as.numeric(.args[3])
crs <- as.integer(.args[4])
n <- as.integer(.args[5])
setDTthreads(crs)

tarout <- tail(.args, 1)

max_size <- 14962 # TODO: compute this
min_size <- max_size
si <- function(x,
  mlog=log((4.7^2)/(sqrt(2.9^2 + 4.7^2))),
  sdlog=sqrt(log(1 + (2.9^2/(4.7^2))))
) round(rlnorm(x, meanlog = mlog, sdlog = sdlog))

tree <- min_tree_quick(
  n=n, target_cases = max_size,
  offspring="nbinom", mu = R, size = k,
  serial = si, chain_times = "non-overlap"
)

saveRDS(tree, tarout)