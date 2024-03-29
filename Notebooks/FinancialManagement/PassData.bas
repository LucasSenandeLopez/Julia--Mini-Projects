Option Explicit

Sub passData()

    Dim company As Integer
    Dim year As Integer
    Dim iteration As Integer
    Dim Val As Variant
    Dim sheetName As String
    Dim metricNames() As Variant
    
    metricNames = Array("Assets", "BVE", "NI", "MarketCap", "RoE", "RoA", "Price", "EnterpriseValue", "CommonSharesOutstanding", "Cash", "EBIT")
    
    sheetName = "Results"
    
    If Sheets.Count = 2 Then
    
        For company = 1 To 5
            
            Sheets.Add , After:=Sheets(Sheets.Count)
            
            sheetName = Application.Worksheets("Results").Cells(company + 1, 2).Value
            
            ActiveSheet.Name = sheetName
        
            Worksheets("Results").Activate
        
        Next
        
    End If


    For iteration = 0 To 10

        For company = 1 To 5
        
            For year = 1 To 10
            
                Val = Sheets(2).Cells(company + 1, 10 * iteration + 2 + year).Value
                
                If ((iteration = 4) Or (iteration = 5)) And Not (Val = "n.a.") Then Val = Val / 100

                Sheets(company + 2).Cells(iteration + 2, year + 1).Value = Val
             
            Next
            
        
        Next

    Next
    
    For company = 1 To 5
    
        Sheets(company + 2).Select
    
        For year = 2014 To 2023
        
            Cells(1, year - 2012).Value = year
            
            Cells(year - 2012, 1).Value = metricNames(year - 2014)
    
        Next
        
            Cells(12, 1) = metricNames(10)
            
            Range("A1:L11").Value = Application.WorksheetFunction.Transpose(Range("A1:K12"))
            Range("A12:L12").ClearContents
            Sheets(company + 2).Columns.AutoFit
    
    Next



End Sub