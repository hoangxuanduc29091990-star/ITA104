--3
SELECT 
    ma_don_hang AS order_id, 
    TO_CHAR(ngay_thang_nam, 'DD/MM/YYYY') AS formatted_order_date
FROM don_hang
WHERE EXTRACT(YEAR FROM ngay_thang_nam) = 2025 
  AND EXTRACT(MONTH FROM ngay_thang_nam) = 10;