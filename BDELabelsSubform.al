page 70389526 BDELabelsSubform
{
    Caption = 'Labels';
    PageType = ListPart;
    SourceTable = BDELabelLines;
    UsageCategory = None;
    //AutoSplitKey = true;


    layout
    {
        area(content)
        {
            group(General)
            {


                field("Document Type"; Rec."Document Type")
                {

                }
                field("Document No."; Rec."Document No.")
                {

                }
            }
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(ItemNumber; Rec.ItemNumber)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Number field.';
                }
                field(ItemCartonNo; Rec.ItemCartonNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Carton Number field.';
                }
                field(ItemCartonCount; Rec.ItemCartonCount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total of Cartons for Item field.';
                }
                field(ItemDescription; Rec.ItemDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Number field.';
                }
                field(UofM; Rec.UofM)
                {
                    ApplicationArea = all;
                    ToolTip = 'Unit Of Measure';
                }
                field(OrderCartonNo; Rec.OrderCartonNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Carton Number field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(DocumentDate; Rec.DocumentDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Delivery Date field.';
                }
                field(BestBeforeDate; Rec.BestBeforeDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Delivery Date field.';
                }
            }
        }
    }

    actions
    {
        // area(Processing)
        // {
        //     action(Generate)
        //     {
        //         ApplicationArea = All;
        //         trigger OnAction()
        //         begin
        //           //  Generatelbls();
        //         end;
        //     }
        // }
        // area(Promoted)
        // {
        //     actionref(GenerateLabels; Generate)
        //     {

        //     }
        // }

    }
    // var
    //     saleslines: Record "Sales Line";
    //     item: Record Item;

    //     label: Record BDELabelLines;

    //     lblheader: Record BDELabelHeader;

    //     currentline: Integer;
    //     currentcount: Integer;
    //     totalcount: Integer;
    //     itemcartons: Integer;
    //     itemexists: Boolean;

    //     ok: Boolean;
    //     itemloop: Integer;

    //     labelsallocated: Decimal;

    // procedure Generatelbls()
    // begin

    //     // Remove all records before generating labels
    //     label.Reset();
    //     label.SetRange("Document Type", Rec."Document Type");
    //     label.SetRange("Document No.", Rec."Document No.");
    //     label.DeleteAll(false);

    //     saleslines.Reset();
    //     saleslines.SetRange("Document Type", Rec."Document Type");
    //     saleslines.SetRange("Document No.", Rec."Document No.");

    //     if (saleslines.FindSet()) then begin
    //         repeat

    //             if (currentline = 0) or (currentline <> saleslines."Line No.") then begin
    //                 currentline := saleslines."Line No.";
    //                 currentcount := 1;
    //                 labelsallocated := 0;
    //             end;
    //             //Message(System.Format(saleslines."Line No.", 0, 0));
    //             item.Reset();
    //             //item.SetRange("No.", saleslines."No.");
    //             itemexists := item.Get(saleslines."No.");
    //             if (itemexists) and (item."Order Multiple" <> 0) then begin
    //                 itemcartons := Round(saleslines.Quantity / item."Order Multiple", 1, '>');
    //                 for itemloop := 1 to itemcartons do begin
    //                     totalcount := totalcount + 1;
    //                     label.Init();
    //                     label."Document Type" := saleslines."Document Type";
    //                     label."Document No." := saleslines."Document No.";
    //                     label."Line No." := saleslines."Line No.";
    //                     label.ItemNumber := saleslines."No.";
    //                     label.ItemCartonNo := itemloop;
    //                     label.ItemCartonCount := itemcartons;
    //                     label.OrderCartonNo := totalcount;
    //                     if (labelsallocated + item."Order Multiple" > saleslines.Quantity) then begin
    //                         label.Quantity := saleslines.Quantity - labelsallocated;
    //                     end else begin
    //                         label.Quantity := item."Order Multiple";
    //                     end;
    //                     label.ItemDescription := saleslines.Description;
    //                     label.DocumentDate := saleslines."Shipment Date";
    //                     label.BestBeforeDate := label.DocumentDate + 6;
    //                     label.Insert();
    //                     currentcount := currentcount + 1;

    //                     labelsallocated := labelsallocated + label.Quantity;
    //                 end;
    //                 // end for itemloop
    //             end;
    //         until (saleslines.Next() = 0);


    //         ok := lblheader.Get(Rec."Document Type", Rec."Document No.");
    //         if ok then begin

    //             lblheader.OrderCartonCount := totalcount;
    //             lblheader.Modify()
    //         end;
    //     end;
    // end;
}
