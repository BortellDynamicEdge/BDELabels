
table 50103 "BDELabelCartons"
//table 70389542 "BDELabelCartons"
{
    Caption = 'BDE Label Carton Sizes';
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
            TableRelation = BDELabelHeader WHERE("Document Type" = FIELD("Document Type"), "Document No." = field("Document No."));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "CartonSize"; Integer)
        {
            Caption = 'Item Carton Size';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
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
    local procedure OnAfterOnInsert(var Item: Record BDELabelCartons)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterOnModify(var Item: Record BDELabelCartons)
    begin
    end;
}