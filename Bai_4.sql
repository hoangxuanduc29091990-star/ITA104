--4
SELECT 
    kh.ten AS full_name, 
    SUM(ct.tong_tien_tai_thoi_diem_ban) AS tong_chi_tieu
FROM khach_hang kh
INNER JOIN don_hang dh ON kh.ma_kh = dh.ma_kh
INNER JOIN chi_tiet_don_hang ct ON dh.ma_don_hang = ct.ma_don_hang
GROUP BY kh.ten
HAVING SUM(ct.tong_tien_tai_thoi_diem_ban) > 100000
ORDER BY tong_chi_tieu DESC;