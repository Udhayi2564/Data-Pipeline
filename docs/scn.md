# SCN / LO / HI Documentation

## SCN (System Change Number)
Oracle's internal LSN/transaction ID identifying a consistent database change point.

## LO (Lower Boundary)
Lower boundary of extraction range.

## HI (Upper Boundary)
Upper boundary of extraction range.

## Batch SCN Usage
SELECT ... FROM HR.SEATUNNEL_ORDERS AS OF SCN <SCN>

## Range Extraction
WHERE ORDER_ID >= LO AND ORDER_ID < HI