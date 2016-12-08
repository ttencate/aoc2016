#!/usr/bin/Rscript

write(paste(apply(do.call(rbind, strsplit(readLines("stdin"), "")), 2, function(col) { names(which.min(table(col))) }), collapse = ""), stderr())
