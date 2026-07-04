# Invoice Analystics Project
# Tool: Python


# Import Libraries
import pandas as pd
import matplotlib.pyplot as plt

# Read CSV files
header_df = pd.read_csv("Header_Data.csv")
line_df = pd.read_csv("line_Items_Data.csv")

# # Display First Five Records
# print(header_df.head())
# print(line_df.head())

# # Check Dataset Shape
# print(header_df.shape)
# print(line_df.shape)

# # Display Column Names
# print(header_df.columns)
# print(line_df.columns)

# # Check Data Types
# print(header_df.info())
# print(line_df.info())
# print(header_df.dtypes)

# # Summary Statistics
# print(header_df.describe())
# print(line_df.describe())

# # Check Missing Values
# print(header_df.isnull().sum())
# print(line_df.isnull().sum())

# #Check Duplicate Records
# print("Header Data Duplicates:",header_df.duplicated().sum())
# print("Line Data Duplicates:", line_df.duplicated().sum())

# # Check Duplicate Invoice IDs
# print(header_df["Invoice_ID"].duplicated().sum())

# # Convert Invoice_Date to Date Format
# header_df["Invoice_Date"]=pd.to_datetime(header_df["Invoice_Date"])
# print(header_df.dtypes)

# # Check Date Range
# print(header_df["Invoice_Date"].min())
# print(header_df["Invoice_Date"].max())

# # Total Number of Invoices
# print("Total Invoices:", header_df["Invoice_ID"].count())

# # Total Invoice Amount
# print("Total Invoice Amount:",header_df["Total_Amount"].sum())

# # Average Invoice Amount
# print("Average Invoice Amount:",header_df["Total_Amount"].mean())

# # Highest & Lowest Invoice Amount
# print("Highest Invoice Amt:",header_df["Total_Amount"].max())
# print("Lowest Invoice Amt:",header_df["Total_Amount"].min())

# # Vendor-wise Invoice Count
# print(header_df.groupby("Vendor_Name")["Invoice_ID"].count())

# # Total distinct vendor name
# print(header_df["Vendor_Name"].nunique())

# # Vendor-wise Total Invoice Amount
# print(header_df.groupby("Vendor_Name")["Total_Amount"].sum())

# # OCR Status Summary
# print(header_df["OCR_Status"].value_counts())

# # Vendor-wise Invoice Count (Bar Chart)
# vendor_count = header_df.groupby("Vendor_Name")["Invoice_ID"].count()
# vendor_count.plot(kind="barh", figsize=(10,5))
# plt.title("Vendor-wise Invoice Count")
# plt.xlabel("Vendor Name")
# plt.ylabel("Number of Invoices")
# plt.xticks(rotation=45)
# plt.show()

# # OCR Status Distribution(Pie Chart)
# header_df["OCR_Status"].value_counts().plot(kind="pie",autopct="%1.1f%%")
# plt.title("OCR Status Distribution")
# plt.ylabel("")
# plt.show()

# # Invoice Amount Distribution (Histogram)
# header_df["Total_Amount"].plot(kind="hist", bins=20)
# plt.title("Invoice Amount Distribution")
# plt.xlabel("Invoice Amount")
# plt.show()

# # Confidence Score Distribution
# header_df["Confidence_Score"].plot(kind="hist",bins=15)
# plt.title("Confidence Score Distribution")
# plt.xlabel("Confidence Score")
# plt.show()

# # Top 10 Vendors by Invoice Amount
# top_vendors=header_df.groupby("Vendor_Name")["Total_Amount"].sum().sort_values(ascending=False).head(10)
# top_vendors.plot(kind="bar")
# plt.title("Top 10 Vendors by Invoice Amount")
# plt.xlabel("Vendor Name")
# plt.ylabel("Total Amount")
# plt.xticks(rotation=45)
# plt.show()

# # Merge Header Data and Line Item Data
# merged_df=pd.merge(header_df,line_df,on="Invoice_ID",how="inner")
# print(merged_df.head())

# # heck Merged Data Shape
# print(merged_df.shape)

# # Vendor-wise Total Quantity
# print(merged_df.groupby("Vendor_Name")["Quantity"].sum())

# # Most Purchased Items
# print(merged_df.groupby("Item_Description")["Quantity"].sum().sort_values(ascending=False))

# # Top 10 Highest Value Line Items
# print(merged_df.sort_values(by="Line_Total_Amount",ascending=False).head(10))

# # Export Merged Data
# merged_df.to_excel("output/Merged_Invoice_Report.xlsx",index=False)
# print("Merged Report Exported Successfully")


# ## Read Data from MySQL
# import pandas as pd
# from sqlalchemy import create_engine
# from sqlalchemy.engine import URL

# connection_url = URL.create(
#     drivername="mysql+pymysql",
#     username="root",
#     password="Mahesh@123",
#     host="localhost",
#     port=3306,
#     database="invoice_analytics_db"
# )

# engine = create_engine(connection_url)
# header_df = pd.read_sql("SELECT * FROM header_data", engine)

# print(header_df.head())