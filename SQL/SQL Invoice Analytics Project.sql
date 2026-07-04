### Invoice Analytics Project ###
Create database invoice_analytics_db;
use invoice_analytics_db;
show databases;

Create table Header_data(Document_ID varchar(15) primary key, Invoice_ID varchar(15) unique, Vendor_Name varchar(100) not null,
Vendor_GSTIN varchar(15), Buyer_Name varchar(100), Invoice_Number varchar(30), Invoice_Date date, PO_Number varchar(30), Taxable_Amount decimal(12,2),
CGST_Amount decimal(12,2), SGST_Amount decimal(12,2), IGST_Amount decimal(12,2), Total_Amount decimal(12,2), Confidence_Score decimal(5,2),
OCR_Status varchar(20), Reconciliation_Status varchar(30), Processing_Time_Min int, Exception_Reason varchar(255));

describe Header_data;

create table Line_Items_data (Line_Item_ID int auto_increment primary key, Invoice_ID varchar(15) not null, Line_No int not null,
Item_Description varchar(100) not null, HSN_Code varchar(20), Quantity int, Unit_Price decimal(10,2), Tax_Rate decimal(5,2),
Line_Total_Amount decimal(12,2), PO_Match_Status varchar(30),
constraint FK_Invoice
foreign key (Invoice_ID)
references Header_data(Invoice_ID)
);

describe Line_Items_data;

## ---------------------------------------------------------------------------------------------------------------------  ##
use invoice_analytics_db;
## I have imported csv file into respective tables
select count(*) as Total_Header_Rows from header_data;

select count(*) as Total_Line_Items_Rows from line_items_data;

## Checking auto increment column Line_Item_ID
select * from line_items_data;

## This should return 7006, confirming that every line item belongs to a valid invoice.
select count(*) from header_data h join line_items_data l on h.Invoice_ID = l.Invoice_ID;

## -----------------------------------------------------------------------------------------------------------------  ##

## Display all records
select * from header_data;

## Display selected columns
select Invoice_ID,Vendor_Name, Buyer_Name, Total_Amount from header_data;

## Display first 10 columns
select * from header_data limit 10;

select distinct vendor_name from header_data;

select count(*) as Total_Invoices from header_data;

select sum(total_amount) as Total_Invoice_Amount from header_data;

select avg(total_amount) as Average_Invoice_Amount from header_data;

select max(total_amount) as Highest_Invoice_Amount from header_data;

select min(total_amount) as Lowest_Invoice_Amount from header_data;

select count(*) as Total_Line_Items from line_items_data;

## ------------------------------------ Filtering and Sorting -------------------------------------------- ##
use invoice_analytics_db;
##  Retrieve invoices whose value is greater than ₹3 lakh.
select * from header_data where total_amount >300000;

## Display invoices belonging to one vendor.
select * from header_data where vendor_name = "ABC Industries";

## Display only invoices where OCR processing was successful.
select * from header_data where OCR_Status = "Success";

## Retrieve invoices whose amount is between ₹1 lakh and ₹3 lakh.
select * from header_data where Total_amount between 100000 and 300000;

## Retrieve invoices for multiple vendors.
select * from header_data where vendor_name in ("ABC Industries", "Sunrise Traders", "Global Traders");

## Find vendor names beginning with the letter A.
select * from header_data where vendor_name like "A%";

## Find vendors whose names end with Ltd.
select * from header_data where vendor_name like "%Ltd";

## Display invoices from highest amount to lowest.
select invoice_id, vendor_name, total_amount from header_data order by total_amount desc;

## Display invoices from oldest to newest.
select invoice_id, invoice_date, total_amount from header_data order by invoice_date;

## Display the top 10 invoices by amount.
select invoice_id, vendor_name, total_amount from header_data order by total_amount desc limit 10;

###  -------------------------  Aggregate Functions and  GROUP BY  ------------------------------  ###
use invoice_analytics_db;
## Vendor-wise Invoice Count
select vendor_name, count(*) as Total_Invoices from header_data group by vendor_name;

## Vendor-wise Invoice Amount
select vendor_name, sum(total_amount) as Total_Invoice_Amount
from header_data group by vendor_name;

## Vendor-wise Average Invoice Amount
select vendor_name, avg(total_amount) as Average_Invoice_Amount
from header_data group by vendor_name;

## OCR Status Summary
select OCR_Status, count(*) as Total_Invoices
from header_data group by OCR_Status;

## Reconciliation Status Summary
select Reconciliation_Status, count(*) as Total_Invoices
from header_data group by Reconciliation_Status;

## Average Confidence Score by OCR Status
select OCR_Status, avg(confidence_score) as avg_confidence
from header_data group by OCR_Status;

## Highest Invoice Amount by Vendor
select vendor_name, max(total_amount) as Highest_Invoice_Amount
from header_data group by vendor_name;

## Lowest Invoice Amount by Vendor
select vendor_name, min(total_amount) as Lowest_Invoice_amount
from header_data group by vendor_name;

## Vendors having more than 100 invoices
select vendor_name, count(*) as Total_Invoices from header_data
group by vendor_name having count(*)>100;

## Top 5 Vendors by Invoice Amount
select vendor_name, sum(total_amount) as Total_Invoice_amount
from header_data group by vendor_name
order by total_invoice_amount desc limit 5;

## Most Purchased Items in line items table
select item_description, count(*) as Purchase_Count
from line_items_data
group by item_description
order by purchase_Count desc;


### -------------------------JOINS----------------------------------------------- ###
use invoice_analytics_db;
select * from header_data;
select * from line_items_data;

## Display Invoice Header and Line Item Details (using inner join)
select h.Invoice_ID, h.Vendor_name, h.Invoice_date, l.Line_no, l.Item_description, l.Quantity, l.Unit_Price, l.Line_total_amount
from header_data h
inner join line_items_data l
on h.invoice_id = l.invoice_id;

## Vendor-wise Line Items
select h.vendor_name, count(l.line_item_id) as Total_Line_Items
from header_data h
inner join line_items_data l
on h.invoice_id = l.invoice_id
group by h.vendor_name;

## Vendor-wise Purchase Amount
select h.vendor_name, sum(l.line_total_amount) as Total_Purchase
from header_data h
inner join line_items_data l
on h.invoice_id = l.invoice_id
group by h.vendor_name
order by Total_Purchase desc;

## Average Unit Price by Vendor
select h.vendor_name, avg(l.unit_price) as Average_Unit_Price
from header_data h
inner join line_items_data l
on h.invoice_id = l.invoice_id
group by h.vendor_name;

## Total Quantity Purchased by Vendor
select h.vendor_name, sum(l.quantity) as Total_Quantity
from header_data h
inner join line_items_data l
on h.invoice_id = l.invoice_id
group by h.vendor_name
order by Total_quantity desc;

## Most Purchased Item
select item_description, sum(quantity) as Total_Quantity
from line_items_data
group by item_description
order by Total_quantity desc;

## Highest Value in Line Item
select h.invoice_id, h.vendor_name, l.Item_description, l.line_total_amount
from header_data h
inner join line_items_data l
on h.invoice_id = l.invoice_id
order by l.line_total_amount desc limit 10;

## Invoice having Maximum Line Items
select h.invoice_id, h.vendor_name, count(l.line_no) as Total_items from header_data h
inner join line_items_data l
on h.invoice_id = l.invoice_id
group by h.invoice_id, h.vendor_name
order by Total_items desc limit 10;

## Average Quantity per Invoice
select h.invoice_id, avg(l.quantity) as Average_Quantity from header_data h 
inner join line_items_data l
on h.invoice_id = l.invoice_id
group by h.invoice_id;

## Vendor-wise Average Confidence Score
select vendor_name, avg(confidence_score) as Average_Confidence from header_data 
group by vendor_name 
order by Average_confidence desc;

## Display all invoices and available line items
SELECT
    h.Invoice_ID,
    h.Vendor_Name,
    l.Item_Description,
    l.Quantity
FROM Header_Data h
LEFT JOIN Line_Items_Data l
ON h.Invoice_ID = l.Invoice_ID;


###  ----------------- CASE STATEMENT, SUBQUERIES, EXISTS, NOT EXISTS ---------------------------  ###
use invoice_analytics_db;

## Categorize Invoice Amount
select Invoice_ID, Vendor_Name, Total_Amount,
	case
         when Total_Amount >= 300000 then "High Value"
         when Total_Amount >= 150000 then "Medium Value"
         else "Low Value"
	end as Invoice_category
from header_data;


## Confidence Score Category
select invoice_id, confidence_score,
	case
		when confidence_score >95 then "Excellent"
        when confidence_score >=85 then "Good"
        else "Needs Review"
	end as confidence_level
from header_data;


## OCR Status Description
select invoice_id, OCR_status,
	case
		when OCR_status ="Success" then "Processed Successfully"
        when OCR_status ="Partial" then "Needs Manual Review"
        else "Processing Failed"
	end as Status_Description
from header_data;



## Subqueries
## Invoices Above Average Amount
select invoice_id, vendor_name, total_amount from header_data
where total_amount > (select avg(total_amount) from header_data );

## Vendor with Highest Total Invoice Amount
select vendor_name, sum(total_amount) as Total_invoice_amount from header_data
group by vendor_name having sum(total_amount) = 
(select max(vendor_total) from (select sum(total_amount) as vendor_total from header_data
group by vendor_name) as vendorsummary);

## Vendors Having Line Items
select distinct vendor_name from header_data h
where exists ( select 1 from line_items_data l where h.invoice_id = l.invoice_id);



#### -------------VIEWS-----------------####
use invoice_analytics_db;

##Create Vendor Summary View
create view vendor_summary as
select vendor_name, count(*) as total_invoices, 
sum(total_amount) as Total_invoice_Amount,
avg(Total_amount) as Average_Invoice_Amount
from header_data group by vendor_name;

select * from vendor_summary;

## Create OCR Summary View
create view OCR_summary as
select OCR_Status, count(*) as Total_Invoices,
avg(confidence_score) as average_confidence
from header_data
group by OCR_status;

select * from OCR_summary;


#### ------------------CTE (Common Table Expression) ------------------- #####
use invoice_analytics_db;

## High Value Invoices
with high_values as
(select * from header_data where total_amount >300000) select * from high_values;

### Vendor Sales Using CTE
with vendor_sales as
(select vendor_name, sum(total_amount) as TotalSales from header_data group by vendor_name) 
select * from vendor_sales order by totalsales desc;

### --------ROW_NUMBER-------- ####

## Assigns a unique number to each row.
select invoice_id, vendor_name, total_amount, row_number() over
(order by total_amount desc) as "Row_Number" from header_data;


### ----RANK()----- ###
select * from header_data;
select * from line_items_data;

select invoice_id, vendor_name, total_amount, rank() over
(order by total_amount desc) as Invoice_Rank from header_data;

## ----DENSE_RANK()----- ###
select invoice_id,vendor_name,total_amount, dense_rank() over
(order by total_amount desc) as "dense_rank" from header_data;

## Vendor-wise Ranking (It restarts numbering for each vendor)
select vendor_name, total_amount, row_number() over
(partition by vendor_name order by total_amount desc) as vendor_rank from header_data;



