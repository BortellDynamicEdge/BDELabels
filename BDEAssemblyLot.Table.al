table 50107 "BDE Assembly Lot"
{
    Caption = 'BDE Assembly Lot';
    DataCaptionFields = "Assembly No.";
    DataClassification = AccountData;
    TableType = Temporary;

    fields
    {
        field(1; "Assembly No."; Code[20])
        {
            Caption = 'Assembly No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(6; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
    }
    keys
    {
        key(PK; "Assembly No.", "Line No.", "Item Ledger Entry No.")
        {
            Clustered = true;
        }
    }
}
