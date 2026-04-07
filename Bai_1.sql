-- 1
SELECT
    COUNT(ma_sp) AS SoLuongSanPham,
    ROUND(AVG(don_gia), 2) AS GiaTrungBinh,
    MIN(don_gia) AS GiaReNhat,
    MAX(don_gia) AS GiaDatNhat
FROM san_pham ;
