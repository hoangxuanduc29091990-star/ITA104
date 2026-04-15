-- Bài 1: so sánh window function với group by
-- group by
select product_name, avg(current_price) as avg_price
from sanpham
group by product_name;
-- vđ nhận thấy: vì mỗi tên sản phẩm trong siêu thị thường là duy nhất, lệnh group by sẽ nhóm từng sản phẩm thành một nhóm riêng biệt.
-- do đó, giá trị 'avg(current_price' chỉ đơn giản là giá của chính sản phẩm đó, chữ không phải là giá trung bình của toang bộ sản phẩm
-- chúng ta không thể vừa giữ nguyên danh sách chi tiết các sản phẩm, vừa hiện thị một giá trị tổng hợp toàn cục trên cùng một dòng bằng 'group by' thông thường
-- window function
select
product_name,
current_price as price,
avg(current_price) over () as avg_overall_price
from sanpham;
-- so sánh: 'group by' gộp các dòng có cùng giá trị lại thành một dòng duy nhất, làm mất đi chi tiết của các dòng dữ liệu ban đầu
-- ngược lại, 'window function' 'over ()' tính toán giá trị trung bình trên toàn bộ tập dữ liệu (cửa sổ dữ liệu) nhưng không gộp hàng
-- Cách giải quyết: 'window function' cho phép giữ nguyên số lượng dòng ban đầu (danh sách từng sản phẩm) và "đính kèm" kết quả tính toán tổng hợp
-- (giá trung bình toàn siêu thị) vào một cột mới trên mỗi dòng đó

-- Bài 2: Phân tích trong từng nhóm với 'partition by'
select
category,
product_name,
current_price as price,
avg(current_price) over (partition by category) as avg_category_price
from sanpham;
-- giải thích thêm: mệnh đề 'partition by category' sẽ chia dữ liệu thành các "tiểu nhóm" (phân vùng) dựa trên danh mục
-- hàm 'avg()' lúc này sẽ chỉ tính trung bình giá của các sản phẩm nằm trong cùng một phân vùng đó, thay vì tính trên toàn bộ bảng

-- Bài 3: Xếp hạng sản phẩm
-- chuẩn bị (tạo dữ liệu trùng giá)
update sanpham
set current_price = 35000
where product_id in (1, 2);
-- thực hành (câu lệnh sql xếp hạng)
select
product_name,
current_price as price,
row_number() over (order by current_price desc) as row_num,
rank() over (order by current_price  desc) as rank_num,
dense_rank() over (order by current_price desc) as dense_rank_num
from sanpham
order by current_price desc;
-- khi có 2 sản phẩm cùng giá
--- 'row_number()' đánh số thứ tự tăng dần liên tục, nó không quan tâm giá có bằng nhau hay không, mỗi dòng là một số duy nhất
--- 'rank()' cấp cùng một thứ hạng cho các sản phẩm đồng giá, nhưng sẽ bỏ qua các thứ hạng tiếp theo. thứ hạng thứ 3 bị bỏ qua
--- 'dense_rank()' cấp cùng một thứ hạng cho các sản phẩm đồng giá, và không bỏ qua thứ hạng tiếp theo. các con số xếp hạng luôn nối tiếp nhau và dày đặc

-- Bài 4: tính tổng lũy kế doanh thu theo ngày
-- b1: tạo CTE (bảng tạm) tính doanh thu theo từng ngày
with daily_revenue as (
select
hd.order_date,
sum(cthd.quantity * cthd.purchase_price) as total_daily_revenue
from hoadon hd
join chitiethoadon cthd on hd.order_id = cthd.order_id
group by hd.order_date
)
-- b2: dùng 'window function' tính tổng doanh thu lũy kế
select
order_date,
total_daily_revenue,
sum(total_daily_revenue) over (order by order_date asc) as running_total_revenue
from daily_revenue
order by order_date asc;
-- giải thích: mệnh đề 'order by order_date' bên trong hàm 'over()' định hình "cửa sổ" tính toán chạy từ dòng đầu tiên (ngày cũ nhất) cho đến dòng hiện tại
-- nhờ đó, hàm 'sum()' sẽ cộng dồng doanh thu của các ngày lại với nhau tạo thành chuỗi tăng trưởng lũy kế
