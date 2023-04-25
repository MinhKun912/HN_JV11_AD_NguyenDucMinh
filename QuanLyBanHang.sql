CREATE DATABASE QuanLyBanHang;
USE QuanLyBanHang;
CREATE TABLE customer
(
 cID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 cname VARCHAR(60) NOT NULL,
 cAge  tinyint NOT NULL
);
CREATE TABLE `order`
(
 oId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 cID int,
 foreign key (cID) references customer(cID) ,
 oDate datetime ,
 oTotalPrice int 
);
CREATE TABLE product
(
    pId   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(30) NOT NULL,
    pPrice  INT
);

CREATE TABLE orderDetail
(
oId INT,
foreign key(oId)references `order`(oId),
pId int,
foreign key(pId) references product(pId),
orderQuantity INT
);

insert into customer (cname,cage) values
 ('Minh Quan',10),
 ('Ngoc Oanh',20),
 ('Hong Ha',50);

INSERT INTO `order` (cId, oDate)
VALUES 
(1, '2006-3-21'),
(2, '2006-3-23'),
(1, '2006-3-16');

INSERT INTO product
VALUES (1, 'May Giat', 3),
       (2, 'Tu lanh', 5),
       (3, 'Dieu hoa', 7),
       (4, 'QUAT', 1),
       (5, 'BE DIEN', 2);

INSERT INTO orderDetail 
VALUES (1, 1, 3),
       (1, 3, 7),
       (1, 4, 2),
       (2, 1, 1),
       (3, 1, 8),
       (2, 5, 4),
       (2, 3, 3);
-- 2.Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơntrong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóađơn mới hơn nằm trên
SELECT o.oId ,o.oDate,o.ototalPrice FROM `order` o;

-- 3.Hiển thị tên và giá của các sản phẩm có giá cao nhất 
SELECT pName,pPrice FROM product WHERE pPrice=(SELECT max(pPrice) FROM product);
-- 4.Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sảnphẩm được mua bởi các khách đó
SELECT  c.cname,p.pName from( (customer c 
JOIN `order` on c.cID=`order`.cId) 
JOIN orderdetail on `order`.oId=orderdetail.oId)
JOIN product p on p.pId=orderdetail.pId; 
-- 5.Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
SELECT * from customer WHERE cid not in (SELECT distinct  `order`.cid from `order`);
-- 6.Hiển thị chi tiết của từng hóa don
SELECT od.oid,o.odate,od.orderQuantity,P.pName,P.pPrice from orderDetail od JOIN `order` o  on od.oid=o.oid
join product P on P.pid=od.pid
;
-- 7.Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn giá mộthóa đơn được tính bằng tổng giá bán của từng loại mặt hàng
SELECT o.oid,o.odate,  SUM(orderQuantity*pPrice) AS'Tong' from orderDetail od JOIN `order` o  on od.oid=o.oid
join product on product.pid=od.pid  group by o.oid
;
-- 8.alter
CREATE VIEW sales_view AS  SELECT SUM(orderQuantity*pPrice) AS 'sales'  FROM orderdetail JOIN product on orderdetail.pId=product.pId ;
-- 9.Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng
ALTER TABLE `order`
DROP CONSTRAINT order_ibfk_1;

ALTER TABLE orderdetail
DROP CONSTRAINT orderdetail_ibfk_1,
DROP CONSTRAINT orderdetail_ibfk_2;

-- 10.Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo
DELIMITER //
CREATE TRIGGER cusUpdate AFTER UPDATE ON customer
FOR EACH ROW
begin 
UPDATE `order`
SET cId=NEW.cId
WHERE cId=OLD.cId;
END //
DELIMITER ;
-- 11.Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của 
-- một sản phẩm, strored procedure này sẽ xóa sản phẩm có tên được truyên 
-- vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong 
-- bảng OrderDetail

DELIMITER //
CREATE PROCEDURE delProduct
(IN pName varchar(30))
BEGIN
DELETE FROM product WHERE product.pName=pName;
DELETE FROM orderdetail WHERE orderdetail.pName=pName;
END //
DELIMITER ;
