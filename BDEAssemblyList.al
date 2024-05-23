page 50106 BDEAssemblyList
{
    ApplicationArea = All;
    Caption = 'BDE Assembly List';
    PageType = List;
    SourceTable = BDEAssemblyHeader;
    UsageCategory = Lists;
    CardPageID = BDEAssemblyPage;
    Editable = false;
    QueryCategory = 'BDE Assembly List';
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Assembly No."; Rec."Assembly No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Type"; Rec."Assembly Type ")
                {
                    ToolTip = 'Specifies the Assembly Type.';
                }

                field("Assembly Description"; Rec."Assembly Description")
                {
                    ToolTip = 'Specifies the value of the Total of Cartons for Order field.';
                }
                field("Item Number"; Rec."Item Number")
                {
                    ToolTip = 'Specifies the Item to be Assembled/Dis-Assembled.';
                }
            }

        }

    }
    actions
    {
        // area(Creation)
        // {
        //     action(New)
        //     {

        //     }
        // }
    }
}
