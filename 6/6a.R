#!/usr/bin/Rscript

write(paste(apply(do.call(rbind, strsplit(readLines("stdin"), "")), 2, function(col) { names(which.max(table(col))) }), collapse = ""), stderr())
