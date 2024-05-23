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
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';

                    trigger OnValidate()
                    var
                    //myInt: Integer;
                    begin
                        if Rec."Assembly No." = '' then begin
                            Message('Please enter a valid no.');
                        end;
                    end;
                }
                field("Assembly Type"; Rec."Assembly Type ")
                {
                    ToolTip = 'Specifies the type of assembly';
                }
                field("Assembly Description"; Rec."Assembly Description")
                {
                    ToolTip = 'Specifies the value of the Total of Cartons for Order field.';
                }
                field("Item Number"; Rec."Item Number")
                {
                    ToolTip = 'Specifies the Item Number.';
                }
                field("Unit Of Measure"; Rec."UofM")
                {
                    ToolTip = 'Specifies the value of the Unit OF Measure.';
                }
                field("Usage Type"; Rec."Item Usage Type")
                {
                    ToolTip = 'Specifies the Item Usage Type.';
                }

                field("Quantity"; Rec."Quantity")
                {
                    ToolTip = 'Specifies the Quantity Used.';
                }
                field("Production Quantity"; Rec."Production Quantity")
                {
                    ToolTip = 'Specifies the value of the Production Quantity Required.';
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
