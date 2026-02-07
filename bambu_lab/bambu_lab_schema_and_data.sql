-- =====================================================
-- Project: Bambu Lab Store Database
-- File: bambu_lab_schema_and_data.sql
-- Purpose: Practice relational database design and data population
-- =====================================================

-- Focus / Skills Practiced:
-- 1. Database schema design (tables, primary keys, foreign keys)
-- 2. Many-to-many and one-to-many relationships
-- 3. Constraints (PK, FK, uniqueness)
-- 4. Stored procedures for controlled inserts
-- 5. Manual data seeding and validation

-- Notes:
-- - All tables and procedures were created manually
-- - Procedures include checks to prevent duplicate entries
-- - Data inserted is sample/test data to simulate real usage
-- - This file is self-contained; running it creates the full database

-- ======================
-- DATABASE CREATION
-- ======================

create database Bambu_Lab_DB
use Bambu_Lab_DB

-- ======================
-- TABLE DEFINITIONS
-- ======================

create table Store (
STId int primary key identity,
StoreName varchar (255),
StoreLocation varchar (255)
);
create table Employee (
EId int primary key identity,
EmployeeName varchar (255),
STId int foreign key references Store(STId)
);
create table Manager (
MId int foreign key references Store(STId),
ManagerName varchar (255),
ManagerXP varchar (255),
constraint pk_Manager primary key (MId)
);
create table Client (
CId int primary key identity,
ClientName varchar (255),
ClientBirthDate varchar (255),
);
create table Printer (
PId int primary key identity,
PrinterName varchar (255),
PrinterYear varchar (255),
PrinterPrice int
);
create table Color (
CLId int primary key identity,
ColorName varchar (255),
ColorAspect varchar (255)
);
create table Filament (
FId int primary key identity,
FilamentType varchar (255),
FilamentSubType varchar (255),
FilamentTemp int,
CLId int foreign key references Color(CLId)
);
create table Accessory (
AId int primary key identity,
AccCategory varchar (255),
AccType varchar (255),
PId int foreign key references Printer(PId)
);
create table Store_Printer (
STId int foreign key references Store(STId),
PId int foreign key references Printer(PId),
Available varchar (255),
Discount int
constraint pk_StorePrinter primary key (STId, PId)
);
create table Store_Accesory (
STId int foreign key references Store(STId),
AId int foreign key references Accessory(AId),
Available varchar (255),
Discount int
constraint pk_Store_Accesory primary key (STId, AId)
);
create table Client_Printer (
CId int foreign key references Client(CId),
PId int foreign key references Printer(PId),
BuyDate varchar (255),
constraint pk_Client_Printer primary key (CId, PId)
);
create table Store_Filament (
STId int foreign key references Store(STId),
FId int foreign key references Filament(FId),
Available varchar (255),
Discount int,
constraint pk_Store_Filament primary key (STId, FId)
);
create table Filament_Printer (
PId int foreign key references Printer(PId),
FId int foreign key references Filament(FId),
constraint pk_Filament_Printer primary key (PId, FId)
);

-- ======================================
-- STORED PROCEDURES + DATA INSERTION
-- ======================================

create procedure AddPrinter (@PrinterName varchar (255), @PrinterYear varchar (255), @PrinterPrice int)
as
begin
	if not exists(select * from Printer where PrinterName = @PrinterName)
		insert into Printer values (@PrinterName, @PrinterYear, @PrinterPrice)
	else
		raiserror ('Printer already exists',11,1)
end
go
exec AddPrinter 'Bambu Lab A1 mini', '2023', 489
exec AddPrinter 'Bambu Lab A1', '2023', 599
exec AddPrinter 'Bambu Lab P1P', '2023', 779
exec AddPrinter 'Bambu Lab P1S', '2023', 999
exec AddPrinter 'Bambu Lab X1-Carbon', '2022', 1629
select * from Printer

create procedure AddColor (@ColorName varchar (255), @ColorAspect varchar (255))
as
begin
	if not exists (select * from Color where ColorName = @ColorName and ColorAspect = @ColorAspect)
	insert into Color values (@ColorName , @ColorAspect)
	else
	raiserror ('Combination already exists',11,1)
end
go
exec AddColor 'Red' , 'Basic'
exec AddColor 'Blue' , 'Basic'
exec AddColor 'Green' , 'Basic'
exec AddColor 'White' , 'Basic'
exec AddColor 'Yellow' , 'Basic'
exec AddColor 'Purple' , 'Basic'
exec AddColor 'Red' , 'Matte'
exec AddColor 'Blue' , 'Matte'
exec AddColor 'Green' , 'Matte'
exec AddColor 'White' , 'Matte'
exec AddColor 'Yellow' , 'Matte'
exec AddColor 'Purple' , 'Matte'
exec AddColor 'Red' , 'Glow'
exec AddColor 'Blue' , 'Glow'
exec AddColor 'Green' , 'Glow'
exec AddColor 'White' , 'Glow'
exec AddColor 'Yellow' , 'Glow'
exec AddColor 'Purple' , 'Glow'
exec AddColor 'Red' , 'Galaxy'
exec AddColor 'Blue' , 'Galaxy'
exec AddColor 'Green' , 'Galaxy'
exec AddColor 'White' , 'Galaxy'
exec AddColor 'Yellow' , 'Galaxy'
exec AddColor 'Purple' , 'Galaxy'
exec AddColor 'Red' , 'Silk'
exec AddColor 'Blue' , 'Silk'
exec AddColor 'Green' , 'Silk'
exec AddColor 'White' , 'Silk'
exec AddColor 'Yellow' , 'Silk'
exec AddColor 'Purple' , 'Silk'
select * from Color

alter procedure AddFilament (@Type varchar (255), @SubType varchar (255), @Temp int, @Color varchar(255), @ColorType varchar (255))
as
begin
declare @ColorID int

	if exists (select * from Color where ColorName = @Color)
	begin
		select @ColorID = CLId from Color where ColorName = @Color and ColorAspect = @ColorType
		if not exists (select * from Filament where FilamentType = @Type and FilamentSubType = @SubType and CLId = @ColorID)
		insert into Filament values (@Type, @SubType, @Temp, @ColorID)
		else
		raiserror ('Filament already exists',11,1)
	end
	else
		raiserror ('Color does not exist',11,1)
end
go
exec AddFilament 'Plastic', 'PLA', 200, 'Red','Basic'
exec AddFilament 'Plastic', 'PLA', 200, 'Red','Matte'
exec AddFilament 'Plastic', 'PLA', 200, 'Red','Glow'
exec AddFilament 'Plastic', 'PLA', 200, 'Red','Galaxy'
exec AddFilament 'Plastic', 'PLA', 200, 'Red','Silk'
exec AddFilament 'Plastic', 'PLA', 200, 'Blue','Basic'
exec AddFilament 'Plastic', 'PLA', 200, 'Blue','Matte'
exec AddFilament 'Plastic', 'PLA', 200, 'Blue','Glow'
exec AddFilament 'Plastic', 'PLA', 200, 'Blue','Galaxy'
exec AddFilament 'Plastic', 'PLA', 200, 'Blue','Silk'
exec AddFilament 'Plastic', 'PLA', 200, 'Green','Basic'
exec AddFilament 'Plastic', 'PLA', 200, 'Green','Matte'
exec AddFilament 'Plastic', 'PLA', 200, 'Green','Glow'
exec AddFilament 'Plastic', 'PLA', 200, 'Green','Galaxy'
exec AddFilament 'Plastic', 'PLA', 200, 'Green','Silk'
exec AddFilament 'Plastic', 'PLA', 200, 'White','Basic'
exec AddFilament 'Plastic', 'PLA', 200, 'White','Matte'
exec AddFilament 'Plastic', 'PLA', 200, 'White','Glow'
exec AddFilament 'Plastic', 'PLA', 200, 'White','Galaxy'
exec AddFilament 'Plastic', 'PLA', 200, 'White','Silk'
exec AddFilament 'Plastic', 'PLA', 200, 'Yellow','Basic'
exec AddFilament 'Plastic', 'PLA', 200, 'Yellow','Matte'
exec AddFilament 'Plastic', 'PLA', 200, 'Yellow','Glow'
exec AddFilament 'Plastic', 'PLA', 200, 'Yellow','Galaxy'
exec AddFilament 'Plastic', 'PLA', 200, 'Yellow','Silk'
exec AddFilament 'Plastic', 'PLA', 200, 'Purple','Basic'
exec AddFilament 'Plastic', 'PLA', 200, 'Purple','Matte'
exec AddFilament 'Plastic', 'PLA', 200, 'Purple','Glow'
exec AddFilament 'Plastic', 'PLA', 200, 'Purple','Galaxy'
exec AddFilament 'Plastic', 'PLA', 200, 'Purple','Silk'
exec AddFilament 'Plastic', 'PETG', 225, 'Red','Basic'
exec AddFilament 'Plastic', 'PETG', 225, 'Blue','Basic'
exec AddFilament 'Plastic', 'PETG', 225, 'Green','Basic'
exec AddFilament 'Plastic', 'PETG', 225, 'White','Basic'
exec AddFilament 'Plastic', 'PETG', 225, 'Yellow','Basic'
exec AddFilament 'Plastic', 'PETG', 225, 'Purple','Basic'
exec AddFilament 'Support', 'PVA', 250, 'White','Basic'
exec AddFilament 'Support', 'PLA/PETG', 250, 'White','Basic'
exec AddFilament 'Support', 'PLA', 250, 'White','Basic'
exec AddFilament 'Fiber Reinforced', 'PLA-CF', 210, 'White','Basic'
exec AddFilament 'Fiber Reinforced', 'PLA-CF', 210, 'Red','Basic'
exec AddFilament 'Fiber Reinforced', 'PLA-CF', 210, 'Blue','Basic'
exec AddFilament 'Fiber Reinforced', 'PLA-CF', 210, 'Purple','Basic'
exec AddFilament 'Fiber Reinforced', 'PETG-CF', 215, 'White','Basic'
exec AddFilament 'Fiber Reinforced', 'PETG-CF', 215, 'Red','Basic'
exec AddFilament 'Fiber Reinforced', 'PETG-CF', 215, 'Blue','Basic'
exec AddFilament 'Fiber Reinforced', 'PETG-CF', 215, 'Purple','Basic'

select * from Filament

create procedure AddStore (@StoreName varchar (255), @StoreLocation varchar (255))
as
begin
	if not exists (select * from Store where StoreName = @StoreName and StoreLocation = @StoreLocation)
		insert into Store values (@StoreName, @StoreLocation)
	else
		raiserror ('Store already exists',11,1)
end
go
exec AddStore 'Bambu Lab', 'Shenzhen, China'
exec AddStore 'Bambu Lab', 'Shanghai, China'
exec AddStore 'Bambu Lab', 'Austin, Texas'
exec AddStore 'Bambu Lab', 'Online'
select * from Store

alter procedure AddEmployee (@EmplyeeName varchar (255), @StoreName varchar (255), @StoreLocation varchar(255))
as
begin
declare @Store int
	if exists (select * from Store where StoreName = @StoreName and StoreLocation = @StoreLocation)
		begin
			select @Store = STId from Store where StoreName = @StoreName and StoreLocation = @StoreLocation
			insert into Employee values (@EmplyeeName, @Store)
		end
		else
			raiserror ('Store does not exists',11,1)
end
go
exec AddEmployee 'Noah', 'Bambu Lab', 'Shenzhen, China'
exec AddEmployee 'Olivia', 'Bambu Lab', 'Shenzhen, China'
exec AddEmployee 'Liam', 'Bambu Lab', 'Shenzhen, China'
exec AddEmployee 'Amelia', 'Bambu Lab', 'Shenzhen, China'
exec AddEmployee 'Oliver', 'Bambu Lab', 'Shanghai, China'
exec AddEmployee 'Emma', 'Bambu Lab', 'Shanghai, China'
exec AddEmployee 'Elijah', 'Bambu Lab', 'Shanghai, China'
exec AddEmployee 'Sophia', 'Bambu Lab', 'Shanghai, China'
exec AddEmployee 'Mateo', 'Bambu Lab', 'Austin, Texas'
exec AddEmployee 'Charlotte', 'Bambu Lab', 'Austin, Texas'
exec AddEmployee 'Lucas', 'Bambu Lab', 'Austin, Texas'
exec AddEmployee 'Isabella', 'Bambu Lab', 'Austin, Texas'
exec AddEmployee 'Levi', 'Bambu Lab', 'Online'
exec AddEmployee 'Ava', 'Bambu Lab', 'Online'
exec AddEmployee 'Ezra', 'Bambu Lab', 'Online'
exec AddEmployee 'Mia', 'Bambu Lab', 'Online'
exec AddEmployee 'Asher', 'Bambu Lab', 'Online'
exec AddEmployee 'Luna', 'Bambu Lab', 'Online'
exec AddEmployee 'Leo', 'Bambu Lab', 'Online'
select * from Employee