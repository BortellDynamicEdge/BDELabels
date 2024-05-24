page 50102 BDEAssemblyPage
{
    ApplicationArea = All;
    Caption = 'BDE Assembly';
    PageType = Card;
    SourceTable = BDEAssemblyHeader;
    DelayedInsert = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("BOM No."; Rec."Assembly No.")
                {
                    ToolTip = 'The unique identifier for the operation.';
                }
                field("Type"; Rec."Assembly Type ")
                {
                    ToolTip = 'Specifies the type of assembly.';
                }
                field("Description"; Rec."Assembly Description")
                {
                    ToolTip = 'Description for the (dis)assembly operation.';
                }
                field("Item Number"; Rec."Item Number")
                {
                    Lookup = true;
                    LookupPageId = "Item Lookup";
                    ToolTip = 'Specifies the Item Number.';
                }
                field("Unit"; Rec."UofM")
                {
                    ToolTip = 'Specifies the Unit of Measure.';
                }
                field("Usage Type"; Rec."Item Usage Type")
                {
                    ToolTip = 'Specifies the Item Usage Type.';
                }
                field("Quantity"; Rec."Quantity")
                {
                    Caption = 'Quantity/Weight';
                    ToolTip = 'Specifies the Quantity Used.';
                }
                field("Production Quantity"; Rec."Production Quantity")
                {
                    ToolTip = 'The Production Quantity for the operation.';
                }
                field("Item Cost"; Rec."Item Cost")
                {
                    ToolTip = 'Specifies the value of the Item Cost field.';
                }

            }
            part(BOMGrid; "BDEAssemblySubform")
            {
                ApplicationArea = Basic, Suite;
                // Editable = IsSalesLinesEditable;
                //Enabled = IsSalesLinesEditable;
                SubPageLink = "Assembly No." = FIELD("Assembly No.");

                UpdatePropagation = Both;
            }
        }
    }

    var
        BOM: Record BDEAssemblyHeader;

    trigger OnAfterGetRecord()
    begin
        // label.Reset();
        // label.SetRange("Document Type", Rec."Document Type");
        // label.SetRange("Document No.", Rec."Document No.");
        // if (label.FindSet() = false) then begin
        //     Generatelbls();
        // end;
    end;

    trigger OnOpenPage()
    begin
        // BOM.Init();
        // BOM."BOM No." := '1222';
        // BOM.Insert()
    end;


}
