page 50104 BDELabelHeaders
//page 70389543 BDELabelHeaders
{
    ApplicationArea = All;
    Caption = 'BDELabelHeaders';
    PageType = List;
    SourceTable = BDELabelHeader;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(CustomerName; Rec.CustomerName)
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(OrderCartonCount; Rec.OrderCartonCount)
                {
                    ToolTip = 'Specifies the value of the Total of Cartons for Order field.';
                }
                field(Reference; Rec.Reference)
                {
                    ToolTip = 'Specifies the value of the Order Reference Number field.';
                }
                field(Run; Rec.Run)
                {
                    ToolTip = 'Specifies the value of the Run Number field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }
    }
}
