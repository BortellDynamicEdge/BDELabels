table 70389526 "BDELabelLines"
{
    Caption = 'BDE Labels';
    DataCaptionFields = "Document No.";
    //DrillDownPageID = "Chart of Accounts";
    //LookupPageID = "G/L Account List";


    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        //field(1; "Document Type"; Code[20])
        {
            Caption = 'Document Type';
        }

        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            // TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "ItemCartonNo"; Integer)
        {
            Caption = 'Item Carton Number';
        }

        field(5; ItemCartonCount; Integer)
        {
            Caption = 'Total of Cartons for Item';
        }
        field(6; OrderCartonNo; Integer)
        {
            Caption = 'Order Carton Number';

        }

        field(7; ItemNumber; code[20])
        {
            Caption = 'Item Number';
        }
        field(8; ItemDescription; code[20])
        {
            Caption = 'Item Description';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(10; OrderQuantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(11; DocumentDate; Date)
        {
            Caption = 'Delivery Date';
        }

        field(12; BestBeforeDate; Date)
        {
            Caption = 'Best Before Date';
        }
        field(13; UofM; Code[20])
        {
            Caption = 'Unit Of Measure';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.", ItemCartonNo)
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Document No.")
        {
            Unique = false;
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
    local procedure OnAfterOnInsert(var Item: Record BDELabelLines)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnModify(var Item: Record BDELabelLines)
    begin
    end;
}