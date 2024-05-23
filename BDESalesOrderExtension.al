pageextension 50100 "BDELabelsExtension" extends "Sales Order"

//pageextension 70389540 "BDELabelsExtension" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Adding a new action group 'MyNewActionGroup' in the 'Creation' area
        addlast("O&rder")
        {
            action(Labels)
            {
                ApplicationArea = All;
                Caption = 'BDE Shipping Labels';
                Visible = true;

                trigger OnAction();
                var
                    ok: Boolean;

                    lbl: Page "BDE Labels";
                    lbltbl: Record BDELabelHeader;
                begin

                    ok := lbltbl.Get(Rec."Document Type", Rec."No.");
                    if not ok then begin
                        lbltbl.Init();
                        lbltbl."Document Type" := Rec."Document Type";
                        lbltbl."Document No." := Rec."No.";
                        lbltbl.CustomerName := Rec."Bill-to Name";
                        lbltbl.Reference := Rec."External Document No.";
                        lbltbl.Run := Rec."Shipment Method Code";
                        lbltbl.OrderCartonCount := 0;
                        lbltbl.Insert()
                    end;
                    //lbl.PageOpen(Rec."No.");
                    lbl.SetRecord(lbltbl);
                    //lbl.SetTableView(lbltbl);

                    lbl.Run();
                    //Message('My message');
                end;
            }
        }
        addlast(Category_Category8)
        {
            actionref(Labels_Promoted; Labels)
            {

            }
        }
    }


}
