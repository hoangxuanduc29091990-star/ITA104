--2
SELECT 
    ncc.ten_nha_cung_cap AS supplier_name, 
    COUNT(sp.ma_sp) AS tong_so_san_pham
FROM nha_cung_cap ncc
INNER JOIN san_pham sp ON ncc.ma_nha_cung_cap = sp.ma_nha_cung_cap
GROUP BY ncc.ten_nha_cung_cap
HAVING COUNT(sp.ma_sp) > 1;