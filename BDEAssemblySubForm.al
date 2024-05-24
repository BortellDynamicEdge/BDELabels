page 50105 BDEAssemblySubForm
{
    ApplicationArea = All;
    Caption = 'BDE Assembly Items';
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = BDEAssemblyLines;
    UsageCategory = Lists;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Usage Type"; Rec."Item Usage Type")
                {
                    ToolTip = 'Specifies the Item Usage Type.';
                }
                field("Item No"; Rec."Item No")
                {
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Item Carton Number field.';
                }
                field(UofM; Rec.UofM)
                {
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Unit Of Measure field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field("Quantity"; Rec."Quantity")
                {
                    ToolTip = 'Specifies the value of the Output Item Weight per each field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Item Unit Cost field.';
                }
                field("Labour Cost"; Rec."Labour Cost")
                {
                    ToolTip = 'Specifies the value of the Labour Cost field.';
                }
            }
        }
    }
}
