--Inner Join
SELECT 
    ct.ma_don_hang AS order_id, 
    sp.ten_sp AS product_name, 
    ct.so_luong AS quantity, 
    ct.tong_tien_tai_thoi_diem_ban AS price
FROM chi_tiet_don_hang ct
INNER JOIN san_pham sp 
ON ct.ma_sp = sp.ma_sp;
--Left join
SELECT 
    kh.ten AS full_name, 
    dh.ma_don_hang AS order_id
FROM khach_hang kh
LEFT JOIN don_hang dh 
ON kh.ma_kh = dh.ma_kh
ORDER BY kh.ma_kh;
--Right JOIN
SELECT 
    sp.ten_sp AS product_name, 
    ct.ma_don_hang AS order_id
FROM chi_tiet_don_hang ct
RIGHT JOIN san_pham sp ON ct.ma_sp = sp.ma_sp;
--Union
SELECT 
    ten AS ContactName, 
    sdt AS PhoneNumber
FROM khach_hang

UNION

SELECT 
    ten_nha_cung_cap AS ContactName, 
    sdt_lien_lac AS PhoneNumber
FROM nha_cung_cap;

--Subquery với IN Lọc sản phẩm theo tên Nhà cung cấp
SELECT 
    ten_sp AS product_name, 
    don_gia AS price
FROM san_pham
WHERE ma_nha_cung_cap IN (
    SELECT ma_nha_cung_cap 
    FROM nha_cung_cap 
    WHERE ten_nha_cung_cap = 'Công ty Sữa Việt Nam'
);

--Subquery trong SELECT So sánh giá từng món với giá trung bình
SELECT 
    ten_sp AS product_name, 
    don_gia AS price,
    (SELECT ROUND(AVG(don_gia), 2) FROM san_pham) 
	AS average_price
FROM san_pham;

--(Subquery trong FROM) Tìm các đơn hàng có tổng trị giá > 50,000đ
SELECT 
    temp_table.ma_don_hang AS order_id, 
    temp_table.tong_gia_tri
FROM (
    SELECT 
        ma_don_hang, 
        SUM(tong_tien_tai_thoi_diem_ban) 
		AS tong_gia_tri
    FROM chi_tiet_don_hang
    GROUP BY ma_don_hang
) 
AS temp_table
WHERE temp_table.tong_gia_tri > 50000;

-- (EXISTS) Liệt kê nhà cung cấp có sản phẩm trong kho
SELECT 
    ncc.ten_nha_cung_cap AS supplier_name
FROM nha_cung_cap ncc
WHERE EXISTS (
    -- Kiểm tra xem có sản phẩm nào thuộc nhà cung cấp này không
    SELECT 1 
    FROM san_pham sp 
    WHERE sp.ma_nha_cung_cap = ncc.ma_nha_cung_cap
);