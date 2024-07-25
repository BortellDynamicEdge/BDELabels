table 50106 "BDEAssemblyLines"
//table 70389541 "BDELabelLines"
{
    Caption = 'BDE Assembly Lines';
    DataCaptionFields = "Assembly No.";

    fields
    {

        field(1; "Assembly No."; Code[20])
        {
            Caption = 'Assembly No.';
            NotBlank = true;
            TableRelation = "BDEAssemblyHeader"."Assembly No." WHERE("Assembly No." = FIELD("Assembly No."));
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Item No"; Code[20])
        {
            Caption = 'Item Number';
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                CopyFromItem();
            end;
        }
        field(4; UofM; Code[10])
        {
            Caption = 'Unit';
            TableRelation = "Item Unit of Measure"."Code" WHERE("Item No." = FIELD("Item No"));
        }
        field(5; "Item Description"; code[50])
        {
            Caption = 'Description';
        }
        field(6; "Item Usage Type"; enum BDEAssemblyUsage)
        {
            Caption = 'Item Usage Type';
        }
        field(7; "Quantity"; Decimal)
        {
            Caption = 'Quantity/Weight';
            DecimalPlaces = 0 : 5;
        }
        field(8; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DecimalPlaces = 0 : 5;
        }

        field(9; "Labour Cost"; Decimal)
        {
            Caption = 'Labour Cost';
        }
        field(10; "Total Quantity"; Decimal)
        {
            Caption = '(Dis)Assembly Total';
            DecimalPlaces = 0 : 5;
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

    local procedure CopyFromItem()
    var
        Item: Record Item;
    begin
        GetItem(Item);
        "Item Description" := Item.Description;
    end;

    procedure GetItem(var Item: Record Item)
    begin
        TestField("Item No");
        Item.Get("Item No");
    end;
}