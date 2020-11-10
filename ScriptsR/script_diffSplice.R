diff <- read.delim("~/Desktop/MN4/Resultados/Tablas/diff_empirical.dpsi")
names(diff) <- c("Event_ID", "dpsi", "pval")
diff$gene <- sub(";.*", "", diff$Event_ID)
diff$event <- sub(".*;", "", diff$Event_ID)
View(diff)
diff <- diff[!is.nan(diff$dpsi), ]
diff <- diff[!is.na(diff$dpsi), ]
diff$padj <- p.adjust(diff$pval, method="BH")
diff_dpsi <- diff[diff$padj < 0.05, ]
View(diff_dpsi)
write.table(diff, file = "~/Desktop/MN4/Resultados/diffSplicing_empirical.txt", sep = "\t", col.names = TRUE, row.names = TRUE)