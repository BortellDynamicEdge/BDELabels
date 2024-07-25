page 50103 BDELabelCartons
//page 70389542 BDELabelCartons
{
    ApplicationArea = All;
    Caption = 'BDE Label Cartons';
    PageType = Worksheet;
    SourceTable = BDELabelCartons;

    //SourceTableView = WHERE("Document No." = CONST('1051'));

    layout
    {

        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(CartonSize; Rec.CartonSize)
                {
                    ToolTip = 'Specifies the value of the Item Carton Size field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

    end;

    procedure SetParameters(docnumber: code[20])
    begin
        DocumementNumberFilter := docnumber;
        Rec.SetRange("Document No.", docnumber);
    end;

    var
        DocumementNumberFilter: code[20];
}
