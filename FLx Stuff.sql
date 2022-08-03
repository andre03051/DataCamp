-- While Loop for Hierarchy
WITH BOM AS (
    SELECT 
        C.ParentItemInventoryID, 
        C.ChildItemInventoryID, 
        1 as 'Level'
    FROM Containments C
    WHERE C.ParentItemInventoryID IN (
        SELECT TOP 10 II.ID
        FROM ItemInventories II
        WHERE II.Identifier LIKE 'GPG00100%'
        ORDER BY II.Identifier DESC
    )
    AND C.ChildItemInventoryID IS NOT NULL

    UNION ALL

    SELECT 
        X.ParentItemInventoryID, 
        X.ChildItemInventoryID, 
        BOM.Level+1 as 'Level'
    FROM BOM
    JOIN Containments AS X ON X.ParentItemInventoryID = BOM.ChildItemInventoryID
)
SELECT 
    P.Identifier AS 'Parent',
    C.Identifier AS 'Child',
    BOM.[Level]
FROM BOM

LEFT JOIN ItemInventories P on BOM.ParentItemInventoryID = P.ID
LEFT JOIN ItemInventories C on BOM.ChildItemInventoryID = C.ID
ORDER BY Level, Parent

------------------------------------------------------------------------------------------------------------------------------------------------
-- First Pass Yield: BatchRouteStatuses.TransactionCount > 1
