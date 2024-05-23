table 50106 "BDEAssemblyLines"
//table 70389541 "BDELabelLines"
{
    Caption = 'BDE Assembly Lines';
    DataCaptionFields = "Assembly No.";
    //DrillDownPageID = "Chart of Accounts";
    //LookupPageID = "G/L Account List";

    fields
    {

        field(1; "Assembly No."; Code[20])
        {
            Caption = 'Assembly No.';
            TableRelation = "BDEAssemblyHeader"."Assembly No." WHERE("Assembly No." = FIELD("Assembly No."));
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';

        }
        field(3; "Item No"; Code[20])
        {
            Caption = 'Assembly/Dis-Assembly Item Number';
            TableRelation = Item;
        }
        field(4; UofM; Code[10])
        {
            Caption = 'Assembly/Dis-Assembly Unit Of Measure';
            TableRelation = "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("Item No"));
        }
        field(5; "Item Description"; code[50])
        {
            Caption = 'Item Description';
        }
        field(6; "Item Usage Type"; enum BDEAssemblyUsage)
        {
            Caption = 'Item Description';
        }
        field(7; "Quantity"; Decimal)
        {
            Caption = 'Item Weight';
        }
        field(8; "Unit Cost"; Decimal)
        {
            Caption = 'Item Unit Cost';
        }

        field(9; "Labour Cost"; Decimal)
        {
            Caption = 'Labour Cost';
        }

    }

    keys
    {
        key(Key1; "Assembly No.", "Line No.")
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
    local procedure OnAfterOnInsert(var Item: Record BDEAssemblyLines)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnModify(var Item: Record BDEAssemblyLines)
    begin
    end;
}