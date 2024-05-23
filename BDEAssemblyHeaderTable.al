table 50105 "BDEAssemblyHeader"
{
    Caption = 'BDE Assembly Header';
    DataCaptionFields = "Assembly No.";
    //DrillDownPageID = "Chart of Accounts";
    //LookupPageID = "G/L Account List";

    fields
    {

        field(1; "Assembly No."; Code[20])
        {
            Caption = 'Assembly No.';
            NotBlank = true;
        }
        field(2; "Assembly Type "; enum BDEAssemblyType)
        {
            Caption = 'Assembly Type';
        }

        field(3; "Assembly Description"; Text[100])
        {
            Caption = 'Assembly Description';
        }

        field(4; "Item Number"; Code[20])
        {
            Caption = 'Assembly/Dis-Assembly Item Number';
            TableRelation = Item; // WHERE("No." = "Item Number") 
        }

        field(5; "UofM"; Code[10])
        {
            Caption = 'Assembly/Dis-Assembly Unit of Measure';
            TableRelation = "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("Item Number"));
        }
        field(6; "Item Usage Type"; enum BDEAssemblyUsage)
        {
            Caption = 'Assembly/Dis-Assembly Unit of Measure';
        }
        field(7; "Item Cost"; Decimal)
        {
            Caption = 'Item Cost';
        }
        field(8; "Quantity"; Decimal)
        {
            Caption = 'Qauntity Per Each';
        }
        field(9; "Production Quantity"; Integer)
        {
            Caption = 'Production Quantity';
        }

        // field(10; "Wasteage"; Decimal)
        // {
        //     Caption = 'Wasteage Weight';
        // }
        // field(11; "Batch Number"; Code[20])
        // {
        //     Caption = 'Assembly Batch number';
        // }
    }

    keys
    {
        key(Key1; "Assembly No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
    // bde: Codeunit BDEEndPoints;

    trigger OnInsert()
    begin
        // bde.SetRecordToProcess(id);
        OnAfterOnInsert(Rec)
    end;

    trigger OnModify()
    begin
        OnAfterOnModify(Rec)
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnInsert(var Item: Record BDEAssemblyHeader)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnModify(var Item: Record BDEAssemblyHeader)
    begin
    end;
}