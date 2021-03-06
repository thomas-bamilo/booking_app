pivot_ledger_seller_voucher_f <- function(df_no_missing_ledger) {
  
  
  
  # only keep columns necessary for pivot
  df_no_missing_ledger <- data.frame('seller_name' = df_no_missing_ledger$seller_name
                                      ,'short_code' = df_no_missing_ledger$short_code
                                      ,'ledger' = df_no_missing_ledger$ledger
                                      ,'subledger' = df_no_missing_ledger$subledger
                                      ,'paid_price' = df_no_missing_ledger$paid_price
                                      ,'voucher'= df_no_missing_ledger$voucher)
  
  
  
  # group Paid Amount by Seller Name, ledger and subledger
  df_pivoted <- data.table(df_no_missing_ledger)
  df_pivoted <- df_pivoted[, .(sum(paid_price)), by=list(short_code,ledger,subledger)]
  df_pivoted <- data.frame(df_pivoted)
  names(df_pivoted)[4] <- 'paid_price'
  
  # pivot ledger and subledger
  df_pivoted <- cast(df_pivoted, short_code ~ ledger + subledger, value = 'paid_price')
  
  # group voucher by short_code
  voucher_by_short_code <- data.table(df_no_missing_ledger)
  voucher_by_short_code <- voucher_by_short_code[, .(sum(voucher)), by=list(short_code)]
  voucher_by_short_code <- data.frame(voucher_by_short_code)
  names(voucher_by_short_code)[2] <- '62002'
  
  # merge df_pivoted with voucher_by_short_code on Seller Name
  df_final_pivot <- merge(df_pivoted,voucher_by_short_code, by = 'short_code', all.x = TRUE)
  
  
  df_final_pivot[is.na(df_final_pivot)] <- 0
  
  return(df_final_pivot)
  
  
  
  
}