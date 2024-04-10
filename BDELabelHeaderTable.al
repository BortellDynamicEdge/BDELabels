table 70389525 "BDELabelHeader"
{
    Caption = 'BDE Label Header';
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

        field(3; OrderCartonCount; Integer)
        {
            Caption = 'Total of Cartons for Order';
        }

        field(4; CustomerName; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(5; Reference; Text[30])
        {
            Caption = 'Order Reference Number';
        }
        field(6; Run; CODE[20])
        {
            Caption = 'Run Number';
        }

    }

    keys
    {
        key(Key1; "Document Type", "Document No.")
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
    local procedure OnAfterOnInsert(var Item: Record BDELabelHeader)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnModify(var Item: Record BDELabelHeader)
    begin
    end;
}