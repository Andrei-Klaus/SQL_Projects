-- =====================================================
-- Project: TeaShop Database
-- File: tea_shop_schema_and_data.sql
-- Purpose: Practice relational database design, many-to-many relationships, and stored procedures
-- =====================================================

-- Skills / Highlights:
-- 1. Tables with primary keys and foreign keys
-- 2. One-to-many (Shop → Manager) and many-to-many (Tea ↔ Shop) relationships
-- 3. Stored procedures with validation for inserts
-- 4. Sample data to demonstrate usage
-- 5. View to join Tea, Shop, and Manager for easy queries

create database TeaShop
use TeaShop

-- ======================
-- TABLE DEFINITIONS
-- ======================

create table Shop(
SHId int primary key identity,
ShopName varchar(225),
ShopCity varchar(225),
ShopCount int,
ShopClientCount int,
);

create table Tea(
TId int primary key identity, 
TeaName varchar(225),
TeaQuantity int,
TeaPrice int,
TTId int foreign key references TeaType(TTId),
);

create table TeaType(
TTId int primary key identity,
TeaTypeName varchar(225),
NoOfTeas int,
);

create table Manager(
MId int foreign key references Shop(SHId),
ManagerName varchar(225),
XP int,
constraint pk_Manager primary key(MId) 
);

create table Tea_Shop(
TId int foreign key references Tea(TId),
SHId int foreign key references Shop(SHId),
constraint pk_Tea_Shop primary key (TId, SHId)
);


-- ======================
-- STORED PROCEDURES
-- ======================

create procedure AddTeaType (@TeaType varchar(225), @NoOfTea int)
as
begin
	if not exists(select TeaTypeName from TeaType where TeaTypeName = @TeaType)
		insert into TeaType values (@TeaType, @NoOfTea)
	else
		raiserror ('TeaType already exists in the DB',11,1)
end
go
/*exec AddTeaType 'Green Tea', '23'
exec AddTeaType 'Black Tea', '25'
exec AddTeaType 'White Tea', '8'
exec AddTeaType 'Oolong Tea', '2'
exec AddTeaType 'Herbal Tea', '15'*/
create procedure AddTea (@TeaName varchar(225), @TeaQuantity int, @TeaPrice int, @TeaType varchar(225))
as
begin
declare @TTId int
	if exists(select TTId from TeaType where TeaTypeName = @TeaType)
	begin
		select @TTId = TTId from TeaType where TeaTypeName = @TeaType
		insert into Tea values (@TeaName, @TeaQuantity, @TeaPrice, @TTId)
	end
	else
	raiserror ('TeaType does not exist',11,1)
end
go
/*exec AddTea 'GunPowder','12','20','Green Tea'
exec AddTea 'Jin Shan','3','40','Green Tea'
exec AddTea 'Hojicha','29','`15','Green Tea'
exec AddTea 'Assam','78','10','Black Tea'
exec AddTea 'Wakuocha','1','58','Black Tea'
exec AddTea 'Da Hong Pao','10','5','White Tea'
exec AddTea 'Gong Mei','17','13','White Tea'*/
update Tea
set TeaName = 'Bamboo', TeaQuantity = 15, TeaPrice =2, TTId = 5
where TId = 2

select * from Tea

create procedure AddShop (@ShopName varchar(225), @City varchar(225), @Count int, @ClientCount int)
as
begin
	if not exists(select ShopName from Shop where ShopCity = @City and ShopName = @ShopName)
	insert into Shop values (@ShopName, @City, @Count, @ClientCount)
	else
	raiserror ('Shop existing already in this city',11,1)
end
go
exec AddShop 'Zireto', 'Botosani', 4, 75
exec AddShop '5ToGo', 'Botosani', 8, 46
exec AddShop '5ToGo', 'Cluj-Napoca', 11, 122
exec AddShop 'Gloria', 'Cluj-Napoca', 1, 150
select * from Shop

create procedure AddManager (@ManagerName varchar(225), @xp int, @ShopName varchar(225), @ShopCity varchar(225))
as
begin
declare @MId int
select @MId = SHId from Shop where ShopName = @ShopName and ShopCity=@ShopCity
	if not exists (select ShopName from Shop where ShopCity = @ShopCity and ShopName = @ShopName)
		raiserror ('Shop does not exist in this City',11,1)
	else
	begin
		if not exists (select * from Manager where MId = @MId)
			insert into Manager values (@MId, @ManagerName, @xp)
		else
			raiserror ('This Shop already has a manager',11,1)
	end
	
end
go
exec AddManager 'Andrei', 2, 'Zireto', 'Botosani'
exec AddManager 'Andrei', 2, 'Gloria', 'Cluj-Napoca'
select * from Manager
select * from Tea_Shop
create procedure AddTeaShop (@TeaName varchar(225), @ShopName varchar(225), @ShopCity varchar (225))
as
begin
declare @TId int, @SHId int
select @TId = TId from Tea where TeaName = @TeaName
select @SHId = SHId from Shop where ShopName = @ShopName and ShopCity = @ShopCity
	if not exists (select * from Tea where TeaName = @TeaName)
		raiserror ('Tea does not exist',11,1)
	else
	begin
		if not exists (select ShopName from Shop where ShopCity = @ShopCity and ShopName = @ShopName)
			raiserror ('Shop does not exist in this City',11,1)
		else
		begin
			if not exists (select * from Tea_Shop where TId = @TId and SHId = @SHId)
				insert into Tea_Shop values (@TId, @SHId)
			else
				raiserror ('This Shop has already this tea',11,1)
		end
	end
end
go

select * from Tea
select * from Shop
select * from Tea_Shop
exec AddTeaShop 'GunPowder', 'Zireto', 'Botosani'
exec AddTeaShop 'Assam', 'Gloria', 'Cluj-Napoca'
exec AddTeaShop 'Gong Mei', '5ToGo', 'Botosani'

-- ======================
-- VIEW: vw_tea_shop
-- ======================
-- Purpose: Combine Tea, Shop, and Manager in one query for easy reporting
-- Highlights:
-- 1. Joins multiple tables (Tea, Tea_Shop, Shop, Manager)
-- 2. Shows which shop has which tea and who manages it

alter view vw_tea_shop as
select T.TeaName, SH.ShopName, SH.ShopCity, M.ManagerName
from Tea T
inner join Tea_Shop TS
on T.TId = TS.TId
inner join Shop SH
on TS.SHId = SH.SHId
inner join Manager M
on SH.SHId = M.MId
select * from vw_tea_shop