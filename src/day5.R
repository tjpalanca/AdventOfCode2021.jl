# Libraries ---------------------------------------------------------------
library(purrr)
library(stringr)
library(magrittr)
library(tidyr)
library(dplyr)

# Functions ---------------------------------------------------------------

# Convenience
x1 <- \(l) l[[1]][1]
x2 <- \(l) l[[2]][1]
y1 <- \(l) l[[1]][2]
y2 <- \(l) l[[2]][2]
px <- \(l) x1(l):x2(l)
py <- \(l) y1(l):y2(l)
dx <- \(l) x1(l) - x2(l)
dy <- \(l) y1(l) - y2(l)

# Expand a line into integer points
points <- function(line) {
  if (x1(line) == x2(line))
    map(py(line), ~c(x1(line), .))
  else if (y1(line) == y2(line))
    map(px(line), ~c(., y1(line)))
  else if (abs(dx(line)) == abs(dy(line)))
    map2(px(line), py(line), ~c(.x, .y))
  else
    stop("Must only be horizontal, vertical, or 45 diagonal")
}

# Get overlapping points between two lines
overlaps <- function(l1, l2) {
  intersect(points(l1), points(l2))
}

# Counting of overlaps
count_overlaps <- function(set) {
  combn(set, 2) %>%
    { tibble(line1 = .[1,], line2 = .[2,]) } %>%
    mutate(overlaps = map2(line1, line2, overlaps)) %>%
    filter(map_lgl(overlaps, ~length(.) > 0)) %>%
    pull(overlaps) %>%
    flatten() %>%
    n_distinct()
}

# Execute -----------------------------------------------------------------

# Parse the inputs
lines <-
  readLines("data/day5.txt") %>%
  map(str_split, " -> ") %>%
  map(extract2, 1) %>%
  map(function(line) {
    map(
      line,
      function(point) as.integer(str_split(point, ",")[[1]])
    )
  })

# Horizontal and Vertical Lines only
plines <- keep(lines, ~x1(.) == x2(.) | y1(.) == y2(.))

# Part 1 Answer: Number of Points with overlaps
part1_ans <- count_overlaps(plines)

# Part 2 Answer: Number of Points with overlaps (diagonals included)
part2_ans <- count_overlaps(lines)
